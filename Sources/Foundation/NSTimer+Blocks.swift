//
//  NSTimer+Blocks.swift
//
//  Created by Vladimir Kazantsev on 08.04.15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit


/// Source:
/// https://gist.github.com/natecook1000/b0285b518576b22c4dc8
///
public extension Timer {
	/**
	 Creates and schedules a one-time `NSTimer` instance.

	 - parameter delay: The delay before execution.
	 - parameter handler: A closure to execute after `delay`.

	 - returns: The newly-created `NSTimer` instance.
	 */
	class func schedule(delay: TimeInterval, handler: @escaping ( Timer? ) -> Void ) -> Timer {
		let fireDate = delay + CFAbsoluteTimeGetCurrent()
		let timer = CFRunLoopTimerCreateWithHandler( kCFAllocatorDefault, fireDate, 0, 0, 0, handler )
		CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
		return timer!
	}


	/**
	 Creates and schedules a one-time `NSTimer` instance.

	 - parameter time: The date and time to begin execution.
	 - parameter handler: A closure to execute after `delay`.

	 - returns: The newly-created `NSTimer` instance.
	 */
	class func schedule( time: Date, handler: @escaping ( Timer? ) -> Void ) -> Timer {
		return schedule( delay: time.timeIntervalSinceNow, handler: handler )
	}


	/**
	 Creates and schedules a repeating `NSTimer` instance.

	 - parameter repeatInterval: The interval between each execution of `handler`. Note that individual calls may be delayed; subsequent calls to `handler` will be based on the time the `NSTimer` was created.
	 - parameter handler: A closure to execute after `delay`.

	 - returns: The newly-created `NSTimer` instance.
	 */
	class func schedule(repeatInterval interval: TimeInterval, handler: @escaping ( Timer? ) -> Void ) -> Timer {
		let fireDate = interval + CFAbsoluteTimeGetCurrent()
		let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler )
		CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
		return timer!
	}
}
