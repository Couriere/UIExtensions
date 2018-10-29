//
//  UIControl+Extensions.swift
//  UIExtensions
//
//  Created by Vladimir on 29/10/2018.
//  Copyright © 2018 Vladimir Kazantsev. All rights reserved.
//

import UIKit

public extension UIControl {

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
	func addTarget( _ target: AnyObject?,
					for controlEvents: UIControl.Event,
					action handler: @escaping () -> Void ) {

		let wrapper = HandlerWrapper( handler )
		addTarget( wrapper, action: #selector( HandlerWrapper.invoke ), for: controlEvents )
		objc_setAssociatedObject( target ?? self,
								  "[\( Int.random( in: 1...Int.max ) )]",
								  wrapper,
								  .OBJC_ASSOCIATION_RETAIN )
	}

	/// Wrapper class used to store closure.
	private final class HandlerWrapper {
		private let handler: () -> Void
		init ( _ handler: @escaping () -> Void ) { self.handler = handler }
		@objc fileprivate func invoke () { handler() }
	}
}
