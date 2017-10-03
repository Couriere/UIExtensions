//
//  String+Extensions.swift
//
//  Created by Vladimir Kazantsev on 10.02.15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation

extension String {
	
	var length: Int { return count }
	
	func stringByReplacingCharactersInRange<T: StringProtocol>( _ nsRange: NSRange, withString replacement: T ) -> String {
		guard let range = Range( nsRange, in: self ) else { return self }
		return self.replacingCharacters( in: range, with: replacement )
	}
	
	var asPhoneNumber: String {
		
		guard length >= 10 else { return self }
		
		let tendigits = suffix( 10 )
		let index = tendigits.startIndex
		let triadIndex = tendigits.index( index, offsetBy: 3 )
		let firstPairIndex = tendigits.index( index, offsetBy: 6 )
		let secondPairIndex = tendigits.index( index, offsetBy: 8 )

		let city = tendigits[ ..<triadIndex ]
		let triad = tendigits[ triadIndex..<firstPairIndex ]
		let firstpair = tendigits[ firstPairIndex..<secondPairIndex ]
		let secondpair = tendigits[ secondPairIndex... ]
		
		return "+7 \( city ) \( triad ) \( firstpair ) \( secondpair )"
	}
	
	var digitsOnly: String {
		get {
			let range = startIndex..<endIndex
			return replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: range )
		}
	}
	
	var phoneNumber: String {
		get {
			return String( digitsOnly.suffix( 10 ))
		}
	}
}


/**
	SHA Encoding
*/
extension String {
	
	var SHA1: Data? {
		
		guard let data = self.data( using: .utf8 ) else { return nil }
		
		var digest: [UInt8] = Array( repeating: 0, count: Int( CC_SHA1_DIGEST_LENGTH ))
		
		data.withUnsafeBytes {
			_ = CC_SHA1( $0, CC_LONG( data.count ), &digest )
		}
		
		return Data( bytes: digest )
	}
	
	func HMACSHA1( key: String ) -> Data? {
		
		guard let dataToDigest = self.data( using: .utf8 ) as NSData?,
			let keyData = key.data( using: .utf8 ) as NSData? else { return nil }
		
		let digestLength = Int( CC_SHA1_DIGEST_LENGTH )
		let result = UnsafeMutablePointer<UInt8>.allocate( capacity: digestLength )
		
		CCHmac( CCHmacAlgorithm( kCCHmacAlgSHA1 ), keyData.bytes, keyData.length, dataToDigest.bytes, dataToDigest.length, result )
		
		return Data( bytes: result, count: digestLength )
	}
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
