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

extension Comparable {

	/// Checks that Comparable is in range ( ..< ) of lowerBound and upperBound.
	public func isBetween( _ lowerBound: Self, and upperBound: Self ) -> Bool {
		return self >= lowerBound && self < upperBound
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
	public var double: Double { Double(self) }
}
