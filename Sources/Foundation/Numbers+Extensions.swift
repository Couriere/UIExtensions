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

extension Int {

	/// Returns string representation of the receiver.
	@inlinable
	@inline(__always)
	public var string: String { String( self ) }
}

extension String {
	/// Attempts to convert the receiver to an Int.
	/// - returns: The Int representation of the receiver or nil if the conversion fails.
	@inlinable
	@inline(__always)
	public var int: Int? { Int( self ) }
}

extension Float {

	/// Returns string representation of the receiver.
	@inlinable
	@inline(__always)
	public var string: String { String( self ) }

	/** 	Returns string representation of the receiver with precision.
	  	- parameter precision: precision of formatted string.
	 ```
	 let f: Float = 1.23456
	 f.toString( "0" ) // "1.234560"
	 f.toString( "." ) // "1"
	 f.toString( ".2" ) // "1.23"
	 f.toString( "6.2" ) // "  1.23"
	 */
	@inlinable
	public func toString( _ precision: String ) -> String {
		String( format: "%\( precision )f", self )
	}
}

extension Double {

	/// Returns string representation of the receiver.
	@inlinable
	@inline(__always)
	public var string: String { String( self ) }

	/** 	Returns string representation of the receiver with precision.
	 - parameter precision: precision of formatted string.
	 ```
	 let d: Double = 1.23456
	 d.toString( "0" ) // "1.234560"
	 d.toString( "." ) // "1"
	 d.toString( ".2" ) // "1.23"
	 d.toString( "6.2" ) // "  1.23"
	 */
	@inlinable
	public func toString( _ precision: String ) -> String {
		return String( format: "%\( precision )f", self )
	}
}


extension TimeInterval {

	/// Returns time formatted number of seconds.
	/// hh:mm:ss
	public var formatted: String {
		let seconds = Int( isFinite ? self : 0 )
		return String( format: "%.2d:%.2d:%.2d", seconds / 3600, seconds % 3600 / 60, seconds % 60 )
	}
}

extension Bool {
	/// Returns the logical negation of the boolean.
	@inlinable
	@inline(__always)
	public var negate: Bool { !self }
}

/// Logical-OR assignment operator for booleans.
infix operator |=: AssignmentPrecedence
extension Bool {

	/// Updates the left-hand value by OR-ing it with the right-hand value.
	public static func |= ( left: inout Bool, right: Bool ) {
		left = left || right
	}
}
extension UnsignedInteger {
	public static func seconds( _ timeInterval: TimeInterval ) -> UInt64 {
		UInt64( timeInterval * 1_000_000_000 )
	}
	public static func seconds<I: UnsignedInteger>( _ seconds: I ) -> UInt64 {
		UInt64( seconds ) * 1_000_000_000
	}
	public static func miliseconds<I: UnsignedInteger>( _ miliseconds: I ) -> UInt64 {
		UInt64( miliseconds ) * 1_000_000
	}
	public static func microseconds<I: UnsignedInteger>( _ microseconds: I ) -> UInt64 {
		UInt64( microseconds ) * 1_000
	}
}

extension CGFloat {
	@inlinable
	@inline(__always)
	public var asDouble: Double { Double(self) }
}

// MARK: - Ranges

extension Comparable {

	/// Returns a Boolean value indicating whether the value lies
	/// within the given half-open range.
	///
	/// - Parameter range: The range to test against.
	/// - Returns: `true` if the value is greater than or equal to the lower
	///   bound and less than the upper bound, otherwise `false`.
	@inlinable
	public func isIn( _ range: Range<Self> ) -> Bool {
		self >= range.lowerBound && self < range.upperBound
	}

	/// Returns a Boolean value indicating whether the value lies
	/// within the given closed range.
	///
	/// - Parameter range: The range to test against.
	/// - Returns: `true` if the value is greater than or equal to the lower
	///   bound and less than or equal to the upper bound, otherwise `false`.
	@inlinable
	public func isIn( _ range: ClosedRange<Self> ) -> Bool {
		self >= range.lowerBound && self <= range.upperBound
	}

