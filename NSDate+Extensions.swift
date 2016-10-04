//
//  NSDate+Extensions.swift
//
//  Created by Vladimir Kazantsev on 24.03.15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

extension Date {
	// ..<
	func isBetweenDate( _ firstDate: Date, andDate secondDate: Date ) -> Bool {
		let startResult = firstDate.compare( self )
		return ( startResult == .orderedSame || startResult == .orderedAscending ) && self.compare( secondDate ) == .orderedAscending
	}
	
	var timestamp: UInt64 { return UInt64( timeIntervalSince1970 * 1000 ) }
	
	init( timestamp: UInt64 ) {
		self.init( timeIntervalSince1970: TimeInterval( timestamp ) / 1000 )
	}
	
	@available(iOS 8.0, *)
	func dateByAddingMonths( _ months: Int ) -> Date {
		let calendar = Calendar.current
		return (calendar as NSCalendar).date( byAdding: .month, value: months, to: self, options: [] )!
	}
	
	static var thisYear: Int {
		let calendar = Calendar.current
		return (calendar as NSCalendar).components( [ .year ], from: Date() ).year!
	}
	
	/// Returns same date with time set to a start of specified hour.
	public func startOfHour( _ hour: Int ) -> Date {

		let componentUnits: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second, .NSWeekdayCalendarUnit]
		var components = (Date.gregorianRUCalendar as NSCalendar).components( componentUnits, from: self )
		
		components.hour = hour
		components.minute = 0
		components.second = 0
		
		return Date.gregorianRUCalendar.date( from: components )!
	}
	
	/// Returns start of the day, same date with time 00:00:00.
	/// - parameter timeZone: Use this time zone. If `nil` use system time zone.
	public func startOfDay( _ timeZone: TimeZone? = nil ) -> Date {
		var calendar = Calendar( identifier: Calendar.Identifier.gregorian )
		if let timeZone = timeZone { calendar.timeZone = timeZone }
		
		let componentUnits: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second, .NSWeekdayCalendarUnit]
		var components = (calendar as NSCalendar).components( componentUnits, from: self )
		
		components.hour = 0
		components.minute = 0
		components.second = 0
		
		return calendar.date( from: components )!
	}
	
	fileprivate	static let gregorianRUCalendar: Calendar = {
		var calendar = Calendar( identifier: Calendar.Identifier.gregorian )
		calendar.locale = Locale( identifier: "ru_RU" )
		return calendar
	}()

}
