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

import Combine
import Foundation
import Testing
import UIExtensions

@MainActor
@Suite("CodableUserDefaultsTests", .serialized)
struct CodableUserDefaultsTests {

	@CodableUserDefaults( "valueStore" ) var valueStore: Int = -1
	@CodableUserDefaults( "optionalValueStore" ) var optionalValueStore: Double?

	@CodableUserDefaults( "arrayStore" ) var arrayStore: [ CGFloat ] = []
	@CodableUserDefaults( "optionalArrayStore" ) var optionalArrayStore: [ CGPoint ]?

	@CodableUserDefaults( "dataStore" ) var dataStore: Data = .init()
	@CodableUserDefaults( "optionalDataStore" ) var optionalDataStore: Data?

	@CodableUserDefaults( "structStore" ) var structStore: Test = .default
	@CodableUserDefaults( "optionalStructStore" ) var optionalStructStore: Test?

	@CodableUserDefaults( "existingValueStore" ) var existingValueStore: URL?
	@CodableUserDefaults( "existingLegacyValueStore" ) var existingLegacyValueStore: Int = 0
	@CodableUserDefaults( "legacyEnumStore" ) var legacyEnumStore: LegacyEnum = .first

	enum LegacyEnum: String, Codable {
		case first
		case second
	}

	static let nonStandardSuite = UserDefaults( suiteName: "NonStandardSuite" )!
	@CodableUserDefaults(
		"nonStandardSuiteValue",
		store: CodableUserDefaultsTests.nonStandardSuite,
	)
	var nonStandardSuiteValue: Data?

	let testURL = URL( string: "https://www.apple.com" )!

	init() {
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
		defaults.removeObject( forKey: "existingLegacyValueStore" )
		defaults.removeObject( forKey: "legacyEnumStore" )
		Self.nonStandardSuite.removeObject( forKey: "nonStandardSuiteValue" )
	}

	@Test
	func int() {

		#expect( valueStore == -1 )
		valueStore = 1
		#expect( valueStore == 1 )

		#expect( optionalValueStore == nil )
		optionalValueStore = 1.1
		#expect( optionalValueStore == 1.1 )
		optionalValueStore = nil
		#expect( optionalValueStore == nil )
		#expect( !$optionalValueStore.exists )
	}

	@Test
	func `test data`() {
		#expect( dataStore == Data() )
		let data = "Test string".data( using: .utf8 )!
		dataStore = data
		#expect( dataStore == data )

		#expect( optionalDataStore == nil )
		let optionalData = "Test string".data( using: .utf8 )
		optionalDataStore = optionalData
		#expect( optionalDataStore == optionalData )
		optionalDataStore = nil
		#expect( optionalDataStore == nil )
		#expect( !$optionalDataStore.exists )
	}

	@Test
	func aray() {

		#expect( arrayStore == [] )
		arrayStore = [ 100, 5.123 ]
		#expect( arrayStore == [ 100, 5.123 ] )
		arrayStore.insert( -1, at: 0 )
		#expect( arrayStore == [ -1, 100, 5.123 ] )
		arrayStore.remove( at: 1 )
		#expect( arrayStore == [ -1, 5.123 ] )
		arrayStore.removeAll()
		#expect( arrayStore == [] )

		let p1 = CGPoint( x: 1, y: -2.1 )
		let p2 = CGPoint( x: 100.5, y: -2.1 )
		let p3 = CGPoint( x: -50, y: 3.2 )

		#expect( optionalArrayStore == nil )
		optionalArrayStore = [ p1, p2 ]
		#expect( optionalArrayStore == [ p1, p2 ] )
		optionalArrayStore += p3
		#expect( optionalArrayStore == [ p1, p2, p3 ] )
		optionalArrayStore?.remove( at: 0 )
		#expect( optionalArrayStore == [ p2, p3 ] )
		optionalArrayStore = nil
		#expect( optionalArrayStore == nil )
	}

	struct Test: Codable, Equatable {
		let i: Int
		let s: String
		let os: String?
		let a: [ String ]

		static let `default` = Test( i: -100, s: "Test", os: nil, a: [ "String1", "String2" ] )
	}

	@Test
	func codable() {

		let test = Test( i: 100, s: "Anti", os: "Optional", a: [] )

		#expect( structStore == Test.default )
		structStore = test
		#expect( structStore == test )

		#expect( optionalStructStore == nil )
		optionalStructStore = .default
		#expect( optionalStructStore == Test.default )
		optionalStructStore = nil
		#expect( optionalStructStore == nil )
		#expect( !$optionalStructStore.exists )
		optionalStructStore = test
		#expect( optionalStructStore == test )
	}

	@Test
	func `non standard suite value`() {

		let testData = "TestString".data( using: .utf8 )

		#expect( nonStandardSuiteValue == nil )
		nonStandardSuiteValue = testData
		#expect( nonStandardSuiteValue == testData )

		#expect( UserDefaults.standard.value( forKey: "nonStandardSuiteValue" ) == nil )
	}

	@Test
	func `existing and legacy value`() throws {

		let defaults = UserDefaults.standard

		try defaults.set( JSONEncoder().encode( testURL ), forKey: "existingValueStore" )
		defaults.set( 100, forKey: "existingLegacyValueStore" )

		#expect( existingValueStore == testURL )
		#expect( existingLegacyValueStore == 100 )
	}

	@Test
	func `legacy codable raw representable value`() throws {
		let defaults = UserDefaults.standard
		try defaults.set( JSONEncoder().encode( LegacyEnum.second ), forKey: "legacyEnumStore" )
		#expect( legacyEnumStore == .second )

		legacyEnumStore = .first
		#expect( defaults.string( forKey: "legacyEnumStore" ) == "first" )
	}

	@Test
	func `publisher tracks direct writes`() throws {
		let suite = UUID().uuidString
		let defaults = try #require(UserDefaults( suiteName: suite ))
		defer { defaults.removePersistentDomain( forName: suite ) }

		let value = CodableUserDefaults( wrappedValue: 0, "publisherValue", store: defaults )
		var received: [Int] = []
		let cancellable = value.publisher.sink { received.append( $0 ) }

		defaults.set( 1, forKey: "publisherValue" )
		defaults.removeObject( forKey: "publisherValue" )
		#expect( received == [ 0, 1, 0 ] )
		withExtendedLifetime( cancellable ) {}
	}

	@MainActor
	final class ObservedModel: ObservableObject {
		@CodableUserDefaults( "observableObjectValue" ) var value: Int = 0

		init( store: UserDefaults ) {
			_value = CodableUserDefaults(
				wrappedValue: 0,
				"observableObjectValue",
				store: store,
			)
		}
	}

	@Test
	func `observable object tracks direct writes`() throws {
		let suite = UUID().uuidString
		let defaults = try #require(UserDefaults( suiteName: suite ))
		defer { defaults.removePersistentDomain( forName: suite ) }

		let model = ObservedModel( store: defaults )
		_ = model.value
		var changeCount = 0
		let cancellable = model.objectWillChange.sink { changeCount += 1 }

		defaults.set( 1, forKey: "observableObjectValue" )
		#expect( model.value == 1 )
		#expect( changeCount == 1 )
		withExtendedLifetime( cancellable ) {}
	}

	@Test
	func `test remove`() {
		valueStore = 10
		#expect( valueStore == 10 )
		#expect( $valueStore.exists )
		$valueStore.remove()
		#expect( UserDefaults.standard.object( forKey: "valueStore" ) == nil )
		#expect( !$valueStore.exists )
	}
}
