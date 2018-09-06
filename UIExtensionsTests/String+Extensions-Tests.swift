//
//  String+Extensions-Tests.swift
//  UIExtensionsTests
//
//  Created by Vladimir on 06.09.2018.
//  Copyright © 2018 Vladimir Kazantsev. All rights reserved.
//

import XCTest

class StringExtensionsTests: XCTestCase {

	func testReplacingNSRangeWithText() {

		let string = "Quick brown fox jumps over the lazy dog."

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 0, length: 1 ), with: "q" ),
			"quick brown fox jumps over the lazy dog." )

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 0, length: 5 ), with: "Fast" ),
			"Fast brown fox jumps over the lazy dog." )

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 6, length: 5 ), with: "red" ),
			"Quick red fox jumps over the lazy dog." )

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 36, length: 4 ), with: "wolf!" ),
			"Quick brown fox jumps over the lazy wolf!" )

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 39, length: 1 ), with: "!" ),
			"Quick brown fox jumps over the lazy dog!" )
	}

	func testReplacingNSRangeWithNothing() {

		let string = "Quick brown fox jumps over the lazy dog."

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 0, length: 1 ), with: "" ),
			"uick brown fox jumps over the lazy dog." )

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 0, length: 6 ), with: "" ),
			"brown fox jumps over the lazy dog." )

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 6, length: 6 ), with: "" ),
			"Quick fox jumps over the lazy dog." )

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 35, length: 5 ), with: "" ),
			"Quick brown fox jumps over the lazy" )

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 39, length: 1 ), with: "" ),
			"Quick brown fox jumps over the lazy dog" )
	}

	func testReplacingNSRangeEdgeCases() {

		let string = "Quick brown fox jumps over the lazy dog."

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 0, length: 40 ), with: "" ),
			"" )

		XCTAssertEqual(
			string.replacingCharacters( in: NSRange( location: 0, length: 0 ), with: "New " ),
			"New Quick brown fox jumps over the lazy dog." )

		XCTAssertEqual(
			"".replacingCharacters( in: NSRange( location: 0, length: 0 ), with: "" ),
			"" )

		XCTAssertEqual(
			"".replacingCharacters( in: NSRange( location: 0, length: 0 ), with: "New" ),
			"New" )
	}

	func testDigitsOnly() {

		XCTAssertEqual( "1s2t3r4i5n6g7".digitsOnly, "1234567" )
		XCTAssertEqual( "123string321".digitsOnly, "123321" )

		XCTAssertEqual( "321 123".digitsOnly, "321123" )
		XCTAssertEqual( " 789  ".digitsOnly, "789" )

		XCTAssertEqual( "123321".digitsOnly, "123321" )
		XCTAssertEqual( "1".digitsOnly, "1" )
		XCTAssertEqual( "string".digitsOnly, "" )

		XCTAssertEqual( "".digitsOnly, "" )
	}

	func testIsValidEmail() {

		XCTAssertTrue( "test@email.com".isValidEmail )

		XCTAssertFalse( "test@email.".isValidEmail )
		XCTAssertFalse( "test@email".isValidEmail )
		XCTAssertFalse( "test@.com".isValidEmail )
		XCTAssertFalse( "test@.".isValidEmail )
		XCTAssertFalse( "test@".isValidEmail )
		XCTAssertFalse( "test".isValidEmail )

		XCTAssertFalse( "@email.com".isValidEmail )
		XCTAssertFalse( "email.com".isValidEmail )

		XCTAssertFalse( "".isValidEmail )
	}

	func testPluralForm() {

		let forms = ( "яйцо", "яйца", "яиц" )

		XCTAssertEqual( pluralString( forNumber: 0, fromWordForms: forms ), "яиц" )
		XCTAssertEqual( pluralString( forNumber: 1, fromWordForms: forms ), "яйцо" )
		XCTAssertEqual( pluralString( forNumber: 2, fromWordForms: forms ), "яйца" )
		XCTAssertEqual( pluralString( forNumber: 5, fromWordForms: forms ), "яиц" )
		XCTAssertEqual( pluralString( forNumber: 10, fromWordForms: forms ), "яиц" )
		XCTAssertEqual( pluralString( forNumber: 11, fromWordForms: forms ), "яиц" )
		XCTAssertEqual( pluralString( forNumber: 13, fromWordForms: forms ), "яиц" )
		XCTAssertEqual( pluralString( forNumber: 15, fromWordForms: forms ), "яиц" )
		XCTAssertEqual( pluralString( forNumber: 20, fromWordForms: forms ), "яиц" )
		XCTAssertEqual( pluralString( forNumber: 21, fromWordForms: forms ), "яйцо" )
		XCTAssertEqual( pluralString( forNumber: 22, fromWordForms: forms ), "яйца" )
		XCTAssertEqual( pluralString( forNumber: 25, fromWordForms: forms ), "яиц" )
		XCTAssertEqual( pluralString( forNumber: 100, fromWordForms: forms ), "яиц" )
		XCTAssertEqual( pluralString( forNumber: 101, fromWordForms: forms ), "яйцо" )
		XCTAssertEqual( pluralString( forNumber: 111, fromWordForms: forms ), "яиц" )
		XCTAssertEqual( pluralString( forNumber: 131, fromWordForms: forms ), "яйцо" )
		XCTAssertEqual( pluralString( forNumber: 133, fromWordForms: forms ), "яйца" )
	}

	func testStringPlural() {

		let word = "стол"

		XCTAssertEqual( word.plural( forNumber: 0 ), "столов" )
		XCTAssertEqual( word.plural( forNumber: 1 ), "стол" )
		XCTAssertEqual( word.plural( forNumber: 3 ), "стола" )
		XCTAssertEqual( word.plural( forNumber: 5 ), "столов" )
		XCTAssertEqual( word.plural( forNumber: 11 ), "столов" )
		XCTAssertEqual( word.plural( forNumber: 21 ), "стол" )
		XCTAssertEqual( word.plural( forNumber: 100 ), "столов" )
		XCTAssertEqual( word.plural( forNumber: 111 ), "столов" )
		XCTAssertEqual( word.plural( forNumber: 122 ), "стола" )
	}
}
