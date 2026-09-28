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

/// Lets views inside the `Loader` content wait
/// until the current loading operation finishes.
@MainActor
protocol LoaderCompletionAwaiting: AnyObject {
	func waitForCompletion() async
}

extension EnvironmentValues {
	@Entry var loaderCompletion: ( any LoaderCompletionAwaiting )? = nil
}

/// Holds the state of a `Loader` and runs its loading operations.
///
/// The view forwards its lifecycle events (appear, input change,
/// retry after failure, disappear) to the model; the model decides
/// what to clear, starts the loading task and cancels the previous one.
@MainActor
@Observable
final class LoaderModel<Input, Output> where Input: Equatable & Sendable, Output: Sendable {

	/// What started a loading operation.
	enum Reason {
		/// The view appeared on the screen.
		case appear
		/// The input changed or a reload was requested after a failure.
		case reload
	}

	/// The result of the last successful load.
	var output: Output?

	/// The error thrown by the last load, if it failed.
	private( set ) var failure: Error?

	/// A loading operation is in progress.
	private( set ) var isLoading = false

	/// Becomes `true` whenever the output replaces an empty state,
	/// i.e. `contentView` replaces `loadingView`. Cleared after the first
	/// render of that content. The flag is intentionally not observed,
	/// so toggling it does not trigger an extra view update
	/// and reintroduce visual artifacts.
	@ObservationIgnored
	private( set ) var isJustLoadedPending = false

	@ObservationIgnored
	private var task: Task<Void, Never>?

	/// The state passed to the `Loader` content.
	var contentState: LoaderContentState {
		var state: LoaderContentState = isLoading ? .loading : []
		if isJustLoadedPending {
			state.insert( .justLoaded )
		}
		return state
	}

	/// Starts loading when the view appears if the current state and options require it.
	@discardableResult
	func onAppear(
		_ input: Input,
		options: ReloadOptions,
		action: @escaping ( Input ) async throws -> Output,
	) -> Task<Void, Never>? {
		if output == nil {
			guard !options.contains( .disableAutoLoad ) else { return nil }
		} else {
			guard options.contains( .reloadOnAppear ) else { return nil }
		}
		return load( input, reason: .appear, options: options, action: action )
	}

	/// Starts loading and cancels the operation in progress, if any.
	///
	/// - Returns: The task performing the load.
	@discardableResult
	func load(
		_ input: Input,
		reason: Reason,
		options: ReloadOptions,
		action: @escaping ( Input ) async throws -> Output,
	) -> Task<Void, Never> {

		task?.cancel()

		failure = nil
		if options.contains( reason == .appear ? .clearOnAppear : .clearOnReload ) {
			output = nil
		}
		isLoading = true

		let task = Task { await perform( input, action: action ) }
		self.task = task
		return task
	}

	/// Cancels the operation in progress, if any.
	func cancel() {
		task?.cancel()
		task = nil
		isLoading = false
	}

	/// Marks the content as rendered after a transition from the loading view.
	func contentDidAppear() {
		isJustLoadedPending = false
	}

	private func perform( _ input: Input, action: ( Input ) async throws -> Output ) async {

		let result: Result<Output, Error>
		do {
			result = try .success( await action( input ))
		}
		catch {
			result = .failure( error )
		}

		// A cancelled operation was superseded by a new load
		// or by `cancel()`, which already updated the state.
		guard !Task.isCancelled else { return }

		isLoading = false
		switch result {
		case .success( let value ):
			isJustLoadedPending = output == nil
			output = value
		case .failure( let error ):
			failure = error
		}
	}
}

// MARK: LoaderCompletionAwaiting

extension LoaderModel: LoaderCompletionAwaiting {

	func waitForCompletion() async {
		await task?.value
	}
}
