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

/// Options for controlling the behavior of data reloading in the Loader.
public struct ReloadOptions: OptionSet, Sendable {

	public let rawValue: UInt

	public init(rawValue: UInt) {
		self.rawValue = rawValue
	}

	/// Clear data when the ``Loader/input`` parameter's value changes
	/// and a reload is explicitly called.
	/// Data will NOT be cleared if a reload is called
	/// when the view reappears on the screen.
	public static let clearOnReload = ReloadOptions(rawValue: 1 << 0)
	/// Reload data when the view appears.
	public static let reloadOnAppear = ReloadOptions(rawValue: 1 << 1)
	/// Option to clear data when the view appears on the screen.
	/// Data clearing will occur only when the view appears on the screen.
	/// Data will NOT be cleared if a reload is called
	/// when the ``Loader/input`` parameter's value changes.
	public static let clearOnAppear = ReloadOptions(rawValue: 1 << 2)
	/// This flag prevents automatic initial data loading
	/// when a component first appears or if the data
	/// hasn't been loaded yet.
	/// To start loading, change the value
	/// of the ``Loader/input`` parameter.
	/// While the data is loading, a ``Loader/loadingView``
	/// will be displayed.
	public static let disableAutoLoad = ReloadOptions(rawValue: 1 << 3)
}

/// Represents the current state of the loader's content.
/// Used to inform content views about ongoing operations.
public struct LoaderContentState: OptionSet, Sendable {

	public var rawValue: Int
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}

	/// Indicates that a loading operation is currently in progress.
	/// This state can be used to show loading
	/// indicators or disable user interactions.
	public static let loading = LoaderContentState( rawValue: 1 << 0 )

	/// Indicates that a placeholder is currently
	/// being displayed instead of actual content.
	/// This state informs the content view
	/// that it's rendering in placeholder mode.
	public static let placeholder = LoaderContentState( rawValue: 1 << 1 )

	/// Combined state indicating both loading
	/// is in progress and placeholder is being shown.
	/// Useful for displaying skeleton screens
	/// during initial or background loading.
	public static let loadingPlaceholder: LoaderContentState = [ .loading, .placeholder ]

	/// Indicates that the content view has just replaced
	/// the loading view after a completed load.
	/// This flag is set each time the loader switches
	/// from `loadingView` to `contentView`, and is passed
	/// to the content only for the first render after
	/// each such transition.
	public static let justLoaded = LoaderContentState( rawValue: 1 << 2 )

	/// Returns `true` if a loading operation is currently in progress.
	public var isLoading: Bool {
		contains( .loading )
	}

	/// Returns `true` if a placeholder is currently being displayed.
	public var isPlaceholder: Bool {
		contains( .placeholder )
	}

	/// Returns `true` when content has just replaced
	/// the loading view after a completed load.
	/// This happens on each `loadingView` to `contentView`
	/// transition and only for its first render.
	public var isJustLoaded: Bool {
		contains( .justLoaded )
	}
}

