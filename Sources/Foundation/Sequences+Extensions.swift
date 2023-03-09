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
