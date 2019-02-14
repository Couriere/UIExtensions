//
//  Dictionary+Extensions-Tests.swift
//  UIExtensionsTests
//
//  Created by Vladimir on 14/02/2019.
//  Copyright © 2019 Vladimir Kazantsev. All rights reserved.
//

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
}
