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

extension View {

	/// Adds pull-to-refresh capability
	/// to reload Loader content.
	///
	/// This modifier enables users to refresh data
	/// in a `Loader` using the standard
	/// pull-to-refresh gesture. When the gesture
	/// is performed, the provided action is called,
	/// which **must modify the Loader's input parameter**
	/// to trigger a data reload.
	///
	/// - Important: This modifier must be applied
	/// **inside** the `content` closure of your
	/// `Loader`, as it depends on an environment
	/// variable set by the `Loader` itself.
	///
	/// - Important: The `reloadAction` closure
	/// **must change the `input` parameter** of the
	/// `Loader` to trigger a reload. Simply calling
	/// this modifier does **not** automatically
	/// reload data - you must explicitly modify
	/// the input value that was passed to the `Loader`.
	///
	/// ## How it works
	///
	/// 1. User performs a pull-to-refresh gesture
	/// 2. `reloadAction` is called, where
	/// **you must change the Loader's `input` parameter**
	/// 3. `Loader` detects the input change
	/// and automatically reloads data
	/// 4. Refresh indicator disappears after loading completes
	///
	/// ## Usage Example
	///
	/// ```swift
	/// struct FeedView: View {
	///     @State private var timestamp: Date = .now
	///
	///     var body: some View {
	///         Loader(
	///             input: timestamp,
	///             placeholder: Feed.placeholder,
	///             failureView: ErrorView.init,
	///             action: { time in
	///                 try await APIClient.fetchFeed(since: time)
	///             },
	///             content: { $feed, state in
	///                 List(feed.items) { item in
	///                     FeedItemRow(item: item)
	///                 }
	///                 .refreshableLoader {
	///                     // MUST update input to trigger reload
	///                     timestamp = .now  // Change input value
	///                 }
	///             }
	///         )
	///     }
	/// }
	/// ```
	///
	/// ## Common Mistakes
	///
	/// ```swift
	/// // ❌ Wrong: modifier outside Loader
	/// Loader(...)
	///     .refreshableLoader { ... }  // Won't work!
	///
	/// // ❌ Wrong: not changing input
	/// .refreshableLoader {
	///     print("Refreshing")  // Does nothing - no reload!
	/// }
	///
	/// // ✅ Correct: modifier inside content AND changing input
	/// Loader(...) { $data, state in
	///     MyView(data: data)
	///         .refreshableLoader {
	///             inputParam = newValue  // MUST change input!
	///         }
	/// }
	/// ```
	///
	/// - Parameter reloadAction: A closure that
	///  **must modify the Loader's `input` parameter**
	///  to initiate a data reload.
	///  The reload does **not** happen automatically -
	///  you must explicitly change the input value.
	///
	/// - Returns: A view with pull-to-refresh capability added.
	///
	public func refreshableLoader(
		_ reloadAction: @escaping () -> Void
	) -> some View {
		self.modifier(
			RefreshableLoaderModifier(
				reloadAction: reloadAction
			)
		)
	}
}

internal struct RefreshableLoaderModifier: ViewModifier {

	internal let reloadAction: () -> Void

	@Environment(\.loaderTask) private var loaderTask

	internal func body( content: Content ) -> some View {
		content
			.refreshable {
				reloadAction()
				try? await Task.sleep( seconds: 0.2 )

				await loaderTask?()
			}
	}
}

internal struct LoaderTaskKey: EnvironmentKey {
	internal static var defaultValue: TaskWrapper? { nil }
}

internal extension EnvironmentValues {
	var loaderTask: TaskWrapper? {
		get { self[LoaderTaskKey.self] }
		set { self[LoaderTaskKey.self] = newValue }
	}
}

internal struct TaskWrapper: Sendable {

	let action: @Sendable () async -> Void

	func callAsFunction() async {
		await action()
	}
}
