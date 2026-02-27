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

import Testing
import UIExtensions

#if canImport(UIKit) && !os(watchOS)
import UIKit
@MainActor
@Suite("PaddingContainerTests")
struct PaddingContainerTests {

	func checkInsets( in container: UIView, insets: UIEdgeInsets ) {
		#expect( container is PaddingContainer )
		// Leading
		#expect( container.constraints[ 0 ].constant == insets.left )
		// Trailing
		#expect( container.constraints[ 1 ].constant == insets.right )
		// Top
		#expect( container.constraints[ 2 ].constant == insets.top )
		// Bottom
		#expect( container.constraints[ 3 ].constant == insets.bottom )
	}

	@Test
	func testDefaultParameters() {
		let containedView = UIView()
		let container = containedView.padding()
		checkInsets( in: container, insets: UIEdgeInsets( constantInset: 16 ))
	}

	@Test
	func testDefaultAxisParameters() {
		let containedView = UIView()
		let container = containedView.padding( 20 )
		checkInsets( in: container, insets: UIEdgeInsets( constantInset: 20 ))
	}

	@Test
	func testDefaultLengthParameters() {
		let containedView = UIView()
		let container = containedView.padding( .horizontal )
		checkInsets( in: container, insets: UIEdgeInsets( horizontal: 16 ))
	}

	@Test
	func testDoublePadding() {
		let containedView = UIView()
		let container = containedView.padding( .leading, 50 )
		checkInsets( in: container, insets: UIEdgeInsets( left: 50 ))
		let secondPaddingContainer = container.padding( .leading, 51 )
		#expect( container === secondPaddingContainer )
		checkInsets( in: secondPaddingContainer, insets: UIEdgeInsets( left: 101 ))
	}

	@Test
	func testAxisPadding() {
		let containedView = UIView()
		let container = containedView.padding( .horizontal, 30 )
		checkInsets( in: container, insets: UIEdgeInsets( horizontal: 30 ))
		let secondPaddingContainer = container.padding( .vertical, 41 )
		#expect( container === secondPaddingContainer )
		checkInsets(in: secondPaddingContainer, insets: UIEdgeInsets( horizontal: 30, vertical: 41 ))
	}

	@Test
	func testCornersPadding() {
		let containedView = UIView()
		let container = containedView.padding( [ .top, .leading ], 21 )
		checkInsets( in: container, insets: UIEdgeInsets( top: 21, left: 21 ))
		let secondPaddingContainer = container.padding( [ .top, .trailing ], 31 )
		#expect( container === secondPaddingContainer )
		checkInsets( in: secondPaddingContainer, insets: UIEdgeInsets( top: 52, left: 21, bottom: 0, right: 31 ))
		let thirdPaddingContainer = container.padding( [ .bottom ], 51 )
		#expect( secondPaddingContainer === thirdPaddingContainer )
		checkInsets( in: thirdPaddingContainer, insets: UIEdgeInsets( top: 52, left: 21, bottom: 51, right: 31 ))
	}

	@Test
	func testMemoryLeak() {
		var containedView: UIView? = UIView()
		weak let weakContainedView = containedView
		var container: UIView? = containedView?.padding( 20 )
		weak let weakContainer = container

		#expect( weakContainedView != nil )
		#expect( weakContainer != nil )
		containedView = nil
		#expect( weakContainedView != nil )
		#expect( weakContainer != nil )
		container = nil
		#expect( weakContainedView == nil )
		#expect( weakContainer == nil )
	}
}
#endif
