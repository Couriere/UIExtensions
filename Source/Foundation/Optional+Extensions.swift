//
//  Optional+Extensions.swift
//  UIExtensions
//
//  Created by Vladimir on 07.09.2018.
//  Copyright © 2018 Vladimir Kazantsev. All rights reserved.
//

import Foundation

public extension Optional {

	/// Executes given block with unwrapped value of optional as parameter when said optional is not `nil`.
	///
	///		let nonNilOptional: Int? = 1
	///		nonNilOptional.then { print( $0 ) }  => Prints `1`
	///		let nilOptional: Int? = nil
	///		nilOptional.then { print( $0 ) }  => Nothing happens
	///
	@discardableResult
	func then<T>( _ block: ( Wrapped ) throws -> T ) rethrows -> T? {
		switch self {
		case .none: return nil
		case .some( let value ): return try block( value )
		}
	}
}


/// Syntax sugar for optional boolean variables.
/// Following methods execute blocks when Bool? value is either `true`, `false` or `nil`.
/// Calls can be chained.
///
///		let bool: Bool? = true
///		bool
///			.else { print( "This will not be executed" ) }
///			.then { print( "This line will be printed" ) }
///
///		let nilBool: Bool? = nil
///		nilBool
///			.then { print( "This will not be executed" ) }
///			.else { print( "This line will be printed" ) }
///
public extension Optional where Wrapped == Bool {

	/// Executes given block when self is equal to `true`.
	/// Can be chained.
	@discardableResult
	func then( completion: () -> Void ) -> Bool? {
		if case .some( let value ) = self { value.then( completion: completion ) }
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

// https://github.com/artsy/eidolon/blob/24e36a69bbafb4ef6dbe4d98b575ceb4e1d8345f/Kiosk/Observable%2BOperators.swift#L30-L40
// By @ashfurrow
public protocol OptionalType {
	associatedtype Wrapped
	var value: Wrapped? { get }
}

extension Optional: OptionalType {
	public var value: Wrapped? { return self }
}
