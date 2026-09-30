// MIT License
//
// Copyright (c) 2015-present Vladimir Kazantsev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SwiftUI
import UIExtensions

/// Shows a `Loader` together with controls that let the UI test
/// decide when and how every load finishes.
struct LoaderScreen: View {

	enum Variant {
		/// Default reload options: the output is cleared when the input changes.
		case standard
		/// The output is kept while reloading.
		case keepingOutput
		/// A placeholder is shown instead of a loading view.
		case placeholder
		/// The first load waits until the input changes.
		case disableAutoLoad
		/// Data is cleared when the screen reappears and reloads.
		case clearOnAppear
		/// Data loads initially but does not reload when the screen reappears.
		case noReloadOnAppear
		/// Shows whether the content has just replaced the loading view.
		case justLoaded
	}

	private var reloadOptions: ReloadOptions {
		switch variant {
		case .standard, .justLoaded: [ .clearOnReload, .reloadOnAppear ]
		case .keepingOutput: .reloadOnAppear
		case .placeholder: .reloadOnAppear
		case .disableAutoLoad: .disableAutoLoad
		case .clearOnAppear: [ .reloadOnAppear, .clearOnAppear ]
		case .noReloadOnAppear: []
		}
	}

	let variant: Variant

	@State private var loads = PendingLoads()
	@State private var input = 1

	var body: some View {
		NavigationStack {
			VStack( spacing: 0 ) {
				loader
					.frame( maxHeight: .infinity )
				controls
			}
			.navigationTitle( "Loader" )
			.navigationBarTitleDisplayMode( .inline )
		}
	}

	@ViewBuilder
	private var loader: some View {
		switch variant {
		case .placeholder:
			Loader(
				input: input,
				reloadOptions: reloadOptions,
				placeholder: "Placeholder",
				failureView: failureView,
				action: loads.load,
				content: content,
			)

		case .justLoaded:
			Loader(
				input: input,
				reloadOptions: reloadOptions,
				loadingView: Text( "Loading" ).accessibilityIdentifier( LoaderID.loading ),
				failureView: failureView,
				action: loads.load,
				content: justLoadedContent,
			)

		default:
			Loader(
				input: input,
				reloadOptions: reloadOptions,
				loadingView: Text( "Loading" ).accessibilityIdentifier( LoaderID.loading ),
				failureView: failureView,
				action: loads.load,
				content: content,
			)
		}
	}

	private func justLoadedContent(
		_ output: Binding<String>,
		_ state: LoaderContentState,
	) -> some View {
		List {
			Text( output.wrappedValue )
				.accessibilityIdentifier( LoaderID.output )
			Text( state.isJustLoaded ? "Just loaded" : "Idle" )
				.accessibilityIdentifier( LoaderID.state )
			Button( "Edit content" ) { output.wrappedValue += " edited" }
				.accessibilityIdentifier( LoaderID.editContent )
		}
	}

	private func content( _ output: String, _ state: LoaderContentState ) -> some View {
		List {
			Text( output )
				.accessibilityIdentifier( LoaderID.output )
			// Stays readable in the redacted placeholder,
			// so the test can check the state passed to the content.
			Text( state.isPlaceholder ? "Placeholder" : state.isLoading ? "Reloading" : "Idle" )
				.unredacted()
				.accessibilityIdentifier( LoaderID.state )
			Button( "Content action" ) {}
				.accessibilityIdentifier( LoaderID.contentAction )
		}
		.accessibilityIdentifier( LoaderID.list )
		.refreshableLoader { input += 1 }
	}

	private func failureView( _: Error, reload: @escaping () -> Void ) -> some View {
		VStack {
			Text( "Failed" )
				.accessibilityIdentifier( LoaderID.failure )
			Button( "Retry", action: reload )
				.accessibilityIdentifier( LoaderID.retry )
		}
	}

	private var controls: some View {
		VStack( spacing: 12 ) {
			HStack {
				Text( "Input: \( input )" )
					.accessibilityIdentifier( LoaderID.input )
				Text( "Loads: \( loads.count )" )
					.accessibilityIdentifier( LoaderID.loadCount )
				Text( "Pending: \( loads.pendingCount )" )
					.accessibilityIdentifier( LoaderID.pendingCount )
			}
			HStack {
				Button( "Complete" ) { loads.complete() }
					.accessibilityIdentifier( LoaderID.complete )
				Button( "Fail" ) { loads.fail() }
					.accessibilityIdentifier( LoaderID.fail )
				Button( "Change input" ) { input += 1 }
					.accessibilityIdentifier( LoaderID.changeInput )
				NavigationLink( "Details" ) {
					Text( "Details" )
						.accessibilityIdentifier( LoaderID.details )
				}
				.accessibilityIdentifier( LoaderID.openDetails )
			}
			.buttonStyle( .bordered )
		}
		.font( .footnote )
		.padding()
	}
}

/// Suspends every load until ``complete()`` or ``fail()`` is called.
/// A cancelled load finishes immediately with `CancellationError`,
/// like a cancelled network request.
@MainActor
@Observable
private final class PendingLoads {

	private struct Pending {
		let id: Int
		let input: Int
		let continuation: CheckedContinuation<String, Error>
	}

	private struct LoadError: Error {}

	/// The number of started loads.
	private( set ) var count = 0

	private var pending: [Pending] = []

	/// The number of loads waiting to be completed.
	var pendingCount: Int { pending.count }

	/// Completes loads on their own when the app is launched
	/// with ``LoaderID/autoCompleteArgument``.
	private let completesAutomatically = ProcessInfo.processInfo.arguments
		.contains( LoaderID.autoCompleteArgument )

	func load( _ input: Int ) async throws -> String {
		count += 1
		let id = count

		if completesAutomatically {
			try await Task.sleep( for: .milliseconds( 300 ))
			return "Output \( input )"
		}

		return try await withTaskCancellationHandler {
			try await withCheckedThrowingContinuation { continuation in
				pending.append( Pending( id: id, input: input, continuation: continuation ))
			}
		} onCancel: {
			Task { @MainActor in self.cancel( id ) }
		}
	}

	func complete() {
		let completed = pending
		pending = []
		for load in completed {
			load.continuation.resume( returning: "Output \( load.input )" )
		}
	}

	func fail() {
		let failed = pending
		pending = []
		for load in failed {
			load.continuation.resume( throwing: LoadError())
		}
	}

	private func cancel( _ id: Int ) {
		guard let index = pending.firstIndex( where: { $0.id == id }) else { return }
		pending.remove( at: index ).continuation.resume( throwing: CancellationError())
	}
}
