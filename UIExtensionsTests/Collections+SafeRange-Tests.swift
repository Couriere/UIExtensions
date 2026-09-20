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

import Foundation
import Testing
import UIExtensions

@Suite("Collections+SafeRangeTests")
struct CollectionsSafeRangeTests {

	private let array = [ 1, 2, 3, 4, 5 ]

	// MARK: - subscript( safe: )

	@Test("Range inside the collection")
	func rangeInside() {
		#expect( Array( array[ safe: 1 ..< 3 ] ) == [ 2, 3 ] )
		#expect( Array( array[ safe: 0 ..< 5 ] ) == array )
	}

	@Test("Range crossing the upper bound")
	func rangeAboveUpperBound() {
		#expect( Array( array[ safe: 3 ..< 100 ] ) == [ 4, 5 ] )
		#expect( Array( array[ safe: 5 ..< 10 ] ).isEmpty )
		#expect( Array( array[ safe: 42 ..< 100 ] ).isEmpty )
	}

	@Test("Range crossing the lower bound")
	func rangeBelowLowerBound() {
		#expect( Array( array[ safe: -5 ..< 2 ] ) == [ 1, 2 ] )
		#expect( Array( array[ safe: -100 ..< -5 ] ).isEmpty )
		#expect( Array( array[ safe: -100 ..< 100 ] ) == array )
	}

	@Test("Empty collection")
	func emptyCollection() {
		let empty: [ Int ] = []
		#expect( Array( empty[ safe: -3 ..< 3 ] ).isEmpty )
	}

	// MARK: - rotatingLeft

	@Test("Rotating left moves the first element to the end")
	func rotatingLeft() {
		#expect( [ 1, 2, 3 ].rotatingLeft() == [ 2, 3, 1 ] )
		#expect( [ 1 ].rotatingLeft() == [ 1 ] )
	}

	@Test("Rotating an empty array leaves it unchanged")
	func rotatingEmptyArray() {
		#expect( [ Int ]().rotatingLeft().isEmpty )
	}

	// MARK: - changingEach

	@Test("Changing each element")
	func changingEach() {

		struct Item: Equatable { var value: Int }

		let items = [ Item( value: 1 ), Item( value: 2 ) ]
		#expect( items.changingEach { $0.value *= 10 } == [ Item( value: 10 ), Item( value: 20 ) ] )

		var mutable = items
		mutable.changeEach { $0.value *= 10 }
		#expect( mutable == [ Item( value: 10 ), Item( value: 20 ) ] )
	}

	// MARK: - replacingSubrange

	@Test("Replacing a subrange")
	func replacingSubrange() {
		#expect(
			[ 10, 20, 30, 40, 50 ].replacingSubrange( 1...3, with: repeatElement( 1, count: 5 ))
				== [ 10, 1, 1, 1, 1, 1, 50 ],
		)
	}

	// MARK: - toggle

	@Test("Toggling an array element")
	func toggleElement() {

		var array = [ 1, 2, 3 ]
		array.toggle( 2 )
		#expect( array == [ 1, 3 ] )
		array.toggle( 2 )
		#expect( array == [ 1, 3, 2 ] )
	}

	// MARK: - Duplicates

	@Test("Removing duplicates keeps the first occurrence")
	func removingDuplicates() {

		#expect( [ 3, 1, 3, 2, 1 ].removingDuplicates == [ 3, 1, 2 ] )

		var array = [ 3, 1, 3, 2, 1 ]
		array.removeDuplicates()
		#expect( array == [ 3, 1, 2 ] )
	}
}

@Suite("Numbers+ClampedTests")
struct NumbersClampedTests {

	@Test("Clamping to a closed range")
	func clampedInClosedRange() {
		#expect( 5.clamped( in: 0 ... 10 ) == 5 )
		#expect( (-5).clamped( in: 0 ... 10 ) == 0 )
		#expect( 15.clamped( in: 0 ... 10 ) == 10 )
	}

	@Test("Clamping an integer to a half-open range")
	func clampedInRange() {
		#expect( 5.clamped( in: 0 ..< 10 ) == 5 )
		#expect( 15.clamped( in: 0 ..< 10 ) == 10 )
	}

	@Test("Clamping a floating-point value stays below the upper bound")
	func clampedFloatingPoint() {

		#expect( 5.0.clamped( in: 0.0 ..< 10.0 ) == 5.0 )
		#expect( (-5.0).clamped( in: 0.0 ..< 10.0 ) == 0.0 )

		let clamped = 15.0.clamped( in: 0.0 ..< 10.0 )
		#expect( clamped < 10.0 )
		#expect( clamped == 10.0.nextDown )
	}

	@Test("Testing range membership")
	func isIn() {
		#expect( 5.isIn( 0 ..< 10 ))
		#expect( !10.isIn( 0 ..< 10 ))
		#expect( 10.isIn( 0 ... 10 ))
		#expect( !11.isIn( 0 ... 10 ))
	}

	@Test("Comparison with zero")
	func zeroComparisons() {
		#expect( 1.greaterThanZero )
		#expect( (-1.0).lessThanZero )
		#expect( 0.equalToZero )
		#expect( 0.greaterThanOrEqualToZero )
		#expect( 0.0.lessThanOrEqualToZero )
	}

	@Test("Arithmetic shorthands")
	func arithmeticShorthands() {
		#expect( 2.0.doubled == 4.0 )
		#expect( 5.0.halved == 2.5 )
		#expect( 2.0.tripled == 6.0 )
		#expect( 9.0.third == 3.0 )
	}
}
