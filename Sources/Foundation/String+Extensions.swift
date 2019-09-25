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

public extension String {

	/// Returns range from start to end of the string.
	var wholeRange: Range<String.Index> {
		return startIndex ..< endIndex
	}

	/// Returns a new string in which the characters in a specified range of the receiver are replaced by a given string.
	/// - parameter range: A range of characters in the receiver.
	/// - parameter replacement: The string with which to replace the characters in range.
	/// - returns: A new string in which the characters in range of the receiver are replaced by replacement.
	func replacingCharacters<T: StringProtocol>( in range: NSRange, with replacement: T ) -> String {
		guard let range = Range( range, in: self ) else { fatalError( "range out of bounds" ) }
		return replacingCharacters( in: range, with: replacement )
	}

	/// Returns new string by removing all non-digit symbols from receiver.
	var digitsOnly: String {
		return replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression, range: wholeRange )
	}

	/// Returns `true` if receiver holds correct email address.
	var isValidEmail: Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		return NSPredicate( format: "SELF MATCHES %@", emailRegex ).evaluate( with: self )
	}


	/// Returns string with stripped HTML tags.
	func strippingHTMLTags() -> String {
		let range = NSRange( startIndex ..< endIndex, in: self )
		return String.regex.stringByReplacingMatches( in: self,
		                                              options: [],
		                                              range: range,
		                                              withTemplate: "" )
	}

	private static let regex = try! NSRegularExpression( pattern: "<[^>]*>", options: [] )
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

public func pluralString( forNumber number: Int, fromWordForms: ( String, String, String ) ) -> String {

	let correctForm: String

	let absNumber = abs( number )
	if ( absNumber % 100 ) > 10 && ( absNumber % 100 ) < 20 {
		correctForm = fromWordForms.2
	}
	else {
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
