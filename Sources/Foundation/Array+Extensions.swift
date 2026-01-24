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
