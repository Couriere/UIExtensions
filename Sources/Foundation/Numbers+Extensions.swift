//
//  Numbers+Strings.swift
//
//  Created by Vladimir Kazantsev on 22.01.15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

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
