//
//  Numbers+Strings.swift
//
//  Created by Vladimir Kazantsev on 22.01.15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

extension Int {
	var string: String {
		return "\( self )"
	}
	
	var radians: CGFloat { return CGFloat( M_PI ) * CGFloat( self ) / 180 }
	
	/**
	Возвращает корректную форму существительного для числительного
	
	- parameter wordForms: Возможные формы слова.
	
	- returns: Правильная форма слова из вариантов.
	
	wordForms - массив из трёх вариантов существительного. Например:
	( "Стол", "Стола", "Столов" )
	*/
	
	func pluralWithForms( wordForms: ( String, String, String ) ) -> String	{
		
		let correctForm: String
		
		let absNumber = abs( self )
		if ( absNumber % 100 ) > 10 && ( absNumber % 100 ) < 20 {
			correctForm = wordForms.2
		} else {
			switch absNumber % 10 {
			case 1:
				correctForm = wordForms.0
			case 2, 3, 4:
				correctForm = wordForms.1
			default:
				correctForm = wordForms.2
			}
		}
		
		return "\( self ) \( correctForm )"
	}
	
	/**
	Возвращает корректную форму существительного для числительного
	из слова с добавлением стандартных окончаний [а], [ов]
	
	- parameter word:	Исходное слово
	
	- returns: Правильную форму исходного слова для указанного числительного
	
	word - слово для нормализации. Например:
	Стол -> [ "Стол", "Стола", "Столов" ]
	*/
	
	func pluralForWord( word: String ) -> String {
		let wordForms = ( word, word + "а", word + "ов" )
		return self.pluralWithForms( wordForms )
	}
	
	
	var rub: String {
		if #available( iOS 8, * ) {
			return "\( self )₽"
		} else {
			return "\( self )Р"
		}
	}
}

extension Float {
	func toString() -> String {
		return "\( self )"
	}
	func toString( precisionString: String ) -> String {
		return String( format: "%" + precisionString + "f", self )
	}
}

extension NSTimeInterval {
	var toString: String {
		let seconds = Int( isNaN ? 0 : self )
		return String( format: "%.2d:%.2d:%.2d", seconds / 3600, seconds % 3600 / 60, seconds % 60 )
	}
}


infix operator |= { associativity left precedence 140 }
func |= ( inout left: Bool, right: Bool ) {
	left = left || right
}

func *= ( inout left: CGRect, right: CGFloat ) {
	left = CGRect( x: left.origin.x * right, y: left.origin.y * right, width: left.size.width * right, height: left.size.height * right )
}