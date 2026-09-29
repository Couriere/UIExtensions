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

// Compiled into both the host app and the UI tests,
// so the tests refer to screens and elements by the same identifiers.

/// A screen of the host app that exercises one component.
///
/// The UI tests launch the app with ``launchArgument`` followed by the raw value,
/// and the app opens that screen instead of the catalog.
enum ScreenID: String, CaseIterable {

	/// `Loader` with the default reload options.
	case loader
	/// `Loader` that keeps the output while reloading.
	case loaderKeepingOutput
	/// `Loader` with a placeholder instead of a loading view.
	case loaderPlaceholder
	/// `Loader` that does not automatically load until the input changes.
	case loaderDisableAutoLoad
	/// `Loader` that clears its output when it reloads on appearance.
	case loaderClearOnAppear
	/// `Loader` that does not reload on appearance after its first load.
	case loaderNoReloadOnAppear
	/// Exposes the first-render `justLoaded` content state.
	case loaderJustLoaded
	/// `onFirstAppear` compared with `onAppear`.
	case onFirstAppear
	case onReappear
	case asyncButton
	case asyncButtonKeepsRunning
	case fullScreenPopup
	case fullScreenPopupItem

	static let launchArgument = "-UITestScreen"
}

/// Accessibility identifiers of the `Loader` screens.
enum LoaderID {
	static let loading = "loader.loading"
	static let output = "loader.output"
	static let state = "loader.state"
	static let contentAction = "loader.contentAction"
	static let editContent = "loader.editContent"
	static let list = "loader.list"
	static let failure = "loader.failure"
	static let retry = "loader.retry"

	static let input = "loader.input"
	static let loadCount = "loader.loadCount"
	static let pendingCount = "loader.pendingCount"
	static let complete = "loader.complete"
	static let fail = "loader.fail"
	static let changeInput = "loader.changeInput"
	static let openDetails = "loader.openDetails"
	static let details = "loader.details"

	/// Launch argument that makes every load complete on its own
	/// shortly after it starts, instead of waiting for ``complete``.
	static let autoCompleteArgument = "-UITestAutoCompleteLoads"
}

/// Accessibility identifiers of the `onFirstAppear` screen.
enum OnFirstAppearID {
	static let firstAppearCount = "onFirstAppear.firstAppearCount"
	static let appearCount = "onFirstAppear.appearCount"
	static let openDetails = "onFirstAppear.openDetails"
	static let details = "onFirstAppear.details"
}

enum OnReappearID {
	static let syncCount = "onReappear.syncCount"
	static let asyncCount = "onReappear.asyncCount"
	static let openDetails = "onReappear.openDetails"
	static let details = "onReappear.details"
}

enum AsyncButtonID {
	static let button = "asyncButton.button"
	static let started = "asyncButton.started"
	static let pending = "asyncButton.pending"
	static let cancelled = "asyncButton.cancelled"
	static let completed = "asyncButton.completed"
	static let complete = "asyncButton.complete"
	static let openDetails = "asyncButton.openDetails"
	static let details = "asyncButton.details"
}

enum FullScreenPopupID {
	static let show = "fullScreenPopup.show"
	static let showItem = "fullScreenPopup.showItem"
	static let popup = "fullScreenPopup.popup"
	static let dismiss = "fullScreenPopup.dismiss"
	static let replace = "fullScreenPopup.replace"
	static let dismissCount = "fullScreenPopup.dismissCount"
}
