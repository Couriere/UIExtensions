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

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension NSLayoutConstraint {

	/// Activates and returns self.
	@discardableResult
	func activate() -> Self {
		self.isActive = true
		return self
	}

	/// Safely changes constraint priority.
	@discardableResult
	func setPriority( _ priority: XTLayoutPriority ) -> Self {
		guard self.priority != priority else { return self }

		if self.isActive,
		   ( self.priority == .required ) != ( priority == .required ) {
			isActive = false
			self.priority = priority
			isActive = true
		}
		else {
			self.priority = priority
		}

		return self
	}
}

public extension Sequence where Element == NSLayoutConstraint {

	@discardableResult
	func activate() -> Self {
		self.perform { $0.isActive = true }
	}

	@discardableResult
	func setPriority( _ priority: XTLayoutPriority ) -> Self {
		self.perform { $0.setPriority( priority ) }
	}
}


public extension Int {

	/// Returns XTLayoutPriority value with the receiver's priority.
	var layoutPriority: XTLayoutPriority {
		let clamped = Swift.min( XTLayoutPriority.required.rawValue, Swift.max( 0, Float( self )))
		return XTLayoutPriority( clamped )
	}
}

