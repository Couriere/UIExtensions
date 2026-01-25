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

extension Loader where LoadingView == LoaderPlaceholderProxy<Content> {

	/// Initializes the Loader View with parameters.
	///
	/// When the `input` parameter's value changes,
	/// the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping (Input) async throws -> Result,
		@ViewBuilder content: @escaping (_ result: Binding<Result>, _ state: LoaderContentState ) -> Content,
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: LoaderPlaceholderProxy(
				content: content( .constant( placeholder ), .loadingPlaceholder )
			),
			failureView: failureView,
			action: action,
			content: content
		)
	}

	/// Initializes the Loader View with parameters.
	///
	/// When the `input` parameter's value changes,
	/// the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping (Input) async throws -> Result,
		@ViewBuilder content: @escaping (Binding<Result>) -> Content,
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: LoaderPlaceholderProxy(
				content: content( .constant( placeholder ))
			),
			failureView: failureView,
			action: action,
			content: { result, _ in content( result ) }
		)
	}

	/// Initializes the Loader View with parameters.
	///
	/// When the `input` parameter's value changes,
	/// the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping (Input) async throws -> Result,
		@ViewBuilder content: @escaping (_ result: Result, _ state: LoaderContentState) -> Content,
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: LoaderPlaceholderProxy(
				content: content(placeholder, .loadingPlaceholder)
			),
			failureView: failureView,
			action: action,
			content: content
		)
	}

	/// Initializes the Loader View with parameters.
	///
	/// When the `input` parameter's value changes,
	/// the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping (Input) async throws -> Result,
		@ViewBuilder content: @escaping (Result) -> Content,
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: LoaderPlaceholderProxy(
				content: content(placeholder)
			),
			failureView: failureView,
			action: action,
			content: content
		)
	}

	/// Initializes the Loader View with parameters.
	///
	/// When the `input` parameter's value changes,
	/// the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping (_ result: Binding<Result>, _ state: LoaderContentState) -> Content,
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: LoaderPlaceholderProxy(
				content: content(.constant(placeholder), .loadingPlaceholder)
			),
			failureView: failureView,
			action: { _ in try await action() },
			content: content
		)
	}

	/// Initializes the Loader View with parameters.
	///
	/// When the `input` parameter's value changes,
	/// the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping (Binding<Result>) -> Content,
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: LoaderPlaceholderProxy(
				content: content(.constant(placeholder))
			),
			failureView: failureView,
			action: { _ in try await action() },
			content: { result, _ in content(result) }
		)
	}

	/// Initializes the Loader View with parameters.
	///
	/// When the `input` parameter's value changes,
	/// the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping (_ result: Result, _ state: LoaderContentState) -> Content,
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: LoaderPlaceholderProxy(
				content: content(placeholder, .loadingPlaceholder)
			),
			failureView: failureView,
			action: { _ in try await action() },
			content: content
		)
	}

	/// Initializes the Loader View with parameters.
	///
	/// When the `input` parameter's value changes,
	/// the data will be reloaded based on the specified action.
	///
	/// - Parameters:
	///   - input: The input parameter for data loading.
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		input: Input,
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping (Result) -> Content,
	) {
		self.init(
			input: input,
			reloadOptions: reloadOptions,
			loadingView: LoaderPlaceholderProxy(
				content: content(placeholder)
			),
			failureView: failureView,
			action: { _ in try await action() },
			content: { binding, _ in content(binding.wrappedValue) }
		)
	}
}

extension Loader where Input == Int, LoadingView == LoaderPlaceholderProxy<Content> {

	/// Initializes the Loader with no parameters for data loading.
	///
	/// Data may be reloaded only when view appears on screen.
	///
	/// - Parameters:
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping (_ result: Binding<Result>) -> Content,
	) {
		self.init(
			input: 0,
			reloadOptions: reloadOptions,
			placeholder: placeholder,
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
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping (_ result: Result, _ state: LoaderContentState) -> Content,
	) {
		self.init(
			input: 0,
			reloadOptions: reloadOptions,
			placeholder: placeholder,
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
	///   - reloadOptions: Options controlling the reloading behavior.
	///   Defaults to `[.reloadOnAppear]`.
	///   - placeholder: Placeholder result value to display during loading.
	///   - failureView: View to display when the asynchronous action throws an error.
	///   - action: Asynchronous function to perform data loading.
	///   - content: ViewBuilder closure for rendering content based on loaded data.
	///
	@inlinable
	public init(
		reloadOptions: ReloadOptions = [.reloadOnAppear],
		placeholder: Result,
		failureView: @escaping ( Error, _ reload: @escaping () -> Void ) -> FailureView,
		action: @escaping () async throws -> Result,
		@ViewBuilder content: @escaping (Result) -> Content,
	) {
		self.init(
			input: 0,
			reloadOptions: reloadOptions,
			placeholder: placeholder,
			failureView: failureView,
			action: action,
			content: content
		)
	}
}

extension EnvironmentValues {
	/// Environment key for controlling
	/// the placeholder state in `Loader`.
	///
	/// By default, the value is `true`,
	/// which disables the placeholder
	/// content (`.disabled(true)`) to prevent
	/// interaction with placeholder elements
	/// during loading.
	/// Set to `false` to allow interaction
	/// with placeholder content.
	///
	/// Usage:
	/// ```swift
	/// struct MyView: View {
	///     var body: some View {
	///         Loader(
	///             input: 0,
	///             placeholder: 0,
	///             action: { 0 },
	///             content: { ... }
	///         )
	///         // Allow interaction with placeholder
	///         .environment(\.loaderDisablePlaceholder, false)
	///     }
	/// }
	/// ```
	@Entry
	public var loaderDisablePlaceholder: Bool = true
}

extension View {

	/// Enables interaction with the placeholder
	/// in `Loader` for the current view.
	///
	/// By default, `Loader` disables the placeholder
	/// to prevent unintended actions during data loading.
	/// Calling this modifier sets the `loaderDisablePlaceholder`
	/// environment key to `false`, allowing interaction with
	/// placeholder UI elements (buttons, links, etc.).
	///
	/// - Returns: A view with updated environment.
	///
	/// Example:
	/// ```swift
	/// Loader(
	///     input: 0,
	///     placeholder: 0,
	///     action: { 0 },
	///     content: { ... }
	/// )
	/// .loaderPlaceholderEnabled()
	/// ```
	public func loaderPlaceholderEnabled() -> some View {
		environment(\.loaderDisablePlaceholder, false)
	}
}

public struct LoaderPlaceholderProxy<Content: View>: View {

	let content: Content
	@Environment(\.loaderDisablePlaceholder) private var disablePlaceholder

	@usableFromInline
	init(content: Content) {
		self.content = content
	}

	public var body: some View {

		if #available(iOS 16.0, *) {
			content
				.redacted( reason: .placeholder )
				.disabled( disablePlaceholder )
				.scrollDisabled( true )
		} else {
			content
				.redacted( reason: .placeholder )
				.disabled( disablePlaceholder )
		}
	}
}
