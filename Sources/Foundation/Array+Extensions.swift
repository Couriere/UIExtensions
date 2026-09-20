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
#if os(macOS)
import AppKit
#endif

// MARK: - Array + Optional Initializer

extension Array {

	/// Creates an array from an optional element.
	///
	/// If the provided element is non-`nil`, the resulting array contains
	/// exactly one element. If the element is `nil`, an empty array is created.
	///
	/// ## Example
	/// ```swift
	/// let value: Int? = 5
	/// let array = Array(value) // [5]
	///
	/// let empty: Int? = nil
	/// let emptyArray = Array(empty) // []
	/// ```
	///
	/// - Parameter element: An optional element.
	@inlinable
	public init(_ element: Element?) {
		if let element = element {
			self = [element]
		} else {
			self = []
		}
	}
}

extension Array {

	/// Returns an array of contiguous subarrays (“windows”) of the given size.
	///
	/// Each window contains `ofCount` consecutive elements from the original
	/// array. Windows are created by advancing the start index by one element
	/// each time. If a window would exceed the array bounds, it is omitted.
	///
	/// ## Example
	/// ```swift
	/// let array = [1, 2, 3, 4]
	/// let result = array.windows(ofCount: 2)
	/// // [[1, 2], [2, 3], [3, 4]]
	/// ```
	///
	/// - Parameter ofCount: The number of elements in each window.
	/// - Returns: An array of subarrays, each containing `ofCount` elements.
	///
	/// - Note: If `ofCount` is greater than the array count, the result is empty.
	@inlinable
	public func windows( ofCount: Int ) -> [[Element]] {

		indices.compactMap { startIndex in
			let end = startIndex.advanced(by: ofCount)
			guard end <= count else { return nil }

			return self[startIndex..<end].array
		}
	}
}

// MARK: - Array + Appending Operators

extension Array {

	/// Returns a new array with the given element appended.
	///
	/// ## Example
	/// ```swift
	/// [10, 20] + 30 // [10, 20, 30]
	/// ```
	///
	/// - Parameters:
	///   - array: The source array.
	///   - element: The element to append.
	/// - Returns: A new array containing the appended element.
	@inlinable
	public static func +(array: Self, element: Element) -> Self {
		array + [element]
	}

	/// Returns a new array with the given element appended.
	///
	/// - Parameter element: The element to append.
	/// - Returns: A new array containing the appended element.
	@inlinable
	public func appending(_ element: Element) -> Self {
		self + [element]
	}

	/// Returns a new array with the given optional element appended.
	///
	/// If the element is `nil`, the original array is returned unchanged.
	///
	/// ## Example
	/// ```swift
	/// let value: Int? = 30
	/// [10, 20] + value // [10, 20, 30]
	///
	/// let empty: Int? = nil
	/// [10, 20] + empty // [10, 20]
	/// ```
	///
	/// - Parameters:
	///   - array: The source array.
	///   - element: An optional element to append.
	/// - Returns: A new array with the element appended if it is non-`nil`.
	@inlinable
	public static func +(array: Self, element: Element?) -> Self {
		if let element = element {
			return array + [element]
		}
		return array
	}

	/// Appends the given element to the array.
	///
	/// ## Example
	/// ```swift
	/// var array = [10, 20]
	/// array += 30
	/// // [10, 20, 30]
	/// ```
	///
	/// - Parameters:
	///   - array: The array to modify.
	///   - element: The element to append.
	@inlinable
	public static func +=(array: inout Self, element: Element) {
		array.append(element)
	}

	/// Appends the given optional element to the array.
	///
	/// If the element is `nil`, the array is not modified.
	///
	/// ## Example
	/// ```swift
	/// var array = [10, 20]
	/// let value: Int? = 30
	/// let empty: Int? = nil
	///
	/// array += value
	/// array += empty
	/// // [10, 20, 30]
	/// ```
	///
	/// - Parameters:
	///   - array: The array to modify.
	///   - element: An optional element to append.
	@inlinable
	public static func +=(array: inout Self, element: Element?) {
		if let element = element {
			array.append(element)
		}
	}
}

// MARK: - Array + Equatable Utilities

extension Array where Element: Equatable {

	/// Removes the first occurrence of the specified element from the array.
	///
	/// If the element is not found, the array remains unchanged.
	///
	/// - Parameter element: The element to remove.
	@inlinable
	public mutating func remove(_ element: Element) {
		if let index = firstIndex(of: element) {
			remove(at: index)
		}
	}

	/// Appends the given element to the array only if it does not already exist.
	///
	/// - Parameter newElement: The element to append.
	@inlinable
	public mutating func appendIfNotExist(_ newElement: Element) {
		if firstIndex(of: newElement) == nil {
			append(newElement)
		}
	}
}

// MARK: - Set Utilities

extension Set {

