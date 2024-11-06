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

public extension Collection {

	/// A Boolean value indicating whether the collection is not empty.
	///
	/// Convenience method, returning `!isEmpty`.
	var isNotEmpty: Bool { return !isEmpty }
}


public extension Collection {
	var array: [Element] { return Array( self ) }
}

public extension Collection where Element: Hashable {
	var set: Set<Element> { return Set( self ) }
}

public extension Collection where Element == Character {
	var string: String { return String( self ) }
}


public extension Collection where Self.Index == Int,
								  Self.Indices: RangeExpression,
								  Self.Indices.Bound == Int {
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

public extension Collection where Self.Index == Int,
								  Self.Element: Collection,
								  Self.Element.Index == Int {

	subscript( _ indexPath: IndexPath ) -> Element.Element {
		return self[ indexPath.section ][ indexPath.item ]
	}
}

public extension Collection where Self.Index == Int,
								  Self.Element: RandomAccessCollection,
								  Self.Element.Index == Int,
								  Self.Indices: RangeExpression,
								  Self.Indices.Bound == Int {

	subscript( safe indexPath: IndexPath ) -> Element.Element? {
		return self[ safe: indexPath.section ]?[ indexPath.item ]
	}
}


public extension Collection where Self.Element: Collection,
								  Self.Element.Index == Int {

	/// Returns the first indexPath in which an element of the two dimensional collection satisfies
	/// the given predicate.
	/// - parameter predicate: A closure that takes an element as its argument
	///   and returns a Boolean value that indicates whether the passed element
	///   represents a match.
	/// - returns: The IndexPath of the first element for which `predicate` returns
	///   `true`. If no elements in the collection satisfy the given predicate,
	///   returns `nil`.
	func firstIndexPath( where predicate: ( Self.Element.Element ) throws -> Bool) rethrows -> IndexPath? {

		for ( section, row ) in self.enumerated() {
			if let rowIndex = try row.firstIndex( where: predicate ) {
				return IndexPath( item: rowIndex, section: section )
			}
		}
		return nil
	}
}

public extension Collection where Self.Element: Collection,
								  Self.Element.Element: Equatable,
								  Self.Element.Index == Int {

	/// Search for an equatable element in two dimensional collection.
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

public extension Collection where Self.Element: Collection,
								  Self.Element.Element: Identifiable,
								  Self.Element.Index == Int {

	/// Search for an identifiable element in two dimensional collection.
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
