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
	
	/// Returns same date with time set to a start of specified hour.
	public func startOfHour( hour: Int ) -> NSDate {

		let componentUnits: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second, .NSWeekdayCalendarUnit]
		let components = NSDate.gregorianRUCalendar.components( componentUnits, fromDate: self )
		
		components.hour = hour
		components.minute = 0
		components.second = 0
		
		return NSDate.gregorianRUCalendar.dateFromComponents( components )!
	}
	
	/// Returns start of the day, same date with time 00:00:00.
	/// - parameter timeZone: Use this time zone. If `nil` use system time zone.
	public func startOfDay( timeZone: NSTimeZone? = nil ) -> NSDate {
		let calendar = NSCalendar( calendarIdentifier: NSCalendarIdentifierGregorian )!
		if let timeZone = timeZone { calendar.timeZone = timeZone }
		
		let componentUnits: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second, .NSWeekdayCalendarUnit]
		let components = calendar.components( componentUnits, fromDate: self )
		
		components.hour = 0
		components.minute = 0
		components.second = 0
		
		return calendar.dateFromComponents( components )!
	}
	
	private	static let gregorianRUCalendar: NSCalendar = {
		let calendar = NSCalendar( calendarIdentifier: NSCalendarIdentifierGregorian )!
		calendar.locale = NSLocale( localeIdentifier: "ru_RU" )
		return calendar
	}()

}
