//
//  NSDate+Extensions.swift
//
//  Created by Vladimir Kazantsev on 24.03.15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

extension NSDate {
	// ..<
	func isBetweenDate( firstDate: NSDate, andDate secondDate: NSDate ) -> Bool {
		let startResult = firstDate.compare( self )
		return ( startResult == .OrderedSame || startResult == .OrderedAscending ) && self.compare( secondDate ) == .OrderedAscending
	}
	
	var timestamp: UInt64 { return UInt64( timeIntervalSince1970 * 1000 ) }
	
	convenience init( timestamp: UInt64 ) {
		self.init( timeIntervalSince1970: NSTimeInterval( timestamp ) / 1000 )
	}
	
	func dateByAddingMonths( months: Int ) -> NSDate {
		let calendar = NSCalendar.currentCalendar()
		return calendar.dateByAddingUnit( .Month, value: months, toDate: self, options: [] )!
	}
}
