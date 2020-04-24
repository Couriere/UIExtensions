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

#if swift(>=5.1)
class UserDefaults_PropertyWrapper: XCTestCase {

	@UserDefault( "valueStore", defaultValue: -1 ) var valueStore: Int
	@UserDefault( "optionalValueStore", defaultValue: nil ) var optionalValueStore: Double?

	@UserDefault( "arrayStore", defaultValue: [] ) var arrayStore: [ CGFloat ]
	@UserDefault( "optionalArrayStore", defaultValue: nil ) var optionalArrayStore: [ CGPoint ]?

	@UserDefault( "structStore", defaultValue: .default ) var structStore: Test
	@UserDefault( "optionalStructStore", defaultValue: nil ) var optionalStructStore: Test?

	@UserDefault( "existingValueStore", defaultValue: nil ) var existingValueStore: URL?
	@UserDefault( "existingLegacyValueStore", defaultValue: 0 ) var existingLegacyValueStore: Int

	@UserDefault( "updatedFromiOS12URLValue", defaultValue: nil ) var updatedFromiOS12URLValue: URL?
	@UserDefault( "updatedFromiOS12ArrayValue", defaultValue: [] ) var updatedFromiOS12ArrayValue: [ Int ]
	@UserDefault( "updatedFromiOS12DictionaryValue", defaultValue: [:] ) var updatedFromiOS12DictionaryValue: [ String : Int ]
	@UserDefault( "updatedFromiOS12SetValue", defaultValue: [] ) var updatedFromiOS12SetValue: Set<String>


	static let nonStandardSuite = UserDefaults( suiteName: "NonStandardSuite" )!
	@UserDefault( "nonStandardSuiteValue",
				  defaultValue: nil,
				  suite: UserDefaults_PropertyWrapper.nonStandardSuite )
	var nonStandardSuiteValue: Data?

	let testURL = URL( string: "https://www.apple.com" )!

	override func setUp() {
		let defaults = UserDefaults.standard
		defaults.removeObject( forKey: "valueStore" )
		defaults.removeObject( forKey: "optionalValueStore" )
		defaults.removeObject( forKey: "arrayStore" )
		defaults.removeObject( forKey: "optionalArrayStore" )
		defaults.removeObject( forKey: "structStore" )
		defaults.removeObject( forKey: "optionalStructStore" )
		defaults.removeObject( forKey: "existingValueStore" )
		defaults.removeObject( forKey: "updatingFromiOS12Value" )
		defaults.removeObject( forKey: "updatedFromiOS12ArrayValue" )
		defaults.removeObject( forKey: "updatedFromiOS12DictionaryValue" )
		defaults.removeObject( forKey: "updatedFromiOS12SetValue" )

		UserDefaults_PropertyWrapper.nonStandardSuite.removeObject( forKey: "nonStandardSuiteValue" )
	}

	func testInt() {

		XCTAssertEqual( valueStore, -1 )
		valueStore = 1
		XCTAssertEqual( valueStore, 1 )

		XCTAssertEqual( optionalValueStore, nil )
		optionalValueStore = 1.1
		XCTAssertEqual( optionalValueStore, 1.1 )
		optionalValueStore = nil
		XCTAssertEqual( optionalValueStore, nil )
	}

	func testAray() {

		XCTAssertEqual( arrayStore, [] )
		arrayStore = [ 100, 5.123 ]
		XCTAssertEqual( arrayStore, [ 100, 5.123 ] )
		arrayStore.insert( -1, at: 0 )
		XCTAssertEqual( arrayStore, [ -1, 100, 5.123 ] )
		arrayStore.remove( at: 1 )
		XCTAssertEqual( arrayStore, [ -1, 5.123 ] )
		arrayStore.removeAll()
		XCTAssertEqual( arrayStore, [] )

		let p1 = CGPoint( x: 1, y: -2.1 )
		let p2 = CGPoint( x: 100.5, y: -2.1 )
		let p3 = CGPoint( x: -50, y: 3.2 )

		XCTAssertEqual( optionalArrayStore, nil )
		optionalArrayStore = [ p1, p2 ]
		XCTAssertEqual( optionalArrayStore, [ p1, p2 ] )
		optionalArrayStore! += p3
		XCTAssertEqual( optionalArrayStore, [ p1, p2, p3 ] )
		optionalArrayStore?.remove( at: 0 )
		XCTAssertEqual( optionalArrayStore, [ p2, p3 ] )
		optionalArrayStore = nil
		XCTAssertEqual( optionalArrayStore, nil )
	}


	struct Test: Codable, Equatable {
		let i: Int
		let s: String
		let os: String?
		let a: [ String ]

		static let `default` = Test( i: -100, s: "Test", os: nil, a: [ "String1", "String2" ] )
	}

	func testCodable() {

		let test = Test( i: 100, s: "Anti", os: "Optional", a: [] )

		XCTAssertEqual( structStore, Test.default )
		structStore = test
		XCTAssertEqual( structStore, test )

		XCTAssertEqual( optionalStructStore, nil )
		optionalStructStore = .default
		XCTAssertEqual( optionalStructStore, Test.default )
		optionalStructStore = nil
		XCTAssertEqual( optionalStructStore, nil )
		optionalStructStore = test
		XCTAssertEqual( optionalStructStore, test )
	}

	func testNonStandardSuiteValue() {

		let testData = "TestString".data( using: .utf8 )

		XCTAssertEqual( nonStandardSuiteValue, nil )
		nonStandardSuiteValue = testData
		XCTAssertEqual( nonStandardSuiteValue, testData )

		XCTAssertNil( UserDefaults.standard.value( forKey: "nonStandardSuiteValue" ) )
	}

	func testExistingAndLegacyValue() {

		let defaults = UserDefaults.standard

		if #available( iOS 13, tvOS 13, watchOS 6, * ) {
			defaults.set( try! JSONEncoder().encode( testURL ), forKey: "existingValueStore" )
		} else {
			defaults.set( try! JSONEncoder().encode( [ testURL ] ), forKey: "existingValueStore" )
		}

		defaults.set( 100, forKey: "existingLegacyValueStore" )

		XCTAssertEqual( existingValueStore, testURL )
		XCTAssertEqual( existingLegacyValueStore, 100 )
	}

	// Checking that value will be read correctly after update from iOS 12 and earlier
	// to iOS 13 and later.
	func testUpgradeValue() {

		if #available( iOS 13, tvOS 13, watchOS 6, * ) {

			UserDefaults.standard.set( try! JSONEncoder().encode( [ testURL ] ), forKey: "updatedFromiOS12URLValue" )
			XCTAssertEqual( updatedFromiOS12URLValue, testURL )

			let array = [ 1, -2, 30 ]
			UserDefaults.standard.set( try! JSONEncoder().encode( [ array ] ), forKey: "updatedFromiOS12ArrayValue" )
			XCTAssertEqual( updatedFromiOS12ArrayValue, array )

			let dictionary = [ "key1" : 1, "key2" : -2, "key3" : 30 ]
			UserDefaults.standard.set( try! JSONEncoder().encode( [ dictionary ] ), forKey: "updatedFromiOS12DictionaryValue" )
			XCTAssertEqual( updatedFromiOS12DictionaryValue, dictionary )

			let set = Set<String>( [ "first", "second", "something" ] )
			UserDefaults.standard.set( try! JSONEncoder().encode( [ set ] ), forKey: "updatedFromiOS12SetValue" )
			XCTAssertEqual( updatedFromiOS12SetValue, set )
		}
	}
}
#endif
