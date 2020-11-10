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


class ArrayExtensionsTests: XCTestCase {

	func testOptionalInit() {

		let optionalIntVar: Int? = 50
		let optionalEmptyIntVar: Int? = nil

		XCTAssertEqual( Array( optionalIntVar ), [ 50 ] )
		XCTAssertEqual( Array( optionalEmptyIntVar ), [] )
	}

	func testPlusOperator() {
		let array: [ Int ] = [ 10, 20, 30 ]

		let intVar = 40
		let optionalIntVar: Int? = 50
		let optionalEmptyIntVar: Int? = nil

		XCTAssertEqual( array + intVar, [ 10, 20, 30, 40 ] )
		XCTAssertEqual( array + optionalIntVar, [ 10, 20, 30, 50 ] )
		XCTAssertEqual( array + optionalEmptyIntVar, [ 10, 20, 30 ] )


		let emptyArray: [ Int ] = []

		XCTAssertEqual( emptyArray + intVar, [ 40 ] )
		XCTAssertEqual( emptyArray + optionalIntVar, [ 50 ] )
		XCTAssertEqual( emptyArray + optionalEmptyIntVar, [] )
	}

	func testAppending() {
		let array: [ Int ] = [ 10, 20, 30 ]

		let intVar = 40

		XCTAssertEqual( array.appending( intVar ), [ 10, 20, 30, 40 ] )

		let emptyArray: [ Int ] = []

		XCTAssertEqual( emptyArray.appending( intVar ), [ 40 ] )
	}

	func testPlusEqualOperator() {
		var array: [ Int ] = [ 10, 20, 30 ]

		let intVar = 40
		let optionalIntVar: Int? = 50
		let optionalEmptyIntVar: Int? = nil

		array += intVar
		XCTAssertEqual( array, [ 10, 20, 30, 40 ] )
		array += optionalIntVar
		XCTAssertEqual( array, [ 10, 20, 30, 40, 50 ] )
		array += optionalEmptyIntVar
		XCTAssertEqual( array, [ 10, 20, 30, 40, 50 ] )

		var emptyArray: [ Int ] = []
		emptyArray += intVar
		XCTAssertEqual( emptyArray, [ 40 ] )

		emptyArray = []
		emptyArray += optionalIntVar
		XCTAssertEqual( emptyArray, [ 50 ] )

		emptyArray = []
		emptyArray += optionalEmptyIntVar
		XCTAssertEqual( emptyArray, [] )
	}

	func testSafeIndex() {
		var array: [ Int ] = [ 10, 20, 30 ]

		XCTAssertEqual( array[ safe: 1 ], 20 )
		XCTAssertNil( array[ safe: -1 ] )
		XCTAssertNil( array[ safe: 3 ] )
		array += 40
		XCTAssertEqual( array[ safe: 3 ], 40 )

		let emptyArray: [ Int ] = []
		XCTAssertNil( emptyArray[ safe: 0 ] )
	}

	func testChunkArray() {

		let array: [ Int ] = [ 10, 20, 30, 40, 50, 60 ]
		XCTAssertEqual( array.chunk( 1 ), [ [ 10 ], [ 20 ], [ 30 ], [ 40 ], [ 50 ], [ 60 ] ] )
		XCTAssertEqual( array.chunk( 2 ), [ [ 10, 20 ], [ 30, 40 ], [ 50, 60 ] ] )
		XCTAssertEqual( array.chunk( 3 ), [ [ 10, 20, 30 ], [ 40, 50, 60 ] ] )
		XCTAssertEqual( array.chunk( 4 ), [ [ 10, 20, 30, 40 ], [ 50, 60 ] ] )
		XCTAssertEqual( array.chunk( 10 ), [ [ 10, 20, 30, 40, 50, 60 ] ] )

		let emptyArray: [ Int ] = []
		XCTAssertEqual( emptyArray.chunk( 1 ), [] )
	}

	func testFirstIndexPath() {
		let array = [ [ 10, 20 ], [ 30, 40, 45 ], [], [ 50, 60, 10, 70 ] ]

		XCTAssertEqual( array.firstIndexPath( of: 20 ), IndexPath( row: 1, section: 0 ) )
		XCTAssertEqual( array.firstIndexPath( of: 30 ), IndexPath( row: 0, section: 1 ) )
		XCTAssertEqual( array.firstIndexPath( of: 10 ), IndexPath( row: 0, section: 0 ) )
		XCTAssertEqual( array.firstIndexPath( of: 70 ), IndexPath( row: 3, section: 3 ) )
		XCTAssertNil( array.firstIndexPath( of: 0 ) )
	}


	func testFirstIdentifiableIndexPath() {
		struct I: Identifiable, ExpressibleByStringLiteral {
			let id: String

			init( stringLiteral: String ) {
				id = stringLiteral
			}
		}

		let array: [[ I ]] = [ [ "10", "20" ], [ "30", "40", "45" ], [], [ "50", "60", "10", "70" ] ]

		if #available(iOS 13, *) {
			XCTAssertEqual( array.firstIndexPath( of: "20" ), IndexPath( row: 1, section: 0 ) )
			XCTAssertEqual( array.firstIndexPath( of: "30" ), IndexPath( row: 0, section: 1 ) )
			XCTAssertEqual( array.firstIndexPath( of: "10" ), IndexPath( row: 0, section: 0 ) )
			XCTAssertEqual( array.firstIndexPath( of: "70" ), IndexPath( row: 3, section: 3 ) )
			XCTAssertNil( array.firstIndexPath( of: "0" ) )
		}
	}
}
