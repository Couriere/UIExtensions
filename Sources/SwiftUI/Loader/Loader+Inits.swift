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

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension Loader {

	/// Initializes the Loader View with parameters.
	///
	///	When the `input` parameter's value changes,
	///	the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior. Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - reload: Trigger to force reloading after loading error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
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
	///		content: { result, isLoading in
	///			Text( String( result ))
	///		}
	///	)
	/// ```
	///
	init(
		input: Input,
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping ( Input ) async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Result, _ isLoading: Bool ) -> Content
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: action,
			content: { binding, isLoading in content( binding.wrappedValue, isLoading ) }
		)
	}

	/// Initializes the Loader View with parameters.
	///
	///	When the `input` parameter's value changes,
	///	the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior. Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - reload: Trigger to force reloading after loading error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	/// Example:
	/// ```
	///	Loader(
	///		input: boolVariable,
	///		loadingView: ProgressView(),
	///		failureView: FailureView.init,
	///		action: {
	///			try await Task.sleep( for: .seconds( 1 ))
	///			return Int.random( in: 100..<1000 )
	///		},
	///		content: { binding, isLoading in
	///			binding.wrappedValue = binding.wrappedValue * 2
	///			Text( String( binding.wrappedValue ))
	///		}
	///	)
	/// ```
	///
	init(
		input: Input,
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Binding<Result>, _ isLoading: Bool ) -> Content
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: { _ in try await action() },
			content: content
		)
	}

	/// Initializes the Loader View with parameters.
	///
	///	When the `input` parameter's value changes,
	///	the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior. Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - reload: Trigger to force reloading after loading error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	/// Example:
	/// ```
	///	Loader(
	///		input: boolVariable,
	///		loadingView: ProgressView(),
	///		failureView: FailureView.init,
	///		action: {
	///			try await Task.sleep( for: .seconds( 1 ))
	///			return Int.random( in: 100..<1000 )
	///		},
	///		content: { result, isLoading in
	///			Text( String( result ))
	///		}
	///	)
	/// ```
	///
	init(
		input: Input,
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Result, _ isLoading: Bool ) -> Content
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: { _ in try await action() },
			content: { binding, isLoading in content( binding.wrappedValue, isLoading ) }
		)
	}

	/// Initializes the Loader with no parameters for data loading.
	///
	/// Data may be reloaded only when view appears on screen.
	///
	/// - Parameters:
	///   - reloadOptions: Options controlling the reloading behavior. Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - reload: Trigger to force reloading after loading error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	/// Example:
	/// ```
	///	Loader(
	///		loadingView: ProgressView(),
	///		failureView: FailureView.init,
	///		action: {
	///			try await Task.sleep( for: .seconds( 1 ))
	///			return Int.random( in: 100..<1000 )
	///		},
	///		content: { binding, isLoading in
	///			binding.wrappedValue = binding.wrappedValue * 2
	///			Text( String( binding.wrappedValue ))
	///		}
	///	)
	/// ```
	///
	init(
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Binding<Result>, _ isLoading: Bool ) -> Content
	) where Input == Int {
		self.init(
			input: 0,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: { _ in try await action() },
			content: content
		)
	}

	/// Initializes the Loader with no parameters for data loading.
	///
	/// Data may be reloaded only when view appears on screen.
	///
	/// - Parameters:
	///   - reloadOptions: Options controlling the reloading behavior. Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - reload: Trigger to force reloading after loading error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	/// Example:
	/// ```
	///	Loader(
	///		loadingView: ProgressView(),
	///		failureView: FailureView.init,
	///		action: {
	///			try await Task.sleep( for: .seconds( 1 ))
	///			return Int.random( in: 100..<1000 )
	///		},
	///		content: { result, isLoading in
	///			Text( String( result ))
	///		}
	///	)
	///	```
	///
	init(
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Result, _ isLoading: Bool ) -> Content
	) where Input == Int {
		self.init(
			input: 0,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: { _ in try await action() },
			content: content
		)
	}
}
