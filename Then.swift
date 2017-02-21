
// The MIT License (MIT)
//
// Copyright (c) 2015 Suyeol Jeon (xoul.kr)
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

import UIKit
import CoreGraphics

public protocol Then {}

extension Then where Self: Any {
	
	/// Makes it available to set properties with closures just after initializing.
	///
	///     let frame = CGRect().with {
	///       $0.origin.x = 10
	///       $0.size.width = 100
	///     }
	@discardableResult public func with(_ block: (inout Self) -> Void) -> Self {
		var copy = self
		block(&copy)
		return copy
	}
	
}

extension Then where Self: AnyObject {
	
	/// Makes it available to set properties with closures just after initializing.
	///
	///     let label = UILabel().then {
	///       $0.textAlignment = .Center
	///       $0.textColor = UIColor.blackColor()
	///       $0.text = "Hello, World!"
	///     }
	@discardableResult public func then( _ block: (Self) -> Void ) -> Self {
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
	public func `do`(_ block: (Self) -> Void) {
		block(self)
	}
	
}

extension Then where Self: UIView {
	
	/// Makes it available to set properties with closures just after initializing.
	/// By defaut turns off `translatesAutoresizingMaskIntoConstraints` property.
	///
	///     let label = UILabel().then {
	///       $0.textAlignment = .Center
	///       $0.textColor = UIColor.blackColor()
	///       $0.text = "Hello, World!"
	///     }
	@discardableResult public func then( useAutolayout: Bool = true, _ block: (Self) -> Void ) -> Self {
		self.translatesAutoresizingMaskIntoConstraints = !useAutolayout
		block(self)
		return self
	}
}

extension NSObject: Then {}

extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}


extension Optional {

	/// Executes given block with unwrapped value of optional as parameter when said optional is not `nil`.
	///
	///		let nonNilOptional: Int? = 1
	///		nonNilOptional.then { print( $0 ) }  => Prints `1`
	///		let nilOptional: Int? = 1
	///		nilOptional.then { print( $0 ) }  => Nothing happens
	///
	func then( _ block: ( Wrapped ) -> Void ) {
		switch self {
		case .none: return
		case .some( let value ): block( value )
		}
	}
}
