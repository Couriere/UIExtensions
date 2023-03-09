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

public extension Int {

	/// Returns string representation of the receiver.
	var string: String { return String( self ) }
}

public extension Float {

	/// Returns string representation of the receiver.
	var string: String { return String( self ) }

	/** 	Returns string representation of the receiver with precision.
	  	- parameter precision: precision of formatted string.
	 ```
	 let f: Float = 1.23456
	 f.toString( "0" ) // "1.234560"
	 f.toString( "." ) // "1"
	 f.toString( ".2" ) // "1.23"
	 f.toString( "6.2" ) // "  1.23"
	 */
	func toString( _ precision: String ) -> String {
		return String( format: "%\( precision )f", self )
	}
}

public extension Double {

	/// Returns string representation of the receiver.
	var string: String { return String( self ) }

	/** 	Returns string representation of the receiver with precision.
	 - parameter precision: precision of formatted string.
	 ```
	 let d: Double = 1.23456
	 d.toString( "0" ) // "1.234560"
	 d.toString( "." ) // "1"
	 d.toString( ".2" ) // "1.23"
	 d.toString( "6.2" ) // "  1.23"
	 */
	func toString( _ precision: String ) -> String {
		return String( format: "%\( precision )f", self )
	}
}


public extension TimeInterval {

	/// Returns time formatted number of seconds.
	/// hh:mm:ss
	var formatted: String {
		let seconds = Int( isFinite ? self : 0 )
		return String( format: "%.2d:%.2d:%.2d", seconds / 3600, seconds % 3600 / 60, seconds % 60 )
	}
}


public extension Bool {
	var negate: Bool { !self }
}


infix operator |=: AssignmentPrecedence
public extension Bool {

	static func |= ( left: inout Bool, right: Bool ) {
		left = left || right
	}
}


/**
 Russian language only methods
 */

public extension Int {

	/**
	 Возвращает корректную форму слова для целого числа

	 - parameter wordForms: Возможные формы слова.
	 - returns: Правильная форма слова из вариантов в форме `4 стола`.

	 wordForms - массив из трёх вариантов существительного. Например:
	 ( "Стол", "Стола", "Столов" )
	 */

	func pluralWithForms( _ wordForms: ( String, String, String ) ) -> String {
		return "\( self ) \( pluralString( forNumber: self, fromWordForms: wordForms ) )"
	}

	/**
	 Возвращает корректную форму существительного для числительного
	 из слова с добавлением стандартных окончаний [а], [ов]

	 - parameter word:	Исходное слово
	 - returns: Правильную форму исходного слова в форме `4 стола`.

	 word - слово для нормализации. Например:
	 Стол -> [ "Стол", "Стола", "Столов" ]
	 */
	func pluralForWord( _ word: String ) -> String {
		return "\( self ) \( word.plural( forNumber: self ))"
	}

	var rub: String { return "\( self )₽" }
}

public extension Comparable {

	/// Checks that Comparable is in range ( ..< ) of lowerBound and upperBound.
	func isBetween( _ lowerBound: Self, and upperBound: Self ) -> Bool {
		return self >= lowerBound && self < upperBound
	}
}


public extension UnsignedInteger {
	static func seconds( _ timeInterval: TimeInterval ) -> UInt64 {
		return UInt64( timeInterval * 1_000_000_000 )
	}
	static func seconds<I: UnsignedInteger>( _ seconds: I ) -> UInt64 {
		return UInt64( seconds ) * 1_000_000_000
	}
	static func miliseconds<I: UnsignedInteger>( _ miliseconds: I ) -> UInt64 {
		return UInt64( miliseconds ) * 1_000_000
	}
	static func microseconds<I: UnsignedInteger>( _ microseconds: I ) -> UInt64 {
		return UInt64( microseconds ) * 1_000
	}
}
