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

import Foundation

/**
 Dispatch block to main threah synchronously. Preventing deadlock in case, when we are already on main thread.

 - parameter block: Block to be dispatched.
 */
public func dispatch_main_thread_sync<T>( _ block: () -> T ) -> T {
	if Thread.isMainThread {
		return block()
	}
	else {
		return DispatchQueue.main.sync( execute: block )
	}
}

public extension DispatchQueue {

	///
	/// Submits a work item to a dispatch queue for asynchronous execution after
	/// a specified time.
	///
	/// This method enforces the work item to be sendable.
	///
	/// - parameter: timeInterval the time after which the work item
	/// should be executed, in seconds.
	/// - parameter qos: the QoS at which the work item should be executed.
	///	Defaults to `DispatchQoS.unspecified`.
	/// - parameter flags: flags that control the execution environment of the
	/// work item.
	/// - parameter block: The work item to be invoked on the queue.
	func asyncAfter(
		timeInterval: TimeInterval,
		qos: DispatchQoS = .unspecified,
		flags: DispatchWorkItemFlags = [],
		block: @escaping @Sendable () -> Void
	) {
		let delayTime = DispatchTime.now() + Double(Int64( timeInterval * TimeInterval( NSEC_PER_SEC ))) / Double(NSEC_PER_SEC)
		asyncAfter( deadline: delayTime, execute: block )
	}
}
