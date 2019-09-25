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
