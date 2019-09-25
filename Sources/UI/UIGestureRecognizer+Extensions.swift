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

import UIKit

extension UIGestureRecognizer {

	/// Initializes an allocated gesture-recognizer object with a target and an handler closure.
	/// - parameter target: The object that holds reference to closure.
	/// When the target is destroyed, closure will be destroyed too. Ergo you
	/// may always safely use `[unowned self]` in closure for referencing `target`.
	/// If you specify nil, control will be used for target.
	/// - parameter handler: The closure that will be executed when
	/// gesture recognizer action is triggered.
	convenience init<T: UIGestureRecognizer>( target: Any?, handler: @escaping ( T ) -> Void ) {
		let wrapper = HandlerWrapper<T>( handler )
		self.init( target: wrapper, action: #selector( HandlerWrapper.invoke ))
		wrapper.recognizer = self as? T
		objc_setAssociatedObject( target ?? self,
		                          &UIGestureRecognizer.AssociatedObjectHandle,
		                          wrapper,
		                          .OBJC_ASSOCIATION_RETAIN )
	}

	/// Wrapper class used to store closure.
	private final class HandlerWrapper<T: UIGestureRecognizer> {
		let handler: ( T ) -> Void
		weak var recognizer: T?
		init( _ handler: @escaping ( T ) -> Void ) { self.handler = handler }
		@objc func invoke() { recognizer.then { handler( $0 ) } }
	}

	private static var AssociatedObjectHandle: UInt8 = 0
}
