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
/// Property wrapper around Codable values backed by UserDefaults.
///
/// Usage:
/// ```
/// @UserDefault( "valueVariable", defaultValue: -1 ) var valueVariable: Int
///
///	@UserDefault( "optionalValueVariable",
///				  defaultValue: nil,
///				  suite: nonStandardUserDefaultsSuite )
///	var optionalValueVariable: Double?
/// ```
///
/// - note: Since actual data stored in UserDefaults is encoded data, representing
/// value, you can't simply get value back with usual `.object( forKey: )`, `.int( forKey: )` etc.
/// -
/// _However_, to support seamless upgrade, if there is value in UserDefaults,
/// stored by standard means, it will be correctly read.
@propertyWrapper
public struct UserDefault<T: Codable> {

	/// Key used to store values in UserDefaults.
	private let key: String

	/// Default value. Will be returned if value with `key` is not defined in UserDefaults.
	private let defaultValue: T

	/// UserDefaults suite used to store values. Defaults to `UserDefaults.standard`.
	private let suite: UserDefaults

	public init( _ key: String, defaultValue: T, suite: UserDefaults = .standard ) {
		self.key = key
		self.defaultValue = defaultValue
		self.suite = suite
	}

	public var wrappedValue: T {
		get {
			guard let rawData = suite.object( forKey: key ) else { return defaultValue }

			if let data = rawData as? Data,
				let value = try? _userDefaults_decoder.decode( T.self, from: data ) {
				return value
			}

			return rawData as? T ?? defaultValue
		}
		set {
			let data = try! _userDefaults_encoder.encode( newValue )
			suite.set( data, forKey: key )
		}
	}
}

private let _userDefaults_encoder = JSONEncoder()
private let _userDefaults_decoder = JSONDecoder()
#endif