	/// Returns the value limited to the given closed range.
	///
	/// - Parameter range: The range to limit the value to.
	/// - Returns: The nearest value within `range`.
	@inlinable
	public func clamped( in range: ClosedRange<Self> ) -> Self {
		if self < range.lowerBound { return range.lowerBound }
		if self > range.upperBound { return range.upperBound }
		return self
	}

	/// Returns the value limited to the given half-open range.
	///
	/// - Parameter range: The range to limit the value to.
	/// - Returns: The nearest value within `range`.
	///
	/// - Important: The upper bound is not part of a half-open range, yet it
	///   is the closest representable result for a general `Comparable` type.
	///   Floating-point types use an overload that returns the largest value
	///   strictly below the upper bound instead.
	@inlinable
	public func clamped( in range: Range<Self> ) -> Self {
		if self < range.lowerBound { return range.lowerBound }
		if self > range.upperBound { return range.upperBound }
		return self
	}
}

extension BinaryFloatingPoint {

	/// Returns the value limited to the given half-open range.
	///
	/// Unlike the general `Comparable` overload, the result never reaches
	/// the upper bound: a value above the range is clamped to the largest
	/// representable value strictly below it.
	///
	/// - Parameter range: The range to limit the value to.
	/// - Returns: The nearest value within `range`.
	@inlinable
	public func clamped( in range: Range<Self> ) -> Self {
		if self < range.lowerBound { return range.lowerBound }
		if self > range.upperBound.nextDown { return range.upperBound.nextDown }
		return self
	}
}

// MARK: - Arithmetic Shorthands

extension BinaryFloatingPoint {

	/// The value multiplied by two.
	@inlinable
	@inline(__always)
	public var doubled: Self { self * 2 }

	/// The value divided by two.
	@inlinable
	@inline(__always)
	public var halved: Self { self / 2 }

	/// The value multiplied by three.
	@inlinable
	@inline(__always)
	public var tripled: Self { self * 3 }

	/// The value divided by three.
	@inlinable
	@inline(__always)
	public var third: Self { self / 3 }
}

extension Comparable where Self: AdditiveArithmetic {

	/// A Boolean value indicating whether the value is greater than zero.
	@inlinable
	@inline(__always)
	public var greaterThanZero: Bool { self > .zero }

	/// A Boolean value indicating whether the value is less than zero.
	@inlinable
	@inline(__always)
	public var lessThanZero: Bool { self < .zero }

	/// A Boolean value indicating whether the value is equal to zero.
	@inlinable
	@inline(__always)
	public var equalToZero: Bool { self == .zero }

	/// A Boolean value indicating whether the value is greater than
	/// or equal to zero.
	@inlinable
	@inline(__always)
	public var greaterThanOrEqualToZero: Bool { self >= .zero }

	/// A Boolean value indicating whether the value is less than
	/// or equal to zero.
	@inlinable
	@inline(__always)
	public var lessThanOrEqualToZero: Bool { self <= .zero }
}

/**
 Russian language only methods
 */

extension Int {

	/**
	 Возвращает корректную форму слова для целого числа

	 - parameter wordForms: Возможные формы слова.
	 - returns: Правильная форма слова из вариантов в форме `4 стола`.

	 wordForms - массив из трёх вариантов существительного. Например:
	 ( "Стол", "Стола", "Столов" )
	 */

	public func pluralWithForms( _ wordForms: ( String, String, String ) ) -> String {
		"\( self ) \( pluralString( forNumber: self, fromWordForms: wordForms ) )"
	}

	/**
	 Возвращает корректную форму существительного для числительного
	 из слова с добавлением стандартных окончаний [а], [ов]

	 - parameter word:	Исходное слово
	 - returns: Правильную форму исходного слова в форме `4 стола`.

	 word - слово для нормализации. Например:
	 Стол -> [ "Стол", "Стола", "Столов" ]
	 */
	public func pluralForWord( _ word: String ) -> String {
		"\( self ) \( word.plural( forNumber: self ))"
	}

	public var rub: String { "\( self )₽" }
}
