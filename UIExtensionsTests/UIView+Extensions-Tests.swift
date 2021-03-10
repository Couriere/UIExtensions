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
import UIExtensions


class UIView_Extensions_Tests: XCTestCase {

	func testAddViews() {

		let parent = XTView()
		XCTAssertEqual( parent.subviews.count, 0 )

		let childs = [ XTView(), XTView(), XTView() ]
		parent.addSubviews( childs )
		XCTAssertEqual( parent.subviews.count, 3 )
		parent.addSubviews( XTView(), XTView() )
		XCTAssertEqual( parent.subviews.count, 5 )
	}

	func testRemoveViews() {

		let parent = XTView()
		parent.addSubviews( XTView(), XTView(), XTView(), XTView() )
		XCTAssertEqual( parent.subviews.count, 4 )

		parent.removeAllSubviews()
		XCTAssertEqual( parent.subviews.count, 0 )
	}

/*
	#if canImport(AppKit)
	func testMakeFromXib() {
		let view = TestViewMac.makeFromXib()!
		XCTAssertEqual( view.subviews.count, 2 )
		XCTAssertNotNil( view.button )
		XCTAssertNotNil( view.label )
	}
	#else
	func testMakeFromXib() {
		let view = TestViewPhone.makeFromXib()!
		XCTAssertEqual( view.subviews.count, 2 )
		XCTAssertNotNil( view.button )
		XCTAssertNotNil( view.label )
	}
	#endif
*/
}

/*
#if canImport(AppKit)
class TestViewMac: NSView {
	@IBOutlet var button: NSButton!
	@IBOutlet var label: NSTextField!
}
#else
class TestViewPhone: UIView {
	@IBOutlet var button: UIButton!
	@IBOutlet var label: UILabel!
}
#endif
*/
