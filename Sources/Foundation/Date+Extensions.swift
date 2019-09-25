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

extension Calendar: Then {}

public extension Date {
	// ..<
	func isBetweenDate( _ firstDate: Date, andDate secondDate: Date ) -> Bool {
		let startResult = firstDate.compare( self )
		return ( startResult == .orderedSame || startResult == .orderedAscending ) && compare( secondDate ) == .orderedAscending
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

	/// Returns time interval since this date start of the day.
	var timeIntervalSinceStartOfTheDay: TimeInterval {
		return timeIntervalSince( Calendar.current.startOfDay( for: self ) )
	}


	static let gregorianRUCalendar = Calendar( identifier: .gregorian ).with {
		$0.locale = Locale( identifier: "ru_RU" )
	}
}

public extension Date {

	/// Returns `true` if the date is within today, as defined by the calendar and calendar's locale.
	///
	/// - returns: `true` if the date is within today.
	var isToday: Bool {
		return Calendar.current.isDateInToday( self )
	}

	/// Returns `true` if the date is within tomorrow, as defined by the calendar and calendar's locale.
	///
	/// - returns: `true` if the date is within tomorrow.
	var isTomorrow: Bool {
		return Calendar.current.isDateInTomorrow( self )
	}

	/// Returns `true` if the date is within yesterday, as defined by the calendar and calendar's locale.
	///
	/// - returns: `true` if the date is within yesterday.
	var isYesterday: Bool {
		return Calendar.current.isDateInYesterday( self )
	}

	/// Returns `true` if the date is within a weekend period, as defined by the calendar and calendar's locale.
	///
	/// - returns: `true` if the date is within a weekend.
	var isDateInWeekend: Bool {
		return Calendar.current.isDateInWeekend( self )
	}


	/// Compares the given date and self down to the given component,
	/// reporting them equal if they are the same in the given component and all larger components.
	///
	/// - parameter date: A date to compare.
	/// - parameter component: A granularity to compare. For example, pass `.hour` to check if two dates are in the same hour.
	/// - returns: `true` if `date1` and `date2` are in the same day.
	func isEqualToDate( _ date: Date, toGranularity component: Calendar.Component ) -> Bool {
		return Calendar.current.isDate( self, equalTo: date, toGranularity: component )
	}
}


/// Convenience time properties.
/// Usage: Date() + 2.days + 1.hour
public extension Int {

	var second: TimeInterval { return TimeInterval( self ) }
	var seconds: TimeInterval { return TimeInterval( self ) }

	var minute: TimeInterval { return TimeInterval( self * 60 ) }
	var minutes: TimeInterval { return TimeInterval( self * 60 ) }

	var hour: TimeInterval { return TimeInterval( self * 60 * 60 ) }
	var hours: TimeInterval { return TimeInterval( self * 60 * 60 ) }

	var day: TimeInterval { return TimeInterval( self * 24 * 60 * 60 ) }
	var days: TimeInterval { return TimeInterval( self * 24 * 60 * 60 ) }
}

public extension TimeInterval {

	var second: TimeInterval { return self }
	var seconds: TimeInterval { return self }

	var minute: TimeInterval { return self * 60 }
	var minutes: TimeInterval { return self * 60 }

	var hour: TimeInterval { return self * 60 * 60 }
	var hours: TimeInterval { return self * 60 * 60 }

	var day: TimeInterval { return self * 24 * 60 * 60 }
	var days: TimeInterval { return self * 24 * 60 * 60 }
}
