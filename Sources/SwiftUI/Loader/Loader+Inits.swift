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

extension Loader {

	/// Initializes the Loader View with specified parameters.
	/// When the value of the `input` parameter changes,
	/// the data will be reloaded based on the chosen `reloadOptions`.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives the result value and the current loader content state.
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
	///		content: { result, state in
	///			Text( String( result ))
	///				.opacity( state.contains(.loading) ? 0.5 : 1.0 )
	///		}
	///	)
	/// ```
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping ( Input ) async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Result, _ state: LoaderContentState ) -> Content
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: action,
			content: { binding, state in content( binding.wrappedValue, state ) }
		)
	}

	/// Initializes the Loader View with specified parameters.
	/// When the value of the `input` parameter changes,
	/// the data will be reloaded based on the chosen `reloadOptions`.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives only the result value without state information.
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
	///		content: { result in
	///			Text( String( result ))
	///		}
	///	)
	/// ```
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping ( Input ) async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Result ) -> Content
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: action,
			content: { binding, _ in content( binding.wrappedValue ) }
		)
	}





	/// Initializes the Loader View with specified parameters.
	/// When the value of the `input` parameter changes,
	/// the data will be reloaded based on the chosen `reloadOptions`.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives a binding to the result and the current loader content state.
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
	///		content: { binding, state in
	///			binding.wrappedValue = binding.wrappedValue * 2
	///			Text( String( binding.wrappedValue ))
	///				.opacity( state.contains(.loading) ? 0.5 : 1.0 )
	///		}
	///	)
	/// ```
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Binding<Result>, _ state: LoaderContentState ) -> Content
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

	/// Initializes the Loader View with specified parameters.
	/// When the value of the `input` parameter changes,
	/// the data will be reloaded based on the chosen `reloadOptions`.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives a binding to the result without state information.
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
	///		content: { binding in
	///			binding.wrappedValue = binding.wrappedValue * 2
	///			Text( String( binding.wrappedValue ))
	///		}
	///	)
	/// ```
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Binding<Result> ) -> Content
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: { _ in try await action() },
			content: { result, _ in content( result ) }
		)
	}






	/// Initializes the Loader View with specified parameters.
	/// When the value of the `input` parameter changes,
	/// the data will be reloaded based on the chosen `reloadOptions`.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives the result value and the current loader content state.
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
	///		content: { result, state in
	///			Text( String( result ))
	///				.opacity( state.contains(.loading) ? 0.5 : 1.0 )
	///		}
	///	)
	/// ```
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Result, _ state: LoaderContentState ) -> Content
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: { _ in try await action() },
			content: { binding, state in content( binding.wrappedValue, state ) }
		)
	}

	/// Initializes the Loader View with specified parameters.
	/// When the value of the `input` parameter changes,
	/// the data will be reloaded based on the chosen `reloadOptions`.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives only the result value without state information.
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
	///		content: { result in
	///			Text( String( result ))
	///		}
	///	)
	/// ```
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Result ) -> Content
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: { _ in try await action() },
			content: { binding, _ in content( binding.wrappedValue ) }
		)
	}





	/// Initializes the Loader with no parameters for data loading.
	/// Data may be reloaded only when view appears on screen.
	///
	/// - Parameters:
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives a binding to the result and the current loader content state.
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
	///		content: { binding, state in
	///			binding.wrappedValue = binding.wrappedValue * 2
	///			Text( String( binding.wrappedValue ))
	///				.opacity( state.contains(.loading) ? 0.5 : 1.0 )
	///		}
	///	)
	/// ```
	///
	@inlinable
	public init(
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Binding<Result>, _ state: LoaderContentState ) -> Content
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
	/// Data may be reloaded only when view appears on screen.
	///
	/// - Parameters:
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives a binding to the result without state information.
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
	///		content: { binding in
	///			binding.wrappedValue = binding.wrappedValue * 2
	///			Text( String( binding.wrappedValue ))
	///		}
	///	)
	/// ```
	///
	@inlinable
	public init(
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Binding<Result> ) -> Content
	) where Input == Int {
		self.init(
			input: 0,
			reloadOptions: reloadOptions,
			loadingView: loadingView,
			failureView: failureView,
			action: { _ in try await action() },
			content: { result, _ in content( result ) }
		)
	}





	/// Initializes the Loader with no parameters for data loading.
	/// Data can only be reloaded when the view appears on the screen.
	///
	/// - Parameters:
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives the result value and the current loader content state.
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
	///		content: { result, state in
	///			Text( String( result ))
	///				.opacity( state.contains(.loading) ? 0.5 : 1.0 )
	///		}
	///	)
	///	```
	///
	@inlinable
	public init(
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Result, _ state: LoaderContentState ) -> Content
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
	/// Data can only be reloaded when the view appears on the screen.
	///
	/// - Parameters:
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.clearOnReload, .reloadOnAppear]`.
	///   - loadingView: The view to display while loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///    Receives only the result value without state information.
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
	///		content: { result in
	///			Text( String( result ))
	///		}
	///	)
	///	```
	///
	@inlinable
	public init(
		reloadOptions: ReloadOptions = [ .clearOnReload, .reloadOnAppear ],
		loadingView: LoadingView,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping ( _ result: Result ) -> Content
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