/// Generic loader view for handling asynchronous data loading with SwiftUI.
///
/// Note: If you already have existing Loader and/or Failure views, consider creating a
/// small wrapper over Loader or explore the creation of additional constructors to
/// seamlessly integrate your views with the Loader structure.
///
/// Example:
/// ```
/// // Using existing Loader and Failure views:
/// struct MyLoaderWrapper<Input: Equatable, Content: View, Result>: View {
///
/// 	public let input: Input
/// 	public let action: ( Input ) async throws -> Result
/// 	public let content: ( Result ) -> Content
///
/// 	var body: some View {
/// 		Loader(
/// 			input: input,
/// 			reloadOptions: .clearOnReload,
/// 			loadingView: MyLoader(),
/// 			failureView: MyErrorView.init,
/// 			action: action,
/// 			content: content
/// 		)
/// 	}
/// }
/// ```
///
/// Alternatively, extend Loader with custom constructors:
/// ```
/// extension Loader where LoadingView == MyLoader, FailureView == MyErrorView {
/// 	/// Additional constructor with custom parameters
/// 	init(
/// 		input: Input,
/// 		action: @escaping () async throws -> Result,
/// 		@ViewBuilder content: @escaping ( Result ) -> Content
/// 	) {
/// 		Loader(
/// 			input: input,
/// 			reloadOptions: .clearOnReload,
/// 			loadingView: MyLoader(),
/// 			failureView: MyErrorView.init,
/// 			action: action,
/// 			content: content
/// 		)
/// 	}
/// }
/// ```
@MainActor
public struct Loader<Input, Result, LoadingView, FailureView, Content> where Input: Equatable,
	Input: Sendable,
	Result: Sendable,
	LoadingView: View,
	FailureView: View,
	Content: View
{
	/// The input parameter for data loading.
	private let input: Input

	/// Options controlling the reloading behavior.
	private let reloadOptions: ReloadOptions

	/// Asynchronous function to perform data loading.
	private let action: (Input) async throws -> Result

	/// The view to display while loading.
	private let loadingView: LoadingView

	/// View to display when the ``Loader/action`` throws an error.
	/// This view will not be shown when `result` is not `nil`;
	/// in that case, the `content` view will be displayed.
	private let failureView: ( Error, _ reload: @escaping () -> Void ) -> FailureView

	/// ViewBuilder closure for rendering content based on loaded data.
	/// Receives a binding to the result and the current loader state.
	private let content: (Binding<Result>, LoaderContentState) -> Content

	/// Loading action is in progress.
	@State private var isLoading: Bool = false

	/// The result of the data loading process.
	@State private var result: Result?

	/// The error that occurred during data loading.
	@State private var failure: Error?

	/// State to force reload after loading failure.
	@State private var forcedReloadTrigger: Bool = false

	/// Stores transient flags for the `loadingView` to `contentView`
	/// transition outside the main view state, so they do not trigger
	/// an extra body pass at the wrong moment.
	@StateObject private var contentTransitionState = ContentTransitionState()

	/// Initializes the Loader View with specified parameters.
	/// When the value of the `input` parameter changes,
	/// the data will be reloaded based on the chosen `reloadOptions`.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///    Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives a binding to the result and the current loader content state.
	///
	/// Example:
	/// ```
	///	Loader(
	///		input: 1..<100,
	///		loadingView: ProgressView(),
	///		failureView: FailureView.init,
	///		action: { range in
	///			try await Task.sleep( for: .seconds( 1 ))
	///			return Int.random( in: range )
	///		},
	///		content: { binding, state in
	///			Text( String( binding.wrappedValue ))
	///				.opacity( state.contains(.loading) ? 0.5 : 1.0 )
	///		}
	///	)
	/// ```
	///
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping ( Input ) async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Binding<Result>, _ state: LoaderContentState ) -> Content
	) {
		self.input = input
		self.reloadOptions = reloadOptions
		self.loadingView = loadingView
		self.failureView = failureView
		self.action = action
		self.content = content
	}
}

extension Loader: View {

	public var body: some View {

		Group {
			switch ( Binding( $result ), failure ) {

			case ( .some( let binding ), _ ):
				content( binding, contentState )
						.onAppear {
							contentTransitionState
								.isJustLoadedPending = false
						}

			case ( nil, .some( let failure )):
				failureView( failure, { forcedReloadTrigger.toggle() })

			case ( nil, nil ):
				loadingView
			}
		}
		.modifier(
			LoaderOnChangeHelperModifier(
				value: input,
				reloadTrigger: forcedReloadTrigger,
				initial: initialFlag,
				action: performLoad
			)
		)
	}
}

private extension Loader {

	var contentState: LoaderContentState {
		var state: LoaderContentState = isLoading ? .loading : []
		if contentTransitionState.isJustLoadedPending {
			state.insert( .justLoaded )
		}
		return state
	}

	var initialFlag: Bool {

		if reloadOptions.contains( .disableAutoLoad ) && result == nil {
			return false
		}
		else {
			return result == nil || reloadOptions.contains( .reloadOnAppear )
		}
	}

	func performLoad( input: Input, onAppear: Bool ) async {

		failure = nil

		if onAppear {
			if reloadOptions.contains( .clearOnAppear ) {
				result = nil
			}
		} else {
			if reloadOptions.contains( .clearOnReload ) {
				result = nil
			}
		}

		isLoading = true
		defer { isLoading = false }

		do {
			let value = try await action( input )
			contentTransitionState.isJustLoadedPending = result == nil
			result = value
		}
		catch {
			guard !Task.isCancelled else { return }
			failure = error
		}
	}
}

private extension Loader {

	/// Holds one-shot flags related to switching
	/// from `loadingView` to `contentView`.
	@MainActor
	final class ContentTransitionState: ObservableObject {

		/// Becomes `true` whenever `contentView` replaces `loadingView`.
		/// The flag is cleared after the first render of that content.
		/// This property is intentionally not `@Published` so toggling it
		/// does not trigger an extra view update and reintroduce visual artifacts.
		var isJustLoadedPending = false
	}
}
