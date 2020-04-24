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

import UIKit

public extension Dictionary {

	func map<T, U>( _ transform: (Key, Value) throws -> (T, U) ) rethrows -> [T: U] {
		return [T: U]( uniqueKeysWithValues: try map( transform ))
	}

	mutating func addEntriesFromDictionary( _ dict: [ Key: Value ] ) {
		merge( dict ) { $1 }
	}

	static func + ( lhs: [Key: Value], rhs: [Key: Value] ) -> [Key: Value] {
		return lhs.merging( rhs ) { $1 }
	}

	static func += ( lhs: inout [Key: Value], rhs: [Key: Value] ) {
		lhs.merge( rhs ) { $1 }
	}


	func valueForKey<T>( _ key: Key, defaultValue: T ) -> T {
		if let value = self[ key ] as? T {
			return value
		}
		else {
			return defaultValue
		}
	}
}

public extension Dictionary where Value: OptionalType {

	/// Transforms dictionary with optional values to
	/// dictionary with values of the same but not optional type.
	/// All keys with `nil` values are dropped.
	/// - note: You should probably use `compactMapValues` instead
	var sanitized: [ Key: Value.Wrapped ] {
		return filter { $0.value.value != nil }.mapValues { $0.value! }
	}
}
