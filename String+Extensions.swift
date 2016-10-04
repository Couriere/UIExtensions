//
//  String+Extensions.swift
//
//  Created by Vladimir Kazantsev on 10.02.15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation

extension String {
	
	var length: Int { return self.characters.count }
	
	func stringByReplacingCharactersInRange( _ range: NSRange, withString replacement: String ) -> String {
		let newString = self as NSString
		return newString.replacingCharacters( in: range, with: replacement )
	}
	
	var asPhoneNumber: String {
		
		guard length >= 10 else { return self }
		
		let tendigits = substring( from: characters.index( endIndex, offsetBy: -10 ))
		let index = tendigits.startIndex
		let triadIndex = tendigits.characters.index( index, offsetBy: 3 )
		let firstPairIndex = tendigits.characters.index( index, offsetBy: 6 )
		let secondPairIndex = tendigits.characters.index( index, offsetBy: 8 )

		let city = tendigits.substring( to: triadIndex )
		let triad = tendigits.substring( with: triadIndex..<firstPairIndex )
		let firstpair = tendigits.substring( with: firstPairIndex..<secondPairIndex )
		let secondpair = tendigits.substring( with: secondPairIndex..<tendigits.characters.endIndex )
		
		return "+7 \( city ) \( triad ) \( firstpair ) \( secondpair )"
	}
	
	var digitsOnly: String {
		get {
			let range = startIndex..<endIndex
			return replacingOccurrences(of: "[^0-9]", with: "", options: NSString.CompareOptions.regularExpression, range: range )
		}
	}
	
	var phoneNumber: String {
		get {
			let number = digitsOnly
			let PhoneNumberLength = 10
			let index = number.length - PhoneNumberLength
			if index <= 0 { return number }
			
			return number.substring( from: number.characters.index(number.startIndex, offsetBy: index) )
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
