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

/// A type that has a notion of being empty.
///
/// Conform your own types to `Empty` to get a uniform way of asking
/// whether a value carries any meaningful content, and to gain the
/// emptiness checks this protocol provides for collections and
/// optionals of such types.
///
///     struct Address: Empty {
///         var street: String
///         var city: String
///
///         var isEmpty: Bool { street.isEmpty && city.isEmpty }
///     }
///
/// Collections already provide `isEmpty`, so they do not need to
/// conform. Use ``Swift/Collection/allEmpty`` to check the elements
/// of a collection instead of the collection itself.
public protocol Empty {

	/// A Boolean value indicating whether the value is considered empty.
	var isEmpty: Bool { get }
}

extension Empty {

	/// A Boolean value indicating whether the value is not empty.
	///
	/// Convenience property, returning the negation of ``isEmpty``.
	///
	/// - Note: The overload is disfavored so that types conforming to both
	///   `Empty` and `Collection` keep resolving to
	///   ``Swift/Collection/isNotEmpty``, which returns the same result.
	@_disfavoredOverload
	@inlinable
	public var isNotEmpty: Bool { !isEmpty }
}

extension Collection where Element: Empty {

	/// A Boolean value indicating whether every element of the collection is empty.
	///
	/// An empty collection returns `true`, because it contains no
	/// element that carries content.
	///
	///     let addresses = [ Address(), Address() ]
	///     print( addresses.isEmpty )  // false — the array has elements
	///     print( addresses.allEmpty ) // true  — but none of them has content
	@inlinable
	public var allEmpty: Bool { allSatisfy( \.isEmpty ) }
}

extension Collection where Element: Collection {

	/// A Boolean value indicating whether every nested collection is empty.
	///
	/// An empty collection returns `true`, because it contains no
	/// nested collection that carries elements.
	@_disfavoredOverload
	@inlinable
	public var allEmpty: Bool { allSatisfy( \.isEmpty ) }
}

extension Optional where Wrapped: Empty {

	/// A Boolean value indicating whether the value is `nil` or empty.
	@inlinable
	public var isEmpty: Bool { self?.isEmpty ?? true }

	/// A Boolean value indicating whether the value is not `nil` and not empty.
	@_disfavoredOverload
	@inlinable
	public var isNotEmpty: Bool { !isEmpty }
}

extension Optional where Wrapped: Collection {

	/// A Boolean value indicating whether the value is not `nil`
	/// and the wrapped collection is not empty.
	@inlinable
	public var isNotEmpty: Bool { self?.isNotEmpty ?? false }
}

extension Optional where Wrapped: Collection, Wrapped.Element: Empty {

	/// A Boolean value indicating whether the value is `nil`,
	/// or every element of the wrapped collection is empty.
	@inlinable
	public var allEmpty: Bool { self?.allEmpty ?? true }
}

extension Optional where Wrapped: Collection, Wrapped.Element: Collection {

	/// A Boolean value indicating whether the value is `nil`,
	/// or every nested collection of the wrapped collection is empty.
	@_disfavoredOverload
	@inlinable
	public var allEmpty: Bool { self?.allEmpty ?? true }
}
