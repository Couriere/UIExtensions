//
//  Numbers+Extensions-Tests.swift
//  UIExtensionsTests
//
//  Created by Vladimir on 07.09.2018.
//  Copyright © 2018 Vladimir Kazantsev. All rights reserved.
//

import XCTest

class NumbersExtensionsTests: XCTestCase {

	func testIntToString() {

		XCTAssertEqual( 0.string, "0" )
		XCTAssertEqual( 1.string, "1" )
		XCTAssertEqual( 105.string, "105" )
		XCTAssertEqual( (-3).string, "-3" )
	}

	func testFloatToString() {
		let float: Float = 1.234
		XCTAssertEqual( float.string, "1.234" )
		XCTAssertEqual( (-float).string, "-1.234" )
	}

	func testFloatToStringWithPrecision() {
		let float: Float = 1.23456
		XCTAssertEqual( float.toString( "0" ), "1.234560" )
		XCTAssertEqual( float.toString( "." ), "1" )
		XCTAssertEqual( float.toString( ".2" ), "1.23" )
		XCTAssertEqual( float.toString( "6.2" ), "  1.23" )

		XCTAssertEqual( (-float).toString( ".2" ), "-1.23" )
	}

	func testDoubleToString() {
		let double: Double = 1.234
		XCTAssertEqual( double.string, "1.234" )
		XCTAssertEqual( (-double).string, "-1.234" )
	}

	func testDoubleToStringWithPrecision() {
		let double: Double = 1.23456
		XCTAssertEqual( double.toString( "0" ), "1.234560" )
		XCTAssertEqual( double.toString( "." ), "1" )
		XCTAssertEqual( double.toString( ".2" ), "1.23" )
		XCTAssertEqual( double.toString( "6.2" ), "  1.23" )

		XCTAssertEqual( (-double).toString( ".2" ), "-1.23" )
	}

	func testFormatTimeInterval() {

		let t1: TimeInterval = 60*60*3 + 60*3 + 4
		XCTAssertEqual( t1.formatted, "03:03:04" )

		let t2: TimeInterval = 60*60*102
		XCTAssertEqual( t2.formatted, "102:00:00" )

		let t3: TimeInterval = 60*5 + 3
		XCTAssertEqual( t3.formatted, "00:05:03" )

		let t4: TimeInterval = 6
		XCTAssertEqual( t4.formatted, "00:00:06" )
	}


	func testPluralWordForms() {

		let forms = ( "яйцо", "яйца", "яиц" )

		XCTAssertEqual( 0.pluralWithForms( forms ), "0 яиц" )
		XCTAssertEqual( 1.pluralWithForms( forms ), "1 яйцо" )
		XCTAssertEqual( 2.pluralWithForms( forms ), "2 яйца" )
		XCTAssertEqual( 5.pluralWithForms( forms ), "5 яиц" )
		XCTAssertEqual( 10.pluralWithForms( forms ), "10 яиц" )
		XCTAssertEqual( 11.pluralWithForms( forms ), "11 яиц" )
		XCTAssertEqual( 13.pluralWithForms( forms ), "13 яиц" )
		XCTAssertEqual( 15.pluralWithForms( forms ), "15 яиц" )
		XCTAssertEqual( 20.pluralWithForms( forms ), "20 яиц" )
		XCTAssertEqual( 21.pluralWithForms( forms ), "21 яйцо" )
		XCTAssertEqual( 22.pluralWithForms( forms ), "22 яйца" )
		XCTAssertEqual( 25.pluralWithForms( forms ), "25 яиц" )
		XCTAssertEqual( 100.pluralWithForms( forms ), "100 яиц" )
		XCTAssertEqual( 101.pluralWithForms( forms ), "101 яйцо" )
		XCTAssertEqual( 111.pluralWithForms( forms ), "111 яиц" )
		XCTAssertEqual( 131.pluralWithForms( forms ), "131 яйцо" )
		XCTAssertEqual( 133.pluralWithForms( forms ), "133 яйца" )
	}

	func testPluralWord() {

		let word = "стол"

		XCTAssertEqual( 0.pluralForWord( word ), "0 столов" )
		XCTAssertEqual( 1.pluralForWord( word ), "1 стол" )
		XCTAssertEqual( 3.pluralForWord( word ), "3 стола" )
		XCTAssertEqual( 5.pluralForWord( word ), "5 столов" )
		XCTAssertEqual( 11.pluralForWord( word ), "11 столов" )
		XCTAssertEqual( 21.pluralForWord( word ), "21 стол" )
		XCTAssertEqual( 100.pluralForWord( word ), "100 столов" )
		XCTAssertEqual( 111.pluralForWord( word ), "111 столов" )
		XCTAssertEqual( 122.pluralForWord( word ), "122 стола" )
	}
}
