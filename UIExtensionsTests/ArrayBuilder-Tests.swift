//
//  ArrayBuilder-Tests.swift
//  
//
//  Created by Vladimir Kazantsev on 26.04.2024.
//

import XCTest
import UIExtensions

final class ArrayBuilder_Tests: XCTestCase {

	let bool = false

	func testArrayBuilder() throws {

		test( [] ) {
		}

		test( ["hello"] ) {
			"hello"
		}

		test( ["hello", "world"] ) {
			"hello"
			"world"
		}

		test( ["world"] ) {
			if bool {
				"hello"
			} else {
				"world"
			}
		}

		test( ["world", "world"] ) {
			if bool {
				"hello"
				"hello"
			} else {
				"world"
				"world"
			}
		}

		test( ["world", "world"] ) {
			if bool {
				"hello"
				"hello"
			} else if !bool {
				"world"
				"world"
			} else {
				""
			}
		}

		test( [] ) {
			if bool {
				"hello"
			}
		}

		test( ["hello"] ) {
			if !bool {
				if !bool {
					"hello"
				}
			}
		}

		test( ["world"] ) {
			if bool {
				"hello"
			}
			if !bool {
				"world"
			}
		}

		test( ["foo", "world"]) {
			"foo"
			if bool {
				"hello"
			} else {
				"world"
			}
		}

		test( ["foo", "world"] ) {
			["foo", "world"]
		}


		test( ["world1", "hello2"] ) {
			if bool {
				"hello1"
			} else {
				"world1"
			}
			if !bool {
				"hello2"
			} else {
				"world2"
			}
		}

		test( ["hello", "world"] ) {
			["hello", "world"].map { str in
				str
			}
		}


		test( ["world"] ) {
			switch bool {
			case true: "hello"
			case false: "world"
			}
		}

		test( "1", "2", "3" ) {
			for i in 1...3 {
				i.string
			}
		}
	}

	func testArrayInitWithBuilder() {

		XCTAssertEqual(
			["hello"],
			Array<String> { "hello" }
		)
		
		XCTAssertEqual(
			["hello", "world"],
			Array<String> { "hello"; "world" }
		)
		
		XCTAssertEqual(
			["world"],
			Array<String> {
				if bool { 
					"hello"
				} else {
					"world"
				}
			}
		)

		XCTAssertEqual(
			[],
			Array<String> {
				if bool { "hello" }
			}
		)

		XCTAssertEqual(
			[ "world", "world" ],
			Array<String> {
				"world"
				"world"
				if bool {
					"hello"
					"optional"
				}
			}
		)

		XCTAssertEqual(
			[ "world", "world" ],
			Array<String> {
				"world"
				if bool {
					"hello"
					"optional"
				}
				"world"
			}
		)

		XCTAssertEqual(
			[ "world", "world" ],
			Array<String> {
				if bool {
					"hello"
					"optional"
				}
				"world"
				"world"
			}
		)
		XCTAssertEqual(
			[ "optional", "world", "world" ],
			Array<String> {
				if bool {
					"hello"
					"optional"
				}
				if !bool {
					"optional"
				}
				"world"
				"world"
			}
		)

		XCTAssertEqual(
			["world"],
			Array<String> {
				["world"]
				if bool {
					"hello"
					"optional"
				}
			}
		)
	}

	func test(
		_ expected: [String],
		@ArrayBuilder<String> block: () -> [String]
	) {
		XCTAssertEqual(expected, block())
	}
	func test(
		_ expected: String...,
		@ArrayBuilder<String> block: () -> [String]
	) {
		XCTAssertEqual(expected, block())
	}
}
