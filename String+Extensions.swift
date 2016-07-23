//
//  String+Extensions.swift
//
//  Created by Vladimir Kazantsev on 10.02.15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation

extension String {
	
	var length: Int { return self.characters.count }

	func rangeFromNSRange( range: NSRange ) -> Range<String.Index> {
		let startIndex = self.startIndex.advancedBy(range.location )
		return Range( start: startIndex, end: startIndex.advancedBy(range.length ))
	}
	
	/// Не учтиывает спецсимволы юникода
	func NSRangeFromRange( range: Range<String.Index> ) -> NSRange {
		let start = self.startIndex.distanceTo(range.startIndex)
		let length = range.startIndex.distanceTo(range.endIndex)
		return NSMakeRange( start, length )
	}
	
	func stringByReplacingCharactersInRange( range: NSRange, withString replacement: String ) -> String {
		var newString = self
		newString.replaceRange( newString.rangeFromNSRange( range ), with: replacement )
		return newString
	}
	
	var asPhoneNumber: String {
		let tendigits = substringFromIndex( endIndex.advancedBy(-10 ))
		let city = tendigits.substringWithRange( rangeFromNSRange( NSMakeRange( 0, 3 )))
		let triad = tendigits.substringWithRange( rangeFromNSRange( NSMakeRange( 3, 3 )))
		let firstpair = tendigits.substringWithRange( rangeFromNSRange( NSMakeRange( 6, 2 )))
		let secondpair = tendigits.substringWithRange( rangeFromNSRange( NSMakeRange( 8, 2 )))
		
		return "+7 \( city ) \( triad ) \( firstpair ) \( secondpair )"
	}
	
	var digitsOnly: String {
		get {
			let range = Range<String.Index>( start: startIndex, end: endIndex )
			return stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: range )
		}
	}
	
	var phoneNumber: String {
		get {
			let number = digitsOnly
			let PhoneNumberLength = 10
			let index = number.length - PhoneNumberLength
			if index <= 0 { return number }
			
			return number.substringFromIndex( number.startIndex.advancedBy(index ) )
		}
	}

	var rub: String { return self + "₽" }
}


/**
Возвращает корректную форму существительного для числительного

- parameter wordForms: Возможные формы слова.

- returns: Правильная форма слова из вариантов.

wordForms - массив из трёх вариантов существительного. Например:
( "Стол", "Стола", "Столов" )
*/

func pluralString( forNumber number: Int, fromWordForms: ( String, String, String ) ) -> String	{
	
	let correctForm: String
	
	let absNumber = abs( number )
	if ( absNumber % 100 ) > 10 && ( absNumber % 100 ) < 20 {
		correctForm = fromWordForms.2
	} else {
		switch absNumber % 10 {
		case 1:
			correctForm = fromWordForms.0
		case 2, 3, 4:
			correctForm = fromWordForms.1
		default:
			correctForm = fromWordForms.2
		}
	}
	
	return correctForm
}

extension String {
	
	/**
	Возвращает корректную форму существительного для числительного
	из слова с добавлением стандартных окончаний [а], [ов]
	
	- parameter word:	Исходное слово
	
	- returns: Правильную форму исходного слова для указанного числительного
	
	word - слово для нормализации. Например:
	Стол -> [ "Стол", "Стола", "Столов" ]
	*/
	
	func plural( forNumber number: Int ) -> String {
		let wordForms = ( self, self + "а", self + "ов" )
		return pluralString( forNumber: number, fromWordForms: wordForms )
	}
}
