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

public extension Sequence where Element: OptionalType {

	/// Returns an array of unwrapped values for each non-nil element in the
	/// collection. Equivalent to `compactMap { $0 }`.
	/// - Returns: An array of unwrapped values from each non-nil element.
	@inlinable
	func compactMap() -> [Element.Wrapped] {
		compactMap { $0.value }
	}
}

public extension Sequence {

	/// Returns first element in the collection
	/// where the specified key path evaluates to `true`.
	///
	/// - parameter keypath: A key path that specifies the property
	/// to check for each element in the collection.
	/// - returns: First element where the specified keypath
	/// evaluates to `true`, or `nil` if no such elements found.
	///
	@inlinable
	func first( _ keypath: KeyPath<Element, Bool> ) -> Element? {
		self.first { $0[keyPath: keypath] }
	}

	/// Returns the first element in the collection where the value at the
	/// specified `keypath` equals the given `value`.
	///
	/// - Parameters:
	///   - keypath: A `KeyPath` to compare.
	///   - value: The value to match against.
	/// - Returns: The first element where `keypath` equals `value`, or `nil`
	/// if none is found.
	@inlinable
	func first<T>(
		_ keypath: KeyPath<Element, T>,
		equal value: T
	) -> Element? where T: Equatable{
		first { $0[keyPath: keypath] == value }
	}

	/// Returns an array of elements where the value at the specified `keypath`
	/// matches the given `value`.
	/// - Parameters:
	///   - keypath: A `KeyPath` to compare.
	///   - value: The value to match against.
	/// - Returns: An array of elements where the `keypath` equals `value`.
	@inlinable
	func filter<T>(
		_ keypath: KeyPath<Element, T>,
		equal value: T
	) -> [ Element ] where T: Equatable{
		filter { $0[keyPath: keypath] == value }
	}

	/// Returns an array of non-nil values from the specified
	/// optional `keypath`.
	/// Equivalent to `compactMap { $0.keypath }`.
	///
	/// - Parameter keypath: A `KeyPath` that evaluates to an optional value.
	/// - Returns: An array of non-nil values from `keypath`.
	@inlinable
	func compactMap<T>(
		_ keypath: KeyPath<Element, T?>
	) -> [ T ] {
		compactMap { $0[ keyPath: keypath ] }
	}

	/// Checks if any element in the collection has a value at the specified
	/// `keypath` equal to the given `value`.
	///
	/// - Parameters:
	///   - keypath: A `KeyPath` to compare.
	///   - value: The value to match against.
	/// - Returns: `true` if any element's `keypath` equals `value`, else `false`.
	@inlinable
	func contains<T>(
		_ keypath: KeyPath<Element, T>,
		equal value: T
	) -> Bool where T: Equatable {
		contains { $0[ keyPath: keypath ] == value }
	}

	/// Checks if any element in the collection satisfies the specified
	/// `keypath` condition.
	///
	/// - Parameter keypath: A `KeyPath` that evaluates to a `Bool`.
	/// - Returns: `true` if any element's `keypath` is `true`, else `false`.
	@inlinable
	func contains(
		_ keypath: KeyPath<Element, Bool>
	) -> Bool {
		contains { $0[ keyPath: keypath ] }
	}
}

public extension Sequence {
	/// Returns an array containing the elements of the sequence
	/// where the specified key path evaluates to `true`.
	///
	/// - parameter isIncluded: A key path that specifies the property
	/// to check for each element in the sequence.
	/// - returns: An array of the elements where
	/// the specified key path evaluates to `true`.
	///
	/// This method uses the `KeyPath` feature of Swift to simplify
	/// filtering elements based on a specific property.
	///
	@inlinable
	func filter(_ isIncluded: KeyPath<Element, Bool>) -> [Element] {
		filter { $0[keyPath: isIncluded] }
	}
}

public extension Collection {
	///
	/// Returns the index of the first element in the collection
	/// where the specified key path evaluates to `true`.
	///
	/// - parameter keypath: A key path that specifies the property
	/// to check for each element in the collection.
	/// - returns: The index of the first element where the specified keypath
	/// evaluates to `true`, or `nil` if no such elements found.
	///
	@inlinable
	func firstIndex(_ keypath: KeyPath<Element, Bool>) -> Index? {
		self.firstIndex { $0[keyPath: keypath] }
	}
}

public extension KeyPath where Value == Bool {
	var negate: KeyPath<Root, Bool> {
		appending( path: \.negate )
	}
}
