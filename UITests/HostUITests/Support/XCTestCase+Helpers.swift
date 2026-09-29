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
extension XCTestCase {

	/// Launches the host app directly on the given screen.
	func launch( _ screen: ScreenID, arguments: [ String ] = [] ) -> XCUIApplication {
		continueAfterFailure = false

		let app = XCUIApplication()
		app.launchArguments = [ ScreenID.launchArgument, screen.rawValue ] + arguments
		app.launch()
		return app
	}

	/// Waits until the element appears.
	func assertExists(
		_ element: XCUIElement,
		timeout: TimeInterval = 5,
		file: StaticString = #filePath,
		line: UInt = #line,
	) {
		XCTAssertTrue(
			element.waitForExistence( timeout: timeout ),
			"“\( element.identifier )” did not appear",
			file: file,
			line: line,
		)
	}

	/// Waits until the element disappears.
	func assertNotExists(
		_ element: XCUIElement,
		timeout: TimeInterval = 5,
		file: StaticString = #filePath,
		line: UInt = #line,
	) {
		XCTAssertTrue(
			element.waitForNonExistence( timeout: timeout ),
			"“\( element.identifier )” did not disappear",
			file: file,
			line: line,
		)
	}

	/// Waits until the element's label equals the expected text.
	func assertLabel(
		_ element: XCUIElement,
		_ expected: String,
		timeout: TimeInterval = 5,
		file: StaticString = #filePath,
		line: UInt = #line,
	) {
		XCTAssertTrue(
			element.wait( for: \.label, toEqual: expected, timeout: timeout ),
			"“\( element.identifier )” is “\( element.exists ? element.label : "missing" )”, expected “\( expected )”",
			file: file,
			line: line,
		)
	}
}

extension XCUIApplication {

	/// Returns to the previous screen of the navigation stack.
	func navigateBack() {
		navigationBars.buttons.element( boundBy: 0 ).tap()
	}
}

extension XCUIElement {

	/// Pulls the scroll view down far enough to trigger `refreshable`.
	func pullToRefresh() {
		let start = coordinate( withNormalizedOffset: CGVector( dx: 0.5, dy: 0.2 ))
		let end = start.withOffset( CGVector( dx: 0, dy: 500 ))
		start.press( forDuration: 0, thenDragTo: end, withVelocity: .slow, thenHoldForDuration: 1 )
	}
}
