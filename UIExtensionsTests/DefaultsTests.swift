//
//  DefaultsTests.swift
//
//  Created by Vladimir Kazantsev on 27/04/16.
//  Copyright © 2016 MC2Soft. All rights reserved.
//

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
