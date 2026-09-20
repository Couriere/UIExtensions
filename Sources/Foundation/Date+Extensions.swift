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

extension Calendar: Then {}

public enum Weekday: Int {
	case sunday = 1
	case monday = 2
	case tuesday = 3
	case wednesday = 4
	case thursday = 5
	case friday = 6
	case saturday = 7
}

public extension Date {

	var timestamp: Int64 { return Int64( timeIntervalSince1970 * 1000 ) }

	init( timestamp: Int64 ) {
		self.init( timeIntervalSince1970: TimeInterval( timestamp ) / 1000 )
	}

	static var thisYear: Int {
		let calendar = Calendar.current
		return calendar.component( .year, from: Date() )
	}

	/// Adds number of months to the date.
	func addingMonths( _ months: Int ) -> Date {
		let calendar = Calendar.current
		return calendar.date( byAdding: .month, value: months, to: self )!
	}

	/// Adds number of years to the date.
	func addingYears( _ years: Int ) -> Date {
		let calendar = Calendar.current
		return calendar.date( byAdding: .year, value: years, to: self )!
	}


	/// Returns same date with time set to a start of specified hour.
	func startOfHour( _ hour: Int, timeZone: TimeZone? = nil ) -> Date {

		var calendar = Calendar.current
		if let timeZone = timeZone { calendar.timeZone = timeZone }

		let components: Set<Calendar.Component> = [ .year, .month, .day, .hour, .minute, .second, .weekday ]
		var dateComponents = calendar.dateComponents( components, from: self )

		dateComponents.hour = min( 23, max( 0, hour ))
		dateComponents.minute = 0
		dateComponents.second = 0

		return calendar.date( from: dateComponents )!
	}

	/// Returns start of the day, same date with time 00:00:00.
	/// - parameter timeZone: Use this time zone. If `nil` use system time zone.
	func startOfDay( _ timeZone: TimeZone? = nil ) -> Date {

		var calendar = Calendar.current
		if let timeZone = timeZone { calendar.timeZone = timeZone }

		return calendar.startOfDay( for: self )
	}

	/// Returns first second of the month.
	/// - parameter timeZone: Use this time zone. If `nil` use system time zone.
	func startOfMonth( _ timeZone: TimeZone? = nil ) -> Date {

		var calendar = Calendar.current
		if let timeZone = timeZone { calendar.timeZone = timeZone }

		return calendar
			.dateInterval( of: .month, for: self )?
			.start ?? self
	}

	/// Returns last second of the month.
	/// - parameter timeZone: Use this time zone. If `nil` use system time zone.
	func endOfMonth( _ timeZone: TimeZone? = nil ) -> Date {

		var calendar = Calendar.current
		if let timeZone = timeZone { calendar.timeZone = timeZone }

		return calendar
			.dateInterval( of: .month, for: self )?
			.end
			.addingTimeInterval( -1 ) ?? self
	}

	/// Returns first second of the year.
	/// - parameter timeZone: Use this time zone. If `nil` use system time zone.
	func startOfYear( _ timeZone: TimeZone? = nil ) -> Date {

		var calendar = Calendar.current
		if let timeZone = timeZone { calendar.timeZone = timeZone }

		return calendar
			.dateInterval( of: .year, for: self )?
			.start ?? self
	}

	/// Returns last second of the year.
	/// - parameter timeZone: Use this time zone. If `nil` use system time zone.
	func endOfYear( _ timeZone: TimeZone? = nil ) -> Date {

		var calendar = Calendar.current
		if let timeZone = timeZone { calendar.timeZone = timeZone }

		return calendar
			.dateInterval( of: .year, for: self )?
			.end
			.addingTimeInterval( -1 ) ?? self
	}


	/// Returns weekday of the date.
	var weekday: Weekday {
		Weekday( rawValue: Calendar.current.component( .weekday, from: self ) ) ?? .sunday
	}

	/// Returns time interval since this date start of the day.
	var timeIntervalSinceStartOfTheDay: TimeInterval {
		return timeIntervalSince( Calendar.current.startOfDay( for: self ) )
	}

