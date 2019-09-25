//
//  UIBarButtonItem+Extensions.swift
//  UIExtensions iOS
//
//  Created by Vladimir on 31/03/2019.
//  Copyright © 2019 Vladimir Kazantsev. All rights reserved.
//

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

