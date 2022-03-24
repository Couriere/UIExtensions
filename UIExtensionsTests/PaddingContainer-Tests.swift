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

#if canImport(UIKit)
class PaddingContainerTests: XCTestCase {

	var containedView: UIView!

	override func setUp() {
		containedView = UIView()
	}

	func checkInsets( in container: UIView, insets: UIEdgeInsets ) {
		XCTAssert( container is PaddingContainer )
		// Leading
		XCTAssertEqual( container.constraints[ 0 ].constant, insets.left )
		// Trailing
		XCTAssertEqual( container.constraints[ 1 ].constant, insets.right )
		// Top
		XCTAssertEqual( container.constraints[ 2 ].constant, insets.top )
		// Bottom
		XCTAssertEqual( container.constraints[ 3 ].constant, insets.bottom )
	}

	func testDefaultParameters() {
		let container = containedView.padding()
		checkInsets( in: container, insets: UIEdgeInsets( constantInset: 16 ))
	}

	func testDefaultAxisParameters() {
		let container = containedView.padding( 20 )
		checkInsets( in: container, insets: UIEdgeInsets( constantInset: 20 ))
	}

	func testDefaultLengthParameters() {
		let container = containedView.padding( .horizontal )
		checkInsets( in: container, insets: UIEdgeInsets( horizontal: 16 ))
	}

	func testDoublePadding() {
		let container = containedView.padding( .leading, 50 )
		checkInsets( in: container, insets: UIEdgeInsets( left: 50 ))
		let secondPaddingContainer = container.padding( .leading, 51 )
		XCTAssertIdentical( container, secondPaddingContainer )
		checkInsets( in: secondPaddingContainer, insets: UIEdgeInsets( left: 101 ))
	}

	func testAxisPadding() {
		let container = containedView.padding( .horizontal, 30 )
		checkInsets( in: container, insets: UIEdgeInsets( horizontal: 30 ))
		let secondPaddingContainer = container.padding( .vertical, 41 )
		XCTAssertIdentical( container, secondPaddingContainer )
		checkInsets(in: secondPaddingContainer, insets: UIEdgeInsets( horizontal: 30, vertical: 41 ))
	}

	func testCornersPadding() {
		let container = containedView.padding( [ .top, .leading ], 21 )
		checkInsets( in: container, insets: UIEdgeInsets( top: 21, left: 21 ))
		let secondPaddingContainer = container.padding( [ .top, .trailing ], 31 )
		XCTAssertIdentical( container, secondPaddingContainer )
		checkInsets( in: secondPaddingContainer, insets: UIEdgeInsets( top: 52, left: 21, bottom: 0, right: 31 ))
		let thirdPaddingContainer = container.padding( [ .bottom ], 51 )
		XCTAssertIdentical( secondPaddingContainer, thirdPaddingContainer )
		checkInsets( in: thirdPaddingContainer, insets: UIEdgeInsets( top: 52, left: 21, bottom: 51, right: 31 ))
	}

	func testMemoryLeak() {
		weak var weakContainedView = containedView
		var container: UIView? = containedView.padding( 20 )
		weak var weakContainer = container

		XCTAssertNotNil( weakContainedView )
		XCTAssertNotNil( weakContainer )
		containedView = nil
		XCTAssertNotNil( weakContainedView )
		XCTAssertNotNil( weakContainer )
		container = nil
		XCTAssertNil( weakContainedView )
		XCTAssertNil( weakContainer )
	}
}
#endif
