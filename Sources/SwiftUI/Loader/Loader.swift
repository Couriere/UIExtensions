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
public struct ReloadOptions: OptionSet {

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
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct Loader<Input, Result, LoadingView, FailureView, Content> where
Input: Equatable, LoadingView: View, FailureView: View, Content: View {

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
	private let content: (Binding<Result>, Bool) -> Content

	/// Loading action is in progress.
	@State private var isLoading: Bool = false

	/// The result of the data loading process.
	@State private var result: Result?

	/// The error that occurred during data loading.
	@State private var failure: Error?

	/// State to force reload after loading failure.
	@State private var forcedReloadTrigger: Bool = false

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
	///		content: { binding in
	///			binding.wrappedValue = binding.wrappedValue * 2
	///			Text( String( binding.wrappedValue ))
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
		@ViewBuilder content: @escaping ( _ result: Binding<Result>, _ isLoading: Bool ) -> Content
	) {
		self.input = input
		self.reloadOptions = reloadOptions
		self.loadingView = loadingView
		self.failureView = failureView
		self.action = action
		self.content = content
	}
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Loader: View {

	public var body: some View {

		Group {
			switch ( Binding( $result ), failure ) {

			case ( .some( let binding ), _ ):
				content( binding, isLoading )

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
				initial: result == nil || reloadOptions.contains( .reloadOnAppear ),
				action: performLoad
			)
		)
	}
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private extension Loader {

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
			result = value
		}
		catch {
			guard !Task.isCancelled else { return }
			failure = error
		}
	}
}
