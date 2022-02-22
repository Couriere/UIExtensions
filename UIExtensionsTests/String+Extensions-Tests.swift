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
		XCTAssertTrue( "test@some.email.com".isValidEmail )

		XCTAssertFalse( "test@email..com".isValidEmail )
		XCTAssertFalse( "test@some.email..com".isValidEmail )
		XCTAssertFalse( "test@email...com".isValidEmail )
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


	func testMD5() {
		XCTAssertEqual( "Тестовая строка to check MD5".md5,
						"747cd064b470993af4e51486319fe074" )
		XCTAssertEqual( "😀😬🙈".md5,
						"bc1494412f7e419d501c0800ed47b822" )
		XCTAssertEqual( " ".md5,
						"7215ee9c7d9dc229d2921a40e899ec5f" )
		XCTAssertEqual( "".md5,
						"d41d8cd98f00b204e9800998ecf8427e" )
	}

	func testSHA1() {
		XCTAssertEqual( "Тестовая строка to check SHA1".sha1,
						"44197d5bf2333298efaa6520d6dd397ecc1e682d" )
		XCTAssertEqual( "😀😬🙈".sha1,
						"04273d71fd896908b4272eb4b758f425a4d0de1c" )
		XCTAssertEqual( " ".sha1,
						"b858cb282617fb0956d960215c8e84d1ccf909c6" )
		XCTAssertEqual( "".sha1,
						"da39a3ee5e6b4b0d3255bfef95601890afd80709" )
	}

	func testSHA256() {
		XCTAssertEqual( "Тестовая строка to check SHA256".sha256,
						"433c9fe61114200c2bf5537a8cd69d018a5816fcf39b043b2c43abcf5cf6391f" )
		XCTAssertEqual( "😀😬🙈".sha256,
						"ba73ca483c8f86642a9b8cb31dc3535b6c7e8f76b323890cf3230b9ae3dd3fc2" )
		XCTAssertEqual( " ".sha256,
						"36a9e7f1c95b82ffb99743e0c5c4ce95d83c9a430aac59f84ef3cbfab6145068" )
		XCTAssertEqual( "".sha256,
						"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" )
	}

	func testSHA512() {
		XCTAssertEqual( "Тестовая строка to check SHA512".sha512,
						"49fd739fb90b78e31ef56fd320ccb76c57fbd06b3a387daaa973991d4083ac60d2695cc18f0d196cdfdee902a600887594dfcdc95c8beec399e2be54cf26b27a" )
		XCTAssertEqual( "😀😬🙈".sha512,
						"1d9ed1f29831f8a0c7909c4d7f76dc8276f66bf86c7b609256bb3e45ebfea8861fbbd8d38e7b2ee196fa0b1916269fa959858b87607d60d48dfef337ccc0cd56" )
		XCTAssertEqual( " ".sha512,
						"f90ddd77e400dfe6a3fcf479b00b1ee29e7015c5bb8cd70f5f15b4886cc339275ff553fc8a053f8ddc7324f45168cffaf81f8c3ac93996f6536eef38e5e40768" )
		XCTAssertEqual( "".sha512,
						"cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e" )
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
