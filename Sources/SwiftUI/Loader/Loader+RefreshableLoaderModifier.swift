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

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {

	/// Marks this view as refreshable.
	///
	/// Apply this modifier to a view to set the ``EnvironmentValues/refresh``
	/// value in the view's environment to a ``RefreshAction`` instance that
	/// uses the specified `action` as its handler. Views that detect the
	/// presence of the instance can change their appearance to provide a
	/// way for the user to execute the handler.
	///
	/// Provided action called on pull-to-refresh action from user and
	/// should initiate reload from ``Loader`` instance by changing
	/// it's ``Loader/input`` parameter.
	///
	/// - Note: `refreshableLoader` should be placed inside `content` view
	/// of the `Loader` as it's dependant on environment variable passed
	/// down from it.
	///
	/// - Parameters:
	///   - action: A handler that should initiate update of `Loader` view.
	/// - Returns: A view with a new refresh action in its environment.
	func refreshableLoader( _ reloadAction: @escaping () -> Void ) -> some View {

		self
			.modifier(
				RefreshableLoaderModifier(
					reloadAction: reloadAction
				)
			)
	}
}


@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
internal struct RefreshableLoaderModifier: ViewModifier {

	internal let reloadAction: () -> Void

	@Environment( \.loaderTask ) private var loaderTask

	internal func body( content: Content ) -> some View {
		content
			.refreshable {
				reloadAction()
				try? await Task.sleep( seconds: 0.2 )

				await loaderTask?()
			}
	}
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
internal struct LoaderTaskKey: EnvironmentKey {
	internal static let defaultValue: TaskWrapper? = nil
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
internal extension EnvironmentValues {
	var loaderTask: TaskWrapper? {
		get { self[LoaderTaskKey.self] }
		set { self[LoaderTaskKey.self] = newValue }
	}
}

@available(iOS 14.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
internal struct TaskWrapper {

	let action: () async -> Void

	func callAsFunction() async {
		await action()
	}
}
