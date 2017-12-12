//
//  GDC_Extensions.swift
//
//  Created by Vladimir Kazantsev on 20/10/15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

/**
Dispatch block to main threah synchronously. Preventing deadlock in case, when we are already on main thread.

- parameter block: Block to be dispatched.
*/
public func dispatch_main_thread_sync<T>( _ block: () -> T ) -> T {
	if Thread.isMainThread {
		return block()
	} else {
		return DispatchQueue.main.sync( execute: block )
	}
}

public extension DispatchQueue {

	func asyncAfter( timeInterval: TimeInterval, block: @escaping () -> Void ) {
		let delayTime = DispatchTime.now() + Double(Int64( timeInterval * TimeInterval( NSEC_PER_SEC ))) / Double(NSEC_PER_SEC)
		self.asyncAfter( deadline: delayTime, execute: block )
	}
}
