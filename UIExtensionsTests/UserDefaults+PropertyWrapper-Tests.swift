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
import Combine

#if swift(>=5.1)
@MainActor
final class UserDefaults_PropertyWrapper: XCTestCase, @unchecked Sendable {

	@CodableUserDefault( "valueStore" ) var valueStore: Int = -1
	@CodableUserDefault( "optionalValueStore" ) var optionalValueStore: Double?

	@CodableUserDefault( "arrayStore" ) var arrayStore: [ CGFloat ] = []
	@CodableUserDefault( "optionalArrayStore" ) var optionalArrayStore: [ CGPoint ]?

	@CodableUserDefault( "dataStore" ) var dataStore: Data = Data()
	@CodableUserDefault( "optionalDataStore" ) var optionalDataStore: Data?

	@CodableUserDefault( "structStore" ) var structStore: Test = .default
	@CodableUserDefault( "optionalStructStore" ) var optionalStructStore: Test?

	@CodableUserDefault( "existingValueStore" ) var existingValueStore: URL?
	@CodableUserDefault( "existingLegacyValueStore" ) var existingLegacyValueStore: Int = 0

	@CodableUserDefault( "updatedFromiOS12URLValue" ) var updatedFromiOS12URLValue: URL?
	@CodableUserDefault( "updatedFromiOS12ArrayValue" ) var updatedFromiOS12ArrayValue: [ Int ] = []
	@CodableUserDefault( "updatedFromiOS12DictionaryValue" ) var updatedFromiOS12DictionaryValue: [ String : Int ] = [:]
	@CodableUserDefault( "updatedFromiOS12SetValue" ) var updatedFromiOS12SetValue: Set<String> = []


	static let nonStandardSuite = UserDefaults( suiteName: "NonStandardSuite" )!
	@CodableUserDefault( "nonStandardSuiteValue",
				  store: UserDefaults_PropertyWrapper.nonStandardSuite )
	var nonStandardSuiteValue: Data?

	let testURL = URL( string: "https://www.apple.com" )!

	override func setUp() async throws {

		try await super.setUp()

		let defaults = UserDefaults.standard
		defaults.removeObject( forKey: "valueStore" )
		defaults.removeObject( forKey: "optionalValueStore" )
		defaults.removeObject( forKey: "dataStore" )
		defaults.removeObject( forKey: "optionalDataStore" )
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

	func testData() {
		XCTAssertEqual( dataStore, Data() )
		let data = "Test string".data( using: .utf8 )!
		dataStore = data
		XCTAssertEqual( dataStore, data )

		XCTAssertEqual( optionalDataStore, nil )
		let optionalData = "Test string".data( using: .utf8 )
		optionalDataStore = optionalData
		XCTAssertEqual( optionalDataStore, optionalData )
		optionalDataStore = nil
		XCTAssertEqual( optionalDataStore, nil )
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

//	func testChangeObservation() {
//
//		if #available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
//			let intBinding = $valueStore.binding
//			XCTAssertEqual( intBinding.wrappedValue, -1 )
//			valueStore = 1
//			XCTAssertEqual( intBinding.wrappedValue, 1 )
//			intBinding.wrappedValue = 2
//			XCTAssertEqual( intBinding.wrappedValue, 2 )
//			XCTAssertEqual( valueStore, 2 )
//
//			let firstExpectation = XCTestExpectation( description: "First value published" )
//			let secondExpectation = XCTestExpectation( description: "Second value published" )
//			let cancellable = $valueStore.publisher
//				.sink { value in
//					switch value {
//					case 2: firstExpectation.fulfill()
//					case 5: secondExpectation.fulfill()
//					default: XCTFail( "Unexpected value received" )
//					}
//				}
//			valueStore = 5
//			wait( for: [firstExpectation, secondExpectation], timeout: 1, enforceOrder: true )
//			cancellable.cancel()
//		}
//	}


	func testExistingAndLegacyValue() {

		let defaults = UserDefaults.standard

		defaults.set( try! JSONEncoder().encode( testURL ), forKey: "existingValueStore" )
		defaults.set( 100, forKey: "existingLegacyValueStore" )

		XCTAssertEqual( existingValueStore, testURL )
		XCTAssertEqual( existingLegacyValueStore, 100 )
	}

	func testRemove() {
		valueStore = 10
		XCTAssertEqual( valueStore, 10 )
		XCTAssertTrue( $valueStore.exists )
		$valueStore.remove()
		XCTAssertNil( UserDefaults.standard.object( forKey: $valueStore.key ))
		XCTAssertFalse( $valueStore.exists )
	}
}
#endif
