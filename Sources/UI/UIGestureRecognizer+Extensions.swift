//
//  UIGestureRecognizer+Extensions.swift
//  UIExtensions
//
//  Created by Vladimir on 09/11/2018.
//  Copyright © 2018. All rights reserved.
//

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
		init ( _ handler: @escaping ( T ) -> Void ) { self.handler = handler }
		@objc func invoke() { recognizer.then { handler( $0 ) }}
	}

	static private var AssociatedObjectHandle: UInt8 = 0
}
