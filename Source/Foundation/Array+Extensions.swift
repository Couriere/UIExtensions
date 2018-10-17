//
//  Array+Extensions.swift
//
//  Created by Vladimir Kazantsev on 02.02.15.
//  Copyright (c) 2015. All rights reserved.
//
import Foundation

public extension Collection {

	/// A Boolean value indicating whether the collection is not empty.
	///
	/// Convenience method, returning `!isEmpty`.
	public var isNotEmpty: Bool { return !isEmpty }
}


public extension Array {

	/**
	Creates an array from an optional element.
	Type of array elements is non-optional argument type.
	If an element is `nil`, creates empty array.

	```
	let optional: Int? = 5
	let array = Array( optional ) // => [ 5 ]

	let emptyOptional: Int? = nil
	let array = Array( emptyOptional ) // => []
	```
	*/
	public init( _ element: Element? ) {
		if let element = element {
			self = [ element ]
		} else {
			self = []
		}
	}
}

public extension Array {

	/**
	Returns an array with appended element.

	```
	[ 10, 20 ] + 30 => [ 10, 20, 30 ]
	[ 10, 20 ].appending( 30 ) => [ 10, 20, 30 ]
	```
	*/
	public static func +( array: Array, element: Element ) -> Array {
		var mutableArray = array
		mutableArray.append( element )
		return mutableArray
	}

	public func appending( _ element: Element ) -> Array<Element> {
		var mutableArray = self
		mutableArray.append( element )
		return mutableArray
	}


	/**
	Returns an array with appended optional element.
	If an element is `nil`, returns array.

	```
	let optional: Int? = 30
	[ 10, 20 ] + optional => [ 10, 20, 30 ]

	let emptyOptional: Int? = nil
	[ 10, 20 ] + emptyOptional => [ 10, 20 ]
	```
	*/
	public static func +( array: Array, element: Element?) -> Array {
		if let element = element { return array + [ element ] }
		return array
	}

	/**
	Appends element to an array.

	```
	var array = [ 10, 20 ]
	array += 30
	print( array ) // => [ 10, 20, 30 ]
	```
	*/
	public static func +=( array: inout Array, element: Element ) {
		array.append( element )
	}

	/**
	Appends optional element to an array.
	If an element is `nil`, does nothing.


	```
	var array = [ 10, 20 ]
	let optional: Int? = 30
	let emptyOptional: Int? = nil

	array += optional
	print( array ) // => [ 10, 20, 30 ]
	array += emptyOptional
	print( array ) // => [ 10, 20, 30 ]
	```
	*/
	public static func +=( array: inout Array, element: Element? ) {
		if let element = element { array.append( element ) }
	}
}

public extension Array {
	/// Safely gets an element with index.
	/// Returns `nil` if index is out of bounds.
	subscript ( safe index: Int ) -> Element? {
		return indices ~= index ? self[ index ] : nil
	}

	/// Splits an array in chunks, `chunkSize` size each.
	func chunk( _ chunkSize: Int ) -> [[Element]] {
		return stride( from: 0, to: self.count, by: chunkSize ).map { startIndex -> [Element] in
			let endIndex = ( startIndex.advanced( by: chunkSize ) > self.count ) ? self.count - startIndex : chunkSize
			return Array( self[ startIndex..<startIndex.advanced( by: endIndex )] )
		}
	}
}

public extension Array where Element: Equatable {
	
	mutating func remove( _ element: Element ) {
		if let index = self.index( of: element ) {
			self.remove( at: index )
		}
	}
	
	mutating func appendIfNotExist( _ newElement: Element ) {
		if index( of: newElement ) == nil {
			append( newElement )
		}
	}
}


public extension Set {
	mutating func toggle( _ member: Element ) {
		if contains( member ) { remove(member) } else { insert(member) }
	}
}
