//
//  NSDate+Extensions.swift
//
//  Created by Vladimir Kazantsev on 24.03.15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

extension Calendar: Then {}

public extension Date {
	// ..<
	func isBetweenDate( _ firstDate: Date, andDate secondDate: Date ) -> Bool {
		let startResult = firstDate.compare( self )
		return ( startResult == .orderedSame || startResult == .orderedAscending ) && self.compare( secondDate ) == .orderedAscending
	}
	
	var timestamp: UInt64 { return UInt64( timeIntervalSince1970 * 1000 ) }
	
	init( timestamp: UInt64 ) {
		self.init( timeIntervalSince1970: TimeInterval( timestamp ) / 1000 )
	}
	
	func dateByAddingMonths( _ months: Int ) -> Date {
		let calendar = Calendar.current
		return calendar.date( byAdding: .month, value: months, to: self )!
	}
	
	static var thisYear: Int {
		let calendar = Calendar.current
		return calendar.dateComponents( [ .year ], from: Date() ).year!
	}
	
	/// Returns same date with time set to a start of specified hour.
	func startOfHour( _ hour: Int ) -> Date {

		let components: Set<Calendar.Component> = [ .year, .month, .day, .hour, .minute, .second, .weekday ]
		var dateComponents = Date.gregorianRUCalendar.dateComponents( components, from: self )
		
		dateComponents.hour = hour
		dateComponents.minute = 0
		dateComponents.second = 0
		
		return Date.gregorianRUCalendar.date( from: dateComponents )!
	}
	
	/// Returns start of the day, same date with time 00:00:00.
	/// - parameter timeZone: Use this time zone. If `nil` use system time zone.
	func startOfDay( _ timeZone: TimeZone? = nil ) -> Date {
		
		var calendar = Calendar( identifier: .gregorian )
		if let timeZone = timeZone { calendar.timeZone = timeZone }
		
		let components: Set<Calendar.Component> = [ .year, .month, .day, .hour, .minute, .second, .weekday ]
		var dateComponents = calendar.dateComponents( components, from: self )
		
		dateComponents.hour = 0
		dateComponents.minute = 0
		dateComponents.second = 0
		
		return calendar.date( from: dateComponents )!
	}
	
	static let gregorianRUCalendar = Calendar( identifier: .gregorian ).with {
		$0.locale = Locale( identifier: "ru_RU" )
	}

}
