//
//  String+Extensions.swift
//
//  Created by Vladimir Kazantsev on 10.02.15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation

public extension String {

	/// Returns range from start to end of the string.
	public var wholeRange: Range<String.Index> {
		return startIndex..<endIndex
	}

	/// Returns a new string in which the characters in a specified range of the receiver are replaced by a given string.
	/// - parameter range: A range of characters in the receiver.
	/// - parameter replacement: The string with which to replace the characters in range.
	/// - returns: A new string in which the characters in range of the receiver are replaced by replacement.
	public func replacingCharacters<T: StringProtocol>( in range: NSRange, with replacement: T ) -> String {
		guard let range = Range( range, in: self ) else { fatalError( "range out of bounds" ) }
		return self.replacingCharacters( in: range, with: replacement )
	}

	/// Returns new string by removing all non-digit symbols from receiver.
	public var digitsOnly: String {
		get {
			return replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression, range: wholeRange )
		}
	}

	/// Returns `true` if receiver holds correct email address.
	public var isValidEmail: Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		return NSPredicate( format: "SELF MATCHES %@", emailRegex ).evaluate( with: self )
	}
}



/**
	Russian language only methods.
*/

/**
Возвращает корректную форму существительного для числительного

- parameter wordForms: Возможные формы слова.

- returns: Правильная форма слова из вариантов.

wordForms - массив из трёх вариантов существительного. Например:
( "Стол", "Стола", "Столов" )
*/

public func pluralString( forNumber number: Int, fromWordForms: ( String, String, String ) ) -> String	{
	
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

public extension String {
	
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
