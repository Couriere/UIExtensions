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
	static func +( array: Self, element: Element ) -> Self {
		return array + [ element ]
	}

	func appending( _ element: Element ) -> Self {
		return self + [ element ]
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
	static func +( array: Self, element: Element? ) -> Self {
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
	static func +=( array: inout Self, element: Element ) {
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
	static func +=( array: inout Self, element: Element? ) {
		if let element = element { array.append( element ) }
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

public extension Set {
	mutating func toggle( _ member: Element ) {
		if contains( member ) { remove(member) } else { insert(member) }
	}
}
