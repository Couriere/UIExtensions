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

class Dictionary_Extensions_Tests: XCTestCase {

	func testMerging() {

		let dictionary1: [ String: Int ] = [ "a": 1, "b": 2, "c": 30, "d": 400 ]
		let dictionary2: [ String: Int ] = [ "a": -1, "x": -2, "c": -30, "z": -400 ]


		let result1Plus2: [ String: Int ] = [ "a": -1, "b": 2, "x": -2, "c": -30, "d": 400, "z": -400 ]
		let result2Plus1: [ String: Int ] = [ "a": 1, "b": 2, "x": -2, "c": 30, "d": 400, "z": -400 ]

		XCTAssertEqual( dictionary1 + dictionary2, result1Plus2 )
		XCTAssertEqual( dictionary2 + dictionary1, result2Plus1 )

		var testDictionary = dictionary1
		testDictionary.addEntriesFromDictionary( dictionary2 )
		XCTAssertEqual( testDictionary, result1Plus2 )

		testDictionary = dictionary2
		testDictionary += dictionary1
		XCTAssertEqual( testDictionary, result2Plus1 )

		testDictionary = dictionary1
		testDictionary += dictionary2
		XCTAssertEqual( testDictionary, result1Plus2 )
	}

	func testStringSanitizer() {

		let testDictionary1: [ String: String? ] = [ "One" : "One",
													 "Two" : "Two",
													 "Three" : nil,
													 "Four" : "Four",
													 "Five" : nil ]

		XCTAssert( testDictionary1.sanitized == [ "One" : "One",
												 "Two" : "Two",
												 "Four" : "Four" ] )

		let testDictionary2: [ String: String? ] = [ "One" : "One",
													 "Two" : "Two",
													 "Three" : "Three" ]

		XCTAssert( testDictionary2.sanitized == [ "One" : "One",
												 "Two" : "Two",
												 "Three" : "Three" ] )

		let testDictionary3: [ String: String? ] = [ "One" : nil ]

		XCTAssert( testDictionary3.sanitized.isEmpty )
	}

	func testIntSanitizer() {

		let testDictionary1: [ Int: Int? ] = [ 1 : 1, 2 : nil, 3 : 3, 4 : 4, 5 : nil ]
		XCTAssert( testDictionary1.sanitized == [ 1 : 1, 3 : 3, 4 : 4 ] )

		let testDictionary2: [ Int: Int? ] = [:]
		XCTAssert( testDictionary2.sanitized.isEmpty )

		let testDictionary3: [ Int: Int? ] = [ 100 : nil ]
		XCTAssert( testDictionary3.sanitized.isEmpty )
	}

	func testAnySanitizer() {

		let testDictionary1: [ Int: Any? ] = [ 1 : 1, 2 : nil, 3 : "Three", 4 : 30.5, 5 : nil ]
		let sanitized = testDictionary1.sanitized
		XCTAssert( ( sanitized[ 1 ] as? Int ) == 1 )
		XCTAssert( !sanitized.keys.contains( 2 ) )
		XCTAssert( ( sanitized[ 3 ] as? String ) == "Three" )
		XCTAssert( ( sanitized[ 4 ] as? Double ) == 30.5 )
		XCTAssert( !sanitized.keys.contains( 5 ) )

		let testDictionary2: [ Int: Any? ] = [:]
		XCTAssert( testDictionary2.sanitized.isEmpty )

		let testDictionary3: [ Int: Any? ] = [ 100 : nil ]
		XCTAssert( testDictionary3.sanitized.isEmpty )
	}
}
