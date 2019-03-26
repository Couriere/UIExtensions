//
//  Dictionary+Extensions.swift
//
//  Created by Vladimir Kazantsev on 23.01.15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

public extension Dictionary {

	func map<T, U>( _ transform: (Key, Value) throws -> (T, U) ) rethrows -> [T : U] {
		return Dictionary<T, U>( uniqueKeysWithValues: try self.map( transform ))
	}

	mutating func addEntriesFromDictionary( _ dict: [ Key: Value ] ) {
		self.merge( dict ) { $1 }
	}

	static func + ( lhs: Dictionary<Key,Value>, rhs: Dictionary<Key,Value> ) -> Dictionary<Key,Value> {
		return lhs.merging( rhs ) { $1 }
	}

	static func += ( lhs: inout Dictionary<Key,Value>, rhs: Dictionary<Key,Value> ) {
		lhs.merge( rhs ) { $1 }
	}


	func valueForKey<T>( _ key: Key, defaultValue: T ) -> T {
		if let value = self[ key ] as? T {
			return value
		} else {
			return defaultValue
		}
	}
}

public extension Dictionary where Value: OptionalType {

	/// Transforms dictionary with optional values to
	/// dictionary with values of the same but not optional type.
	/// All keys with `nil` values are dropped.
	var sanitized: [ Key: Value.Wrapped ] {

		var sanitizedDictionary: [ Key: Value.Wrapped ] = [:]

		self.forEach {
			if let value = $0.value.value { sanitizedDictionary[ $0.key ] = value }
		}

		return sanitizedDictionary
	}
}

/// Deprecated
public extension Dictionary {
	@available( swift, deprecated: 4.0, obsoleted: 5.0, message: "Use Dictionary( uniqueKeysWithValues: ) instead" )
	init(_ elements: [Element]){
		self.init()
		for (k, v) in elements {
			self[k] = v
		}
	}

	@available( swift, deprecated: 4.0, obsoleted: 5.0, message: "Use Dictionary.mapValues() instead." )
	func map<U>( _ transform: ( Value ) throws -> U ) throws -> [Key : U] {
		return Dictionary<Key, U>( try self.map { key, value in ( key, try transform( value )) } )
	}

	@available( swift, deprecated: 4.0, obsoleted: 5.0, message: "Use `Dictionary[ key, default: value ] instead" )
	subscript (key: Key, defaultValue: Value ) -> Value {
		if let value = self[ key ] {
			return value
		} else {
			return defaultValue
		}
	}
}
