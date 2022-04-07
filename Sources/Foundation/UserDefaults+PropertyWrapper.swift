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

import Foundation

#if swift(>=5.1)
import Foundation
import SwiftUI
import Combine

/// Property wrapper around Codable values backed by UserDefaults.
///
/// Usage:
/// ```
/// @UserDefault( "valueVariable" ) var valueVariable: Int = -1
///
///	@UserDefault( "optionalValueVariable",
///				  storeName: nonStandardUserDefaultsSuiteName )
///	var optionalValueVariable: Double?
/// ```
@propertyWrapper
public struct UserDefault<Value: Codable> {

	/// Key used to store values in UserDefaults.
	public let key: String

	/// Default value. Will be returned if value with `key` is not defined in UserDefaults.
	public let defaultValue: Value

	/// UserDefaults suite used to store values. Defaults to `UserDefaults.standard`.
	public let store: UserDefaults

	public init( wrappedValue: Value, _ key: String, store: UserDefaults? = nil ) {
		self.key = key
		self.defaultValue = wrappedValue
		self.store = store ?? .standard
	}

	public init( wrappedValue: Value, _ key: String, storeName: String? ) {
		self.init( wrappedValue: wrappedValue, key, store: UserDefaults( suiteName: storeName ))
	}
	public init( wrappedValue: Value, _ key: String, suiteName: String? ) {
		self.init( wrappedValue: wrappedValue, key, storeName: suiteName )
	}

	@available( *, deprecated, message: "Use `init(wrapped:_:storeName)`" )
	public init( _ key: String, defaultValue: Value, suiteName: String? = nil ) {
		self.init( wrappedValue: defaultValue, key, store: UserDefaults( suiteName: suiteName ) ?? .standard )
	}

	public func remove() {
		store.removeObject( forKey: key )
	}

	public var exists: Bool {
		store.value( forKey: key ) != nil
	}

	public var wrappedValue: Value {
		get { getValue() }
		nonmutating set { setValue( newValue ) }
	}

	public var projectedValue: UserDefault<Value> {
		return self
	}


	// MARK: - Internals

	private func getValue() -> Value {
		guard let rawData = store.object( forKey: key ) else { return defaultValue }

		if let data = rawData as? Data {
			// On iOS 13 and later, just decoding value.
			if #available( iOS 13, tvOS 13, watchOS 6, * ),
			   let value = try? _userDefaults_decoder.decode( Value.self, from: data ) {
				return value
			}
			else {
				// On iOS 12 and earlier or if decoding failed,
				// attempting to decode proxy array value.
				if let proxyValue = try? _userDefaults_decoder.decode( [ Value ].self, from: data ),
				   let value = proxyValue.first {
					return value
				}
			}
		}

		return rawData as? Value ?? defaultValue
	}

	private func setValue( _ newValue: Value ) {
		if newValue is __PropertyList {
			store.set( newValue, forKey: key )
		} else {
			// On iOS 12 and earlier trying to encode simple values (Int, String, etc.) results
			// in fatal error `Top-level Optional<Int> encoded as number JSON fragment.`.
			if #available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
				let data = try! _userDefaults_encoder.encode( newValue )
				store.set( data, forKey: key )
			} else {
				// On iOS 12 and earlier encasing new value in array.
				let data = try! _userDefaults_encoder.encode( [ newValue ] )
				store.set( data, forKey: key )
			}
		}
	}
}

extension UserDefault where Value : ExpressibleByNilLiteral {

	public init(_ key: String, store: UserDefaults? = nil) where Value: Codable {
		self.init( wrappedValue: nil, key, store: store )
	}
	public init(_ key: String, storeName: String? ) where Value: Codable {
		self.init( wrappedValue: nil, key, storeName: storeName )
	}
}

private let _userDefaults_encoder = JSONEncoder()
private let _userDefaults_decoder = JSONDecoder()


private protocol __PropertyList {}
extension Bool: __PropertyList { }
extension Date: __PropertyList { }
extension String: __PropertyList { }
extension URL: __PropertyList { }

extension Int: __PropertyList { }
extension Int8: __PropertyList { }
extension Int16: __PropertyList { }
extension Int32: __PropertyList { }
extension Int64: __PropertyList { }
extension UInt: __PropertyList { }
extension UInt8: __PropertyList { }
extension UInt16: __PropertyList { }
extension UInt32: __PropertyList { }
extension UInt64: __PropertyList { }
extension Float: __PropertyList { }
extension Double: __PropertyList { }

extension CGPoint: __PropertyList { }
extension CGVector: __PropertyList { }
extension CGSize: __PropertyList { }
extension CGRect: __PropertyList { }
extension CGAffineTransform: __PropertyList { }

#endif
