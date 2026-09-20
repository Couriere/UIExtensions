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
import Testing
import UIExtensions

@Suite("DateRange+ExtensionsTests")
struct DateRangeTests {

	private let calendar = Calendar.current

	private func date(
		_ year: Int,
		_ month: Int,
		_ day: Int,
		_ hour: Int = 0,
		_ minute: Int = 0,
		_ second: Int = 0,
	) -> Date {
		calendar.date(
			from: DateComponents(
				year: year,
				month: month,
				day: day,
				hour: hour,
				minute: minute,
				second: second,
			),
		)!
	}

	// MARK: - isWholeMonth

	@Test("Whole months of different lengths")
	func wholeMonths() {
		#expect(( date( 2024, 1, 1 ) ... date( 2024, 1, 31 )).isWholeMonth() )
		#expect(( date( 2024, 2, 1 ) ... date( 2024, 2, 29 )).isWholeMonth() )
		#expect(( date( 2023, 2, 1 ) ... date( 2023, 2, 28 )).isWholeMonth() )
		#expect(( date( 2024, 4, 1 ) ... date( 2024, 4, 30 )).isWholeMonth() )
		#expect(( date( 2024, 12, 1 ) ... date( 2024, 12, 31 )).isWholeMonth() )
	}

	@Test("Ranges that do not cover a whole month")
	func partialMonths() {
		#expect( !( date( 2024, 1, 2 ) ... date( 2024, 1, 31 )).isWholeMonth() )
		#expect( !( date( 2024, 1, 1 ) ... date( 2024, 1, 30 )).isWholeMonth() )
		#expect( !( date( 2024, 1, 10 ) ... date( 2024, 1, 20 )).isWholeMonth() )
		#expect( !( date( 2024, 1, 1 ) ... date( 2024, 3, 31 )).isWholeMonth() )
		#expect( !( date( 2024, 1, 1 ) ... date( 2024, 1, 1 )).isWholeMonth() )
		#expect( !( date( 2024, 2, 1 ) ... date( 2024, 2, 28 )).isWholeMonth() )
	}

	@Test("Time of day is ignored")
	func timeOfDayIsIgnored() {
		#expect(( date( 2024, 1, 1, 10, 30 ) ... date( 2024, 1, 31, 23, 59 )).isWholeMonth() )
		#expect(( date( 2024, 1, 1, 0, 0 ) ... date( 2024, 1, 31, 23, 59, 59 )).isWholeMonth() )
	}

	// MARK: - Granularity

	@Test("Single date, month and year")
	func granularity() {

		let singleDay = date( 2024, 5, 17, 1 ) ... date( 2024, 5, 17, 23 )
		#expect( singleDay.isSingleDate() )
		#expect( singleDay.isSameMonth() )
		#expect( singleDay.isSameYear() )

		let sameMonth = date( 2024, 5, 1 ) ... date( 2024, 5, 20 )
		#expect( !sameMonth.isSingleDate() )
		#expect( sameMonth.isSameMonth() )
		#expect( sameMonth.isSameYear() )

		let sameYear = date( 2024, 1, 1 ) ... date( 2024, 5, 20 )
		#expect( !sameYear.isSameMonth() )
		#expect( sameYear.isSameYear() )

		let differentYears = date( 2023, 12, 1 ) ... date( 2024, 1, 20 )
		#expect( !differentYears.isSameYear() )
	}

	// MARK: - Month To Date

	@Test("Month to date")
	func monthToDate() {

		let currentMonth = ClosedRange<Date>.currentMonth()
		#expect( currentMonth.isMonthToDate() )
		#expect( currentMonth.upperBound.isToday )

		let now = Date()
		let januaryToDate = now.startOfMonth() ... now.startOfMonth()
		#expect( !januaryToDate.isMonthToDate() || now.dayOfMonth() == 1 )
	}

	// MARK: - End Of Day

	@Test("End of day is the last second of the day")
	func endOfDay() {

		let moment = date( 2024, 3, 15, 8, 42, 7 )
		let endOfDay = moment.endOfDay()

		#expect( calendar.isDate( endOfDay, inSameDayAs: moment ))
		#expect( calendar.component( .hour, from: endOfDay ) == 23 )
		#expect( calendar.component( .minute, from: endOfDay ) == 59 )
		#expect( calendar.component( .second, from: endOfDay ) == 59 )
	}

	@Test("Day of month")
	func dayOfMonth() {
		#expect( date( 2024, 3, 15 ).dayOfMonth() == 15 )
		#expect( date( 2024, 3, 1 ).dayOfMonth() == 1 )
	}
}
