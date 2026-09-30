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

@main
struct HostApp: App {

	var body: some Scene {
		WindowGroup {
			if let screen = ScreenID.launchScreen {
				screen.view
			}
			else {
				ScreenCatalog()
			}
		}
	}
}

/// Lists every screen for manual checks when the app runs without UI tests.
private struct ScreenCatalog: View {

	var body: some View {
		NavigationStack {
			List( ScreenID.allCases, id: \.self ) { screen in
				NavigationLink( screen.rawValue ) {
					screen.view
				}
			}
			.navigationTitle( "UIExtensions" )
		}
	}
}

extension ScreenID {

	/// The screen passed with ``launchArgument``, if any.
	static var launchScreen: ScreenID? {
		let key = String( launchArgument.dropFirst())
		return UserDefaults.standard.string( forKey: key ).flatMap( ScreenID.init( rawValue: ))
	}

	@MainActor
	@ViewBuilder
	var view: some View {
		switch self {
		case .loader:
			LoaderScreen( variant: .standard )
		case .loaderKeepingOutput:
			LoaderScreen( variant: .keepingOutput )
		case .loaderPlaceholder:
			LoaderScreen( variant: .placeholder )
		case .loaderDisableAutoLoad:
			LoaderScreen( variant: .disableAutoLoad )
		case .loaderClearOnAppear:
			LoaderScreen( variant: .clearOnAppear )
		case .loaderNoReloadOnAppear:
			LoaderScreen( variant: .noReloadOnAppear )
		case .loaderJustLoaded:
			LoaderScreen( variant: .justLoaded )
		case .onFirstAppear:
			OnFirstAppearScreen()
		case .onReappear:
			OnReappearScreen()
		case .asyncButton:
			AsyncButtonScreen( cancelsOnDisappear: true )
		case .asyncButtonKeepsRunning:
			AsyncButtonScreen( cancelsOnDisappear: false )
		case .fullScreenPopup:
			FullScreenPopupScreen( variant: .boolean )
		case .fullScreenPopupItem:
			FullScreenPopupScreen( variant: .item )
		case .tabContainer:
			TabContainerScreen()
		}
	}
}
