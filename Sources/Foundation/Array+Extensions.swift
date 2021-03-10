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

//
//  Array+Extensions.swift
//
//  Created by Vladimir Kazantsev on 02.02.15.
//  Copyright (c) 2015. All rights reserved.
//
import Foundation
#if os(macOS)
import AppKit
#endif

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
	init( _ element: Element? ) {
		if let element = element {
			self = [ element ]
		}
		else {
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
	static func + ( array: Array, element: Element ) -> Array {
		var mutableArray = array
		mutableArray.append( element )
		return mutableArray
	}

	func appending( _ element: Element ) -> [Element] {
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
	static func + ( array: Array, element: Element?) -> Array {
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
	static func += ( array: inout Array, element: Element ) {
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
	static func += ( array: inout Array, element: Element? ) {
		if let element = element { array.append( element ) }
	}
}

public extension Array {
	/// Safely gets an element with index.
	/// Returns `nil` if index is out of bounds.
	subscript( safe index: Int ) -> Element? {
		return indices ~= index ? self[ index ] : nil
	}

	/// Splits an array in chunks, `chunkSize` size each.
	func chunk( _ chunkSize: Int ) -> [[Element]] {
		return stride( from: 0, to: count, by: chunkSize ).map { startIndex -> [Element] in
			let endIndex = ( startIndex.advanced( by: chunkSize ) > self.count ) ? self.count - startIndex : chunkSize
			return Array( self[ startIndex ..< startIndex.advanced( by: endIndex )] )
		}
	}
}

public extension Array where Element: Equatable {

	mutating func remove( _ element: Element ) {
		if let index = self.firstIndex( of: element ) {
			remove( at: index )
		}
	}

	mutating func appendIfNotExist( _ newElement: Element ) {
		if self.firstIndex( of: newElement ) == nil {
			append( newElement )
		}
	}
}

public extension Array where Element : Collection, Element.Element : Equatable, Element.Index == Int {

	/// Search for an equatable element in two dimensional array.
	/// - parameter value: element to search.
	/// - returns: IndexPath of first element equal to parameter or nil if no such element found.
	func firstIndexPath( of value: Element.Element ) -> IndexPath? {
		for ( section, row ) in self.enumerated() {
			if let rowIndex = row.firstIndex( of: value ) {
				return IndexPath( item: rowIndex, section: section )
			}
		}
		return nil
	}
}

@available( iOS 13, tvOS 13, macOS 10.15, * )
public extension Array where Element : Collection, Element.Element : Identifiable, Element.Index == Int {

	/// Search for an identifiable element in two dimensional array.
	/// - parameter value: element to search.
	/// - returns: IndexPath of first element with the same id as parameter
	/// or nil if no such element found.
	func firstIndexPath( of value: Element.Element ) -> IndexPath? {
		for ( section, row ) in self.enumerated() {
			if let rowIndex = row.firstIndex( where: { $0.id == value.id } ) {
				return IndexPath( item: rowIndex, section: section )
			}
		}
		return nil
	}
}


public extension Set {
	mutating func toggle( _ member: Element ) {
		if contains( member ) { remove(member) } else { insert(member) }
	}
}