	/// Returns number of days in month of the date.
	var numberOfDaysInMonth: Int {
		return Calendar.current.range( of: .day, in: .month, for: self )?.count ?? 0
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

extension Date {

	/// The interval between this date and the current date and time.
	///
	/// The value is positive for a date in the past and negative for a
	/// date in the future, which is the opposite of `timeIntervalSinceNow`.
	@inlinable
	@inline(__always)
	public var timeIntervalUntilNow: TimeInterval {
		-timeIntervalSinceNow
	}

	/// Returns the day of the month of the date.
	///
	/// - Parameter calendar: The calendar used to interpret the date.
	///   Defaults to the user's current calendar.
	/// - Returns: The day component of the date, from 1 to 31.
	@inlinable
	public func dayOfMonth( _ calendar: Calendar = .current ) -> Int {
		calendar.component( .day, from: self )
	}

	/// Returns the last second of the day the date belongs to.
	///
	/// - Parameter timeZone: The time zone used to determine the day.
	///   Pass `nil` to use the system time zone.
	/// - Returns: The date with its time set to 23:59:59.
	public func endOfDay( _ timeZone: TimeZone? = nil ) -> Date {

		var calendar = Calendar.current
		if let timeZone { calendar.timeZone = timeZone }

		return calendar.startOfDay( for: self )
			.addingTimeInterval( 1.day - 1 )
	}
}

extension DateFormatter {

	/// Creates a formatter with the given date format.
	///
	/// - Parameter dateFormat: The format string, such as `"yyyy-MM-dd"`.
	///
	/// - Note: The initializer is exposed to Objective-C, so that a subclass
	///   of `DateFormatter` can declare its own `init( _: )`. A declaration
	///   in an extension can't be overridden otherwise.
	@objc
	public convenience init( _ dateFormat: String ) {
		self.init()
		self.dateFormat = dateFormat
	}
}

// MARK: - Date Ranges

extension ClosedRange where Bound == Date {

	/// Returns the range from the first day of the current month
	/// through the end of today.
	///
	/// - Parameter calendar: The calendar used to determine the month.
	///   Defaults to the user's current calendar.
	/// - Returns: The month-to-date range of the current month.
	public static func currentMonth( _ calendar: Calendar = .current ) -> Self {

		let now = Date()
		return now.startOfMonth( calendar.timeZone ) ... now.endOfDay( calendar.timeZone )
	}

	/// Returns a Boolean value indicating whether both bounds
	/// fall on the same day.
	///
	/// - Parameter calendar: The calendar used to compare the bounds.
	///   Defaults to the user's current calendar.
	/// - Returns: `true` if the range does not cross a day boundary,
	///   otherwise `false`.
	@inlinable
	public func isSingleDate( _ calendar: Calendar = .current ) -> Bool {
		calendar.isDate(
			lowerBound,
			equalTo: upperBound,
			toGranularity: .day,
		)
	}

	/// Returns a Boolean value indicating whether both bounds
	/// fall in the same month.
	///
	/// - Parameter calendar: The calendar used to compare the bounds.
	///   Defaults to the user's current calendar.
	/// - Returns: `true` if the range does not cross a month boundary,
	///   otherwise `false`.
	@inlinable
	public func isSameMonth( _ calendar: Calendar = .current ) -> Bool {
		calendar.isDate(
			lowerBound,
			equalTo: upperBound,
			toGranularity: .month,
		)
	}

	/// Returns a Boolean value indicating whether both bounds
	/// fall in the same year.
	///
	/// - Parameter calendar: The calendar used to compare the bounds.
	///   Defaults to the user's current calendar.
	/// - Returns: `true` if the range does not cross a year boundary,
	///   otherwise `false`.
	@inlinable
	public func isSameYear( _ calendar: Calendar = .current ) -> Bool {
		calendar.isDate(
			lowerBound,
			equalTo: upperBound,
			toGranularity: .year,
		)
	}

	/// Returns a Boolean value indicating whether the range covers
	/// a whole calendar month.
	///
	/// The range covers a whole month when it starts on the first day
	/// of a month and ends on the last day of the same month. The time
	/// of day of either bound is ignored, and the number of days in the
	/// month, including leap years, is taken into account.
	///
	/// - Parameter calendar: The calendar used to determine the month.
	///   Defaults to the user's current calendar.
	/// - Returns: `true` if the range covers a whole month, otherwise `false`.
	public func isWholeMonth( _ calendar: Calendar = .current ) -> Bool {

		let timeZone = calendar.timeZone
		let monthStart = lowerBound.startOfMonth( timeZone )
		let monthEnd = lowerBound.endOfMonth( timeZone )

		return calendar.isDate( lowerBound, inSameDayAs: monthStart )
			&& calendar.isDate( upperBound, inSameDayAs: monthEnd )
	}

	/// Returns a Boolean value indicating whether the range covers
	/// the current month up to today.
	///
	/// The range is month-to-date when it starts on the first day of the
	/// month the upper bound belongs to, and ends today. The time of day
	/// of either bound is ignored.
	///
	/// - Parameter calendar: The calendar used to determine the month.
	///   Defaults to the user's current calendar.
	/// - Returns: `true` if the range is month-to-date, otherwise `false`.
	public func isMonthToDate( _ calendar: Calendar = .current ) -> Bool {

		let monthStart = lowerBound.startOfMonth( calendar.timeZone )

		return calendar.isDate( lowerBound, inSameDayAs: monthStart )
			&& isSameMonth( calendar )
			&& upperBound.isToday
	}
}
