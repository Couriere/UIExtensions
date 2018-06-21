//
//  Array+Extensions-Tests.swift
//  UIExtensionsTests
//
//  Created by Vladimir on 21.06.2018.
//  Copyright © 2018 Vladimir Kazantsev. All rights reserved.
//

import XCTest


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
}
