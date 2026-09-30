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

import XCTest

@MainActor
final class LoaderUITests: XCTestCase {

	// MARK: Loading and failure

	func testShowsLoadingViewUntilLoadCompletes() {
		let app = launch( .loader )

		assertExists( app.staticTexts[ LoaderID.loading ])
		assertLabel( app.staticTexts[ LoaderID.pendingCount ], "Pending: 1" )

		app.buttons[ LoaderID.complete ].tap()

		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )
		assertLabel( app.staticTexts[ LoaderID.state ], "Idle" )
		assertNotExists( app.staticTexts[ LoaderID.loading ])
		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 1" )
	}

	func testShowsFailureViewWhenLoadFails() {
		let app = launch( .loader )

		app.buttons[ LoaderID.fail ].tap()

		assertExists( app.staticTexts[ LoaderID.failure ])
		assertNotExists( app.staticTexts[ LoaderID.loading ])
	}

	func testRetryAfterFailureLoadsAgain() {
		let app = launch( .loader )
		app.buttons[ LoaderID.fail ].tap()

		app.buttons[ LoaderID.retry ].tap()

		assertExists( app.staticTexts[ LoaderID.loading ])
		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 2" )

		app.buttons[ LoaderID.complete ].tap()

		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )
	}

	func testRetryAfterInputChangesUsesLatestInput() {
		let app = launch( .loader )
		app.buttons[ LoaderID.fail ].tap()
		assertExists( app.staticTexts[ LoaderID.failure ] )

		app.buttons[ LoaderID.changeInput ].tap()
		assertLabel( app.staticTexts[ LoaderID.input ], "Input: 2" )
		assertLabel( app.staticTexts[ LoaderID.pendingCount ], "Pending: 1" )
		app.buttons[ LoaderID.fail ].tap()
		assertExists( app.staticTexts[ LoaderID.failure ] )

		app.buttons[ LoaderID.retry ].tap()
		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 3" )
		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 2" )
	}

	// MARK: Input changes

	func testInputChangeClearsOutputByDefault() {
		let app = launch( .loader )
		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )

		app.buttons[ LoaderID.changeInput ].tap()

		assertExists( app.staticTexts[ LoaderID.loading ])
		assertNotExists( app.staticTexts[ LoaderID.output ])

		app.buttons[ LoaderID.complete ].tap()

		assertLabel( app.staticTexts[ LoaderID.output ], "Output 2" )
	}

	func testInputChangeKeepsOutputWithoutClearOnReload() {
		let app = launch( .loaderKeepingOutput )
		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )

		app.buttons[ LoaderID.changeInput ].tap()

		assertLabel( app.staticTexts[ LoaderID.state ], "Reloading" )
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )
		XCTAssertFalse( app.staticTexts[ LoaderID.loading ].exists )

		app.buttons[ LoaderID.complete ].tap()

		assertLabel( app.staticTexts[ LoaderID.output ], "Output 2" )
		assertLabel( app.staticTexts[ LoaderID.state ], "Idle" )
	}

	func testDisableAutoLoadWaitsForInputChange() {
		let app = launch( .loaderDisableAutoLoad )

		assertExists( app.staticTexts[ LoaderID.loading ])
		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 0" )
		assertLabel( app.staticTexts[ LoaderID.pendingCount ], "Pending: 0" )

		app.buttons[ LoaderID.changeInput ].tap()

		assertLabel( app.staticTexts[ LoaderID.input ], "Input: 2" )
		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 1" )
		assertLabel( app.staticTexts[ LoaderID.pendingCount ], "Pending: 1" )

		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 2" )
	}

	func testFailedReloadKeepsExistingOutputWithoutClearOnReload() {
		let app = launch( .loaderKeepingOutput )
		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )

		app.buttons[ LoaderID.changeInput ].tap()
		app.buttons[ LoaderID.fail ].tap()

		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )
		assertLabel( app.staticTexts[ LoaderID.state ], "Idle" )
		assertNotExists( app.staticTexts[ LoaderID.failure ])
	}

	func testFailedReloadShowsFailureAfterClearOnReload() {
		let app = launch( .loader )
		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )

		app.buttons[ LoaderID.changeInput ].tap()
		app.buttons[ LoaderID.fail ].tap()

		assertExists( app.staticTexts[ LoaderID.failure ])
		assertNotExists( app.staticTexts[ LoaderID.output ])
		assertNotExists( app.staticTexts[ LoaderID.loading ])
	}

	func testNewInputCancelsLoadInProgress() {
		let app = launch( .loader )

		app.buttons[ LoaderID.changeInput ].tap()
		app.buttons[ LoaderID.changeInput ].tap()

		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 3" )
		assertLabel( app.staticTexts[ LoaderID.pendingCount ], "Pending: 1" )

		app.buttons[ LoaderID.complete ].tap()

		assertLabel( app.staticTexts[ LoaderID.output ], "Output 3" )
	}

	// MARK: Appearance

	func testReloadsOnReappearKeepingOutput() {
		let app = launch( .loader )
		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )

		app.buttons[ LoaderID.openDetails ].tap()
		assertExists( app.staticTexts[ LoaderID.details ])
		app.navigateBack()

		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 2" )
		assertLabel( app.staticTexts[ LoaderID.state ], "Reloading" )
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )

		app.buttons[ LoaderID.complete ].tap()

		assertLabel( app.staticTexts[ LoaderID.state ], "Idle" )
	}

	func testClearOnAppearClearsOutputWhileReloading() {
		let app = launch( .loaderClearOnAppear )
		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )

		app.buttons[ LoaderID.openDetails ].tap()
		assertExists( app.staticTexts[ LoaderID.details ])
		app.navigateBack()

		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 2" )
		assertLabel( app.staticTexts[ LoaderID.pendingCount ], "Pending: 1" )
		assertExists( app.staticTexts[ LoaderID.loading ])
		assertNotExists( app.staticTexts[ LoaderID.output ])

		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )
	}

	func testDoesNotReloadOnReappearWithoutReloadOnAppear() {
		let app = launch( .loaderNoReloadOnAppear )
		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )

		app.buttons[ LoaderID.openDetails ].tap()
		assertExists( app.staticTexts[ LoaderID.details ])
		app.navigateBack()

		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 1" )
		assertLabel( app.staticTexts[ LoaderID.pendingCount ], "Pending: 0" )
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )
		assertLabel( app.staticTexts[ LoaderID.state ], "Idle" )
	}

	func testCancelsLoadWhenDisappearing() {
		let app = launch( .loader )
		assertLabel( app.staticTexts[ LoaderID.pendingCount ], "Pending: 1" )

		app.buttons[ LoaderID.openDetails ].tap()
		assertExists( app.staticTexts[ LoaderID.details ])
		app.navigateBack()

		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 2" )
		assertLabel( app.staticTexts[ LoaderID.pendingCount ], "Pending: 1" )
		assertExists( app.staticTexts[ LoaderID.loading ])
	}

	// MARK: Refreshable

	/// While the refresh indicator spins, XCUITest waits for the app to idle
	/// before every query, so this test lets loads complete on their own.
	func testPullToRefreshChangesInputAndReloads() {
		let app = launch( .loaderKeepingOutput, arguments: [ LoaderID.autoCompleteArgument ])
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )

		app.collectionViews[ LoaderID.list ].pullToRefresh()

		assertLabel( app.staticTexts[ LoaderID.output ], "Output 2" )
		assertLabel( app.staticTexts[ LoaderID.input ], "Input: 2" )
		assertLabel( app.staticTexts[ LoaderID.loadCount ], "Loads: 2" )
	}

	// MARK: Content state

	func testJustLoadedIsPassedOnlyOnFirstContentRender() {
		let app = launch( .loaderJustLoaded )
		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )
		assertLabel( app.staticTexts[ LoaderID.state ], "Just loaded" )

		app.buttons[ LoaderID.editContent ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1 edited" )
		assertLabel( app.staticTexts[ LoaderID.state ], "Idle" )

		app.buttons[ LoaderID.changeInput ].tap()
		assertExists( app.staticTexts[ LoaderID.loading ] )
		app.buttons[ LoaderID.complete ].tap()
		assertLabel( app.staticTexts[ LoaderID.output ], "Output 2" )
		assertLabel( app.staticTexts[ LoaderID.state ], "Just loaded" )
	}

	// MARK: Placeholder

	func testPlaceholderIsDisabledWhileLoading() {
		let app = launch( .loaderPlaceholder )
		let action = app.buttons[ LoaderID.contentAction ]

		assertLabel( app.staticTexts[ LoaderID.state ], "Placeholder" )
		assertLabel( app.staticTexts[ LoaderID.output ], "Placeholder" )
		XCTAssertFalse( action.isEnabled )

		app.buttons[ LoaderID.complete ].tap()

		assertLabel( app.staticTexts[ LoaderID.output ], "Output 1" )
		assertLabel( app.staticTexts[ LoaderID.state ], "Idle" )
		XCTAssertTrue( action.isEnabled )
	}
}
