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
	
	@available(iOS 8.0, *)
	func dateByAddingMonths( months: Int ) -> NSDate {
		let calendar = NSCalendar.currentCalendar()
		return calendar.dateByAddingUnit( .Month, value: months, toDate: self, options: [] )!
	}
	
	static var thisYear: Int {
		let calendar = NSCalendar.currentCalendar()
		return calendar.components( [ .Year ], fromDate: NSDate() ).year
	}
	
	func startOfHour( hour: Int ) -> NSDate {

		let componentUnits: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second, .NSWeekdayCalendarUnit]
		let components = NSDate.gregorianRUCalendar.components( componentUnits, fromDate: self )
		
		components.hour = hour
		components.minute = 0
		components.second = 0
		
		return NSDate.gregorianRUCalendar.dateFromComponents( components )!
	}
	
	private	static let gregorianRUCalendar = NSCalendar( calendarIdentifier: NSCalendarIdentifierGregorian )!.then {
		$0.locale = NSLocale( localeIdentifier: "ru_RU" )
	}

}
