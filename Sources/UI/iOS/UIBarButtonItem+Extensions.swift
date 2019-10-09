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

public extension UIBarButtonItem {

	/// Associates a target object and action closure with the control.
	/// - parameter target: The object that holds reference to closure.
	/// When the target is destroyed, closure will be destroyed too. Ergo you
	/// may always safely use `[unowned self]` in closure for referencing `target`.
	/// If you specify nil, control will be used for target.
	/// - parameter controlEvents: A bitmask specifying the control-specific events
	/// for which the action method is called. Always specify at least one constant.
	/// For a list of possible constants, see UIControl.Event.
	/// - parameter handler: The closure that will be executed when action specified in
	/// `controlEvents` is triggered.
	convenience init( title: String?,
	                  style: UIBarButtonItem.Style = .plain,
	                  handler: @escaping () -> Void ) {

		self.init( title: title, style: style, target: nil, action: nil )

		let wrapper = HandlerWrapper( handler )
		target = wrapper
		action = #selector( HandlerWrapper.invoke )
		objc_setAssociatedObject( self,
		                          "[\( Int.random( in: 1 ... Int.max ) )]",
		                          wrapper,
		                          .OBJC_ASSOCIATION_RETAIN )
	}

	convenience init( image: UIImage,
	                  style: UIBarButtonItem.Style = .plain,
	                  handler: @escaping () -> Void ) {

		self.init( image: image, style: style, target: nil, action: nil )

		let wrapper = HandlerWrapper( handler )
		target = wrapper
		action = #selector( HandlerWrapper.invoke )
		objc_setAssociatedObject( self,
		                          "[\( Int.random( in: 1 ... Int.max ) )]",
		                          wrapper,
		                          .OBJC_ASSOCIATION_RETAIN )
	}

	/// Wrapper class used to store closure.
	private final class HandlerWrapper: NSObject {
		private let handler: () -> Void
		init( _ handler: @escaping () -> Void ) { self.handler = handler }
		@objc fileprivate func invoke() { handler() }
	}
}