	/// Toggles the presence of the given element in the set.
	///
	/// If the element exists in the set, it is removed.
	/// Otherwise, it is inserted.
	///
	/// - Parameter member: The element to toggle.
	@inlinable
	public mutating func toggle(_ member: Element) {
		if contains(member) {
			remove(member)
		} else {
			insert(member)
		}
	}
}

// MARK: - CollectionDifference Utilities

extension CollectionDifference.Change {

	/// Returns the element associated with the change.
	///
	/// This property returns the element for both insertion
	/// and removal changes.
	@inlinable
	public var element: ChangeElement {
		switch self {
		case .insert(_, let element, _):
			return element
		case .remove(_, let element, _):
			return element
		}
	}
}

// MARK: - Replacing And Transforming

extension Array {

	/// Returns a new array with the given range of elements replaced
	/// by the elements of the specified collection.
	///
	/// The number of new elements need not match the number of elements
	/// being removed. Passing an empty range inserts `newElements` at
	/// its lower bound, and passing an empty collection removes the
	/// elements in the range without replacement.
	///
	///     let nums = [ 10, 20, 30, 40, 50 ]
	///     print( nums.replacingSubrange( 1...3, with: repeatElement( 1, count: 5 )))
	///     // Prints "[10, 1, 1, 1, 1, 1, 50]"
	///
	/// - Parameters:
	///   - subrange: The range of elements to replace. Its bounds must be
	///     valid indices of the array.
	///   - newElements: The new elements to insert in place of `subrange`.
	/// - Returns: A copy of the array with the elements replaced.
	///
	/// - Complexity: O(*n* + *m*), where *n* is the length of the array
	///   and *m* is the length of `newElements`.
	@inlinable
	public func replacingSubrange<C, R>(
		_ subrange: R,
		with newElements: C,
	) -> [ Element ]
	where C: Collection,
		  R: RangeExpression,
		  Element == C.Element,
		  Int == R.Bound {

		var array = self
		array.replaceSubrange( subrange, with: newElements )
		return array
	}

	/// Rotates the array one position to the left.
	///
	/// The first element becomes the last one, and every other element
	/// moves one position towards the beginning. An empty array is
	/// returned unchanged.
	///
	///     print( [ 1, 2, 3 ].rotatingLeft() )
	///     // Prints "[2, 3, 1]"
	///
	/// - Returns: A copy of the array rotated one position to the left.
	@inlinable
	public func rotatingLeft() -> Self {

		guard isNotEmpty else { return self }

		var mutable = self
		mutable.append( mutable.removeFirst() )

		return mutable
	}

	/// Replaces every element of the array with a mutated copy of itself.
	///
	/// Use this method to change a property of every element in place,
	/// without writing an index-based loop.
	///
	///     items.changeEach { $0.isSelected = false }
	///
	/// - Parameter perform: A closure that mutates the element passed to it.
	@inlinable
	public mutating func changeEach( _ perform: ( inout Element ) -> Void ) {
		self = changingEach( perform )
	}
}

extension Array where Element: Equatable {

	/// Toggles the presence of the given element in the array.
	///
	/// If the array contains the element, every occurrence of it is
	/// removed. Otherwise the element is appended to the end.
	///
	/// - Parameter element: The element to toggle.
	@inlinable
	public mutating func toggle( _ element: Element ) {
		if contains( element ) {
			remove( element )
		} else {
			append( element )
		}
	}
}

// MARK: - Set Element Operators

extension Set {

	/// Creates a set containing the given single element.
	///
	/// - Parameter element: The only element of the new set.
	///
	/// - Note: The overload is disfavored so that a `Sequence` of elements
	///   still resolves to `Set.init( _: )` taking a sequence.
	@_disfavoredOverload
	@inlinable
	public init( _ element: Element ) {
		self.init( [ element ] )
	}

	/// Returns a new set with the given element inserted.
	///
	/// - Parameters:
	///   - set: The source set.
	///   - element: The element to insert.
	/// - Returns: A copy of `set` containing `element`.
	@inlinable
	public static func + ( set: Self, element: Element ) -> Self {
		var mutable = set
		mutable.insert( element )
		return mutable
	}

	/// Returns a new set with the given element inserted, if it is not `nil`.
	///
	/// - Parameters:
	///   - set: The source set.
	///   - element: The element to insert, or `nil` to return `set` unchanged.
	/// - Returns: A copy of `set` containing `element`.
	@inlinable
	public static func + ( set: Self, element: Element? ) -> Self {

		guard let element else { return set }
		return set + element
	}

	/// Inserts the given element into the set.
	///
	/// - Parameters:
	///   - set: The set to insert into.
	///   - element: The element to insert.
	@inlinable
	public static func += ( set: inout Self, element: Element ) {
		set.insert( element )
	}

	/// Inserts the given element into the set, if it is not `nil`.
	///
	/// - Parameters:
	///   - set: The set to insert into.
	///   - element: The element to insert, or `nil` to leave `set` unchanged.
	@inlinable
	public static func += ( set: inout Self, element: Element? ) {

		guard let element else { return }
		set.insert( element )
	}
}
