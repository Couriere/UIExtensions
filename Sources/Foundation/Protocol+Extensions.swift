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

import CoreGraphics

#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

public protocol Then {}

public extension Then where Self: Any {

	/// Makes it available to set properties with closures just after initializing.
	///
	///     let frame = CGRect().with {
	///       $0.origin.x = 10
	///       $0.size.width = 100
	///     }
	@discardableResult func with(_ block: (inout Self) -> Void) -> Self {
		var copy = self
		block(&copy)
		return copy
	}
}

public extension Then where Self: AnyObject {

	/// Makes it available to set properties with closures just after initializing.
	///
	///     let label = UILabel().then {
	///       $0.textAlignment = .Center
	///       $0.textColor = UIColor.blackColor()
	///       $0.text = "Hello, World!"
	///     }
	@discardableResult func then( _ block: (Self) -> Void ) -> Self {
		block(self)
		return self
	}

	/// Makes it available to execute something with closures.
	///
	///     UserDefaults.standard.do {
	///       $0.set("devxoul", forKey: "username")
	///       $0.set("devxoul@gmail.com", forKey: "email")
	///       $0.synchronize()
	///     }
	func `do`(_ block: (Self) -> Void) {
		block(self)
	}
}

public extension Then where Self: XTView {

	/// Makes it available to set properties with closures just after initializing.
	/// By defaut turns off `translatesAutoresizingMaskIntoConstraints` property.
	///
	///     let label = UILabel().then {
	///       $0.textAlignment = .Center
	///       $0.textColor = UIColor.blackColor()
	///       $0.text = "Hello, World!"
	///     }
	@MainActor
	@discardableResult
	func then(
		useAutolayout: Bool = true,
		_ block: (Self) -> Void
	) -> Self {
		translatesAutoresizingMaskIntoConstraints = !useAutolayout
		block(self)
		return self
	}
}

extension NSObject: Then {}

extension JSONDecoder: Then {}
extension JSONEncoder: Then {}
extension PropertyListDecoder: Then {}
extension PropertyListEncoder: Then {}

extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}


/// Syntax sugar for boolean variables.
/// Following methods execute blocks when Bool value is either `true` or `false`
/// and can be chained.
///
/// 		let bool = false
/// 		bool
/// 			.then { print( "This will not be executed" ) }
/// 			.else { print( "This line will be printed" ) }
///
public extension Bool {

	/// Executes given block when self is equal to `true`.
	/// Can be chained.
	@discardableResult
	func then( completion: () -> Void ) -> Bool {
		if self { completion() }
		return self
	}

	/// Executes given block when self is equal to `false`.
	/// Can be chained.
	@discardableResult
	func `else`( completion: () -> Void ) -> Bool {
		if !self { completion() }
		return self
	}
}


public extension Sequence {

	/// Calls the given closure on each element in the sequence in the same order as a for-in loop.
	/// - parameter body: A closure that takes an element of the sequence as a parameter.
	/// - returns: Self.
	func perform( _ body: ( Element ) throws -> Void ) rethrows -> Self {
		try forEach( body )
		return self
	}
}


public extension Equatable {

	/// Returns `true` is self is contained in `collection`.
	func isIn( _ collection: [ Self ] ) -> Bool {
		return collection.contains( self )
	}

	/// Returns `true` is self is contained in variadic collection.
	func isIn( _ sequence: Self... ) -> Bool {
		return sequence.contains( self )
	}
}
