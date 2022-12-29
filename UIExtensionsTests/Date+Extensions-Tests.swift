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

import XCTest

class DateExtensionsTests: XCTestCase {

	let formatter = DateFormatter().then {
		$0.dateFormat = "yyyy-MM-dd HH:mm:ss"
		$0.calendar = Calendar.current
	}

	func testTimestamp() {
		let date = Date()
		let timeIntervalSince1970 = date.timeIntervalSince1970

		let timestamp: Int64 = date.timestamp
		XCTAssertEqual( Int64( timeIntervalSince1970 * 1000 ), timestamp )
		let dateFromTimestamp = Date( timestamp: timestamp )

		XCTAssert( Calendar.current.isDate( date, equalTo: dateFromTimestamp, toGranularity: .nanosecond ) )
	}

	func testAddingMonths() {
		let date1 = formatter.date( from: "2019-10-01 10:00:00" )!
		let date2 = formatter.date( from: "2019-11-01 10:00:00" )!
		let date3 = formatter.date( from: "2020-01-01 10:00:00" )!
		let date4 = formatter.date( from: "2019-01-01 10:00:00" )!

		XCTAssert( date1.addingMonths( 1 ) == date2 )
		XCTAssert( date1.addingMonths( 3 ) == date3 )
		XCTAssert( date1.addingMonths( -9 ) == date4 )

		let date5 = formatter.date( from: "2019-08-31 10:00:00" )!
		let date6 = formatter.date( from: "2019-09-30 10:00:00" )!

		XCTAssert( date5.addingMonths( 1 ) == date6 )
	}

	func testAddingYears() {
		let date1 = formatter.date( from: "2019-10-01 10:00:00" )!
		let date2 = formatter.date( from: "2020-10-01 10:00:00" )!
		let date3 = formatter.date( from: "2120-10-01 10:00:00" )!
		let date4 = formatter.date( from: "2000-10-01 10:00:00" )!

		XCTAssert( date1.addingYears( 1 ) == date2 )
		XCTAssert( date1.addingYears( 101 ) == date3 )
		XCTAssert( date1.addingYears( -19 ) == date4 )

		let date5 = formatter.date( from: "2016-02-29 10:00:00" )!
		let date6 = formatter.date( from: "2019-02-28 10:00:00" )!

		XCTAssert( date5.addingYears( 3 ) == date6 )
	}

	func testStartOfHour() {
		let date1 = formatter.date( from: "2019-10-01 10:30:00" )!
		let date2 = formatter.date( from: "2019-10-01 10:00:00" )!
		let date3 = formatter.date( from: "2019-10-01 00:00:00" )!
		let date4 = formatter.date( from: "2019-10-01 23:00:00" )!

		XCTAssert( date1.startOfHour( 10 ) == date2 )
		XCTAssert( date1.startOfHour( 0 ) == date3 )
		XCTAssert( date1.startOfHour( 23 ) == date4 )

		let date5 = formatter.date( from: "2019-10-01 23:59:59" )!
		XCTAssert( date5.startOfHour( 23 ) == date4 )
	}

	func testStartOfDay() {
		let date1 = formatter.date( from: "2019-10-01 10:30:00" )!
		let date2 = formatter.date( from: "2019-10-01 00:00:00" )!
		let date3 = formatter.date( from: "2019-10-01 23:59:59" )!

		XCTAssert( date1.startOfDay() == date2 )
		XCTAssert( date2.startOfDay() == date2 )
		XCTAssert( date3.startOfDay() == date2 )
	}

	func testStartOfMonth() {
		let date1 = formatter.date( from: "2019-10-03 10:30:00" )!
		let date2 = formatter.date( from: "2019-10-01 00:00:00" )!
		let date3 = formatter.date( from: "2019-10-31 23:59:59" )!

		XCTAssert( date1.startOfMonth() == date2 )
		XCTAssert( date2.startOfMonth() == date2 )
		XCTAssert( date3.startOfMonth() == date2 )
	}

	func testEndOfMonth() {
		let date1 = formatter.date( from: "2019-10-03 10:30:00" )!
		let date2 = formatter.date( from: "2019-10-01 00:00:00" )!
		let date3 = formatter.date( from: "2019-10-31 23:59:59" )!

		XCTAssert( date1.endOfMonth() == date3 )
		XCTAssert( date2.endOfMonth() == date3 )
		XCTAssert( date3.endOfMonth() == date3 )
	}

	func testStartOfYear() {
		let date1 = formatter.date( from: "2019-01-01 00:00:00" )!
		let date2 = formatter.date( from: "2019-10-03 10:30:00" )!
		let date3 = formatter.date( from: "2019-12-31 23:59:59" )!

		XCTAssert( date1.startOfYear() == date1 )
		XCTAssert( date2.startOfYear() == date1 )
		XCTAssert( date3.startOfYear() == date1 )
	}

	func testEndOfYear() {
		let date1 = formatter.date( from: "2019-01-01 00:00:00" )!
		let date2 = formatter.date( from: "2019-10-03 10:30:00" )!
		let date3 = formatter.date( from: "2019-12-31 23:59:59" )!

		XCTAssert( date1.endOfYear() == date3 )
		XCTAssert( date2.endOfYear() == date3 )
		XCTAssert( date3.endOfYear() == date3 )
	}

	func testWeekday() {
		let date1 = formatter.date( from: "2019-01-01 00:00:00" )!
		let date2 = formatter.date( from: "2019-12-29 23:59:59" )!
		let date3 = formatter.date( from: "2016-02-29 11:59:59" )!

		XCTAssert( date1.weekday == .tuesday )
		XCTAssert( date2.weekday == .sunday )
		XCTAssert( date3.weekday == .monday )
	}

	func testTimeIntervalSinceStartOfTheDay() {
		let date1 = formatter.date( from: "2019-01-01 00:00:00" )!
		let date2 = formatter.date( from: "2019-12-29 23:59:59" )!
		let date3 = formatter.date( from: "2016-02-29 12:00:59" )!

		XCTAssert( date1.timeIntervalSinceStartOfTheDay == 0 )
		XCTAssert( date2.timeIntervalSinceStartOfTheDay == 86399 )
		XCTAssert( date3.timeIntervalSinceStartOfTheDay == 43259 )
	}

	func testNumberOfDaysInMonth() {
		let date1 = formatter.date( from: "2019-01-01 00:00:00" )!
		let date2 = formatter.date( from: "2019-09-19 00:00:00" )!
		let date3 = formatter.date( from: "2019-02-10 23:59:59" )!
		let date4 = formatter.date( from: "2016-02-29 12:00:59" )!

		XCTAssert( date1.numberOfDaysInMonth == 31 )
		XCTAssert( date2.numberOfDaysInMonth == 30 )
		XCTAssert( date3.numberOfDaysInMonth == 28 )
		XCTAssert( date4.numberOfDaysInMonth == 29 )
	}

	func testCompare() {
		XCTAssertTrue( Date().isToday )
		XCTAssertTrue( Date().addingTimeInterval( 24.hour ).isTomorrow )
		XCTAssertTrue( Date().addingTimeInterval( -24.hour ).isYesterday )

		let date1 = formatter.date( from: "2019-01-01 00:00:00" )!
		let date2 = formatter.date( from: "2019-09-21 00:00:00" )!
		XCTAssertFalse( date1.isDateInWeekend )
		XCTAssertTrue( date2.isDateInWeekend )
	}
}
