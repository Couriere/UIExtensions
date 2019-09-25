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

class DefaultsTests: XCTestCase {

	var defaults = UserDefaults()

	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}


	func testInts() {

		let intKey = DefaultsKey<Int>( key: "IntKey", userDefaults: defaults )
		intKey.remove()

		// Should be nil here
		XCTAssertNil( intKey[] )
		// Default value
		XCTAssertTrue( intKey[ 0 ] == 0 )

		intKey[] = -19
		XCTAssertTrue( intKey[] == -19 )
		intKey[] = 20
		XCTAssertTrue( intKey[] == 20 )
		XCTAssertTrue( intKey[ 50 ] == 20 )
	}

	func testBool() {

		let boolKey = DefaultsKey<Bool>( key: "BoolKey", userDefaults: defaults )
		boolKey.remove()

		// Should be nil here
		XCTAssertNil( boolKey[] )
		// Default value
		XCTAssertTrue( boolKey[ true ] == true )

		boolKey[] = false
		XCTAssertTrue( boolKey[] == false )
		boolKey[] = true
		XCTAssertTrue( boolKey[] == true )
		XCTAssertTrue( boolKey[ false ] == true )
	}

	func testStrings() {

		let stringKey = DefaultsKey<String>( key: "StringKey", userDefaults: defaults )
		stringKey.remove()

		// Should be nil here
		XCTAssertNil( stringKey[] )
		// Default value
		XCTAssertTrue( stringKey[ "Default" ] == "Default" )

		stringKey[] = "Value one"
		XCTAssertTrue( stringKey[] == "Value one" )
		stringKey[] = "Another value"
		XCTAssertTrue( stringKey[] == "Another value" )
		XCTAssertTrue( stringKey[ "Some default" ] == "Another value" )
	}

	func testArray() {

		let intArray = DefaultsKey<[Int]>( key: "IntArray", userDefaults: defaults )
		intArray.remove()

		// Should be nil here
		XCTAssertNil( intArray[] )
		// Default value
		XCTAssert( intArray[ [ 0, 1, 3 ] ] == [ 0, 1, 3 ] )

		intArray[] = [-1, 100, 198 ]
		XCTAssertNotNil( intArray[] )
		XCTAssertTrue( intArray[]! == [-1, 100, 198 ] )
		intArray[]! += [ 10 ]
		XCTAssertTrue( intArray[]! == [-1, 100, 198, 10 ] )

		intArray[]![0] = 20
		XCTAssertTrue( intArray[]! == [ 20, 100, 198, 10 ] )
	}

	func testDate() {

		let dateKey = DefaultsKey<Date>( key: "DateKey", userDefaults: defaults )
		dateKey.remove()

		// Should be nil here
		XCTAssertNil( dateKey[] )
		// Default value
		let current = Date()
		XCTAssertTrue( dateKey[ current ] == current )

		dateKey[] = current
		XCTAssertTrue( dateKey[] == current )
		dateKey[] = current.addingTimeInterval( 1000 )
		XCTAssertTrue( dateKey[] == current.addingTimeInterval( 1000 ) )
		XCTAssertTrue( dateKey[ current ] == current.addingTimeInterval( 1000 ) )
	}

	func testData() {

		let dataKey = DefaultsKey<Data>( key: "DataKey", userDefaults: defaults )
		dataKey.remove()

		// Should be nil here
		XCTAssertNil( dataKey[] )
		// Default value
		let string = "Some Стрендж String"
		let string2 = "Some Атзер String"
		let data = string.data( using: .utf8 )!
		XCTAssertTrue( dataKey[ data ] == data )

		dataKey[] = data
		XCTAssertTrue( String( data: dataKey[] ?? string2.data( using: .utf8 )!,
		                       encoding: .utf8 ) == string )
	}
}
