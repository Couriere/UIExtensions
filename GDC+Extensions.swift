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
func dispatch_main_thread_sync( block: dispatch_block_t )
{
	if NSThread.isMainThread() { block() } else { dispatch_sync( dispatch_get_main_queue(), block ) }
}

func dispatch_after( timeInterval timeInterval: NSTimeInterval, queue: dispatch_queue_t? = nil, block: dispatch_block_t! ) {
	let delayTime = dispatch_time( DISPATCH_TIME_NOW, Int64( timeInterval * NSTimeInterval( NSEC_PER_SEC )))
	dispatch_after( delayTime, queue ?? dispatch_get_main_queue(), block )
}
