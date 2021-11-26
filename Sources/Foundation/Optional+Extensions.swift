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

public extension Optional {

	/// Executes given block with unwrapped value of optional as parameter when said optional is not `nil`.
	///
	/// 		let nonNilOptional: Int? = 1
	/// 		nonNilOptional.then { print( $0 ) }  => Prints `1`
	/// 		let nilOptional: Int? = nil
	/// 		nilOptional.then { print( $0 ) }  => Nothing happens
	///
	@discardableResult
	func then<T>( _ block: ( Wrapped ) throws -> T ) rethrows -> T? {
		switch self {
		case .none: return nil
		case let .some( value ): return try block( value )
		}
	}
}


/// Syntax sugar for optional boolean variables.
/// Following methods execute blocks when Bool? value is either `true`, `false` or `nil`.
/// Calls can be chained.
///
/// 		let bool: Bool? = true
/// 		bool
/// 			.else { print( "This will not be executed" ) }
/// 			.then { print( "This line will be printed" ) }
///
/// 		let nilBool: Bool? = nil
/// 		nilBool
/// 			.then { print( "This will not be executed" ) }
/// 			.else { print( "This line will be printed" ) }
///
public extension Optional where Wrapped == Bool {

	/// Executes given block when self is equal to `true`.
	/// Can be chained.
	@discardableResult
	func then( completion: () -> Void ) -> Bool? {
		if case let .some( value ) = self { value.then( completion: completion ) }
		return self
	}

	/// Executes given block when self is equal to `false` or `nil`.
	/// Can be chained.
	@discardableResult
	func `else`( completion: () -> Void ) -> Bool? {
		if case .some = self { return self }
		completion()
		return self
	}
}

public extension Optional where Wrapped: Collection {
	var isEmpty: Bool {
		switch self {
		case .none: return true
		case .some( let collection ): return collection.isEmpty
		}
	}
}

// https://github.com/artsy/eidolon/blob/24e36a69bbafb4ef6dbe4d98b575ceb4e1d8345f/Kiosk/Observable%2BOperators.swift#L30-L40
// By @ashfurrow
public protocol OptionalType {
	associatedtype Wrapped
	var value: Wrapped? { get }
}

extension Optional: OptionalType {
	public var value: Wrapped? { return self }
}
