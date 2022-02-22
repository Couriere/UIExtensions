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

	/// Returns NSRnge from start to end of the string.
	var nsRange: NSRange {
		return NSRange( wholeRange, in: self )
	}

	/// Returns a new string in which the characters in a specified range of the receiver are replaced by a given string.
	/// - parameter range: A range of characters in the receiver.
	/// - parameter replacement: The string with which to replace the characters in range.
	/// - returns: A new string in which the characters in range of the receiver are replaced by replacement.
	func replacingCharacters<T: StringProtocol>( in range: NSRange, with replacement: T ) -> String {
		guard let range = Range( range, in: self ) else { fatalError( "range out of bounds" ) }
		return replacingCharacters( in: range, with: replacement )
	}

	/// Accesses a contiguous subrange of the collection’s elements.
	/// - parameter range: A range of the collection’s indices.
	/// The bounds of the range must be valid indices of the collection.
	subscript( range: NSRange ) -> Substring {
		let laneRange = Range( range, in: self )!
		return self[ laneRange.lowerBound..<laneRange.upperBound ]
	}

	/// Returns new string by removing all non-digit symbols from receiver.
	var digitsOnly: String {
		return replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression, range: wholeRange )
	}

	/// Replaces all spaces in string to non-breaking spaces.
	var nonBreakingSpaces: String {
		self.replacingOccurrences( of: " ", with: "\u{a0}" )
	}

	/// Returns a new string made by removing from both ends of the String
	/// whitespace and newline characters.
	var trimmed: String {
		return self.trimmingCharacters( in: CharacterSet.newlines.union(CharacterSet.whitespaces) )
	}



	/// Returns `true` if receiver holds correct email address.
	var isValidEmail: Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,64}"
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



/// Calculating Hashes.
import CommonCrypto

public extension String {

	/// Calculates MD5 hash of the receiver and returns it as hex string.
	var md5: String {
		calculateHash( hashFunction: CC_MD5, digestLength: CC_MD5_DIGEST_LENGTH )
	}

	/// Calculates SHA1 hash of the receiver and returns it as hex string.
	var sha1: String {
		calculateHash( hashFunction: CC_SHA1, digestLength: CC_SHA1_DIGEST_LENGTH )
	}

	/// Calculates SHA256 hash of the receiver and returns it as hex string.
	var sha256: String {
		calculateHash( hashFunction: CC_SHA256, digestLength: CC_SHA256_DIGEST_LENGTH )
	}

	/// Calculates SHA512 hash of the receiver and returns it as hex string.
	var sha512: String {
		calculateHash( hashFunction: CC_SHA512, digestLength: CC_SHA512_DIGEST_LENGTH )
	}



	@inline(__always) private func calculateHash(
		hashFunction: ( UnsafeRawPointer?, CC_LONG, UnsafeMutablePointer<UInt8>? ) -> UnsafeMutablePointer<UInt8>?,
		digestLength: Int32
	) -> String {

		func itoh( _ value: UInt8 ) -> UInt8 {
			return ( value > 9 ) ? String.charA + value - 10 : String.char0 + value
		}

		let data = Data( self.utf8 )
		return data.withUnsafeBytes { ( bytes: UnsafeRawBufferPointer ) -> String in

			let count = Int( digestLength )
			var hash = [UInt8]( repeating: 0, count: count )
			_ = hashFunction( bytes.baseAddress, CC_LONG( data.count ), &hash )

			let hexLen = count * 2
			let hexData = UnsafeMutablePointer<UInt8>.allocate( capacity: hexLen )

			for i in 0 ..< count {
				hexData[ i * 2 ] = itoh( ( hash[ i ] >> 4 ) & 0xF )
				hexData[ i * 2 + 1 ] = itoh( hash[ i ] & 0xF )
			}

			return String( bytesNoCopy: hexData, length: hexLen, encoding: .utf8, freeWhenDone: true ) ?? ""
		}
	}

	private static let charA = UInt8( UnicodeScalar( "a" ).value )
	private static let char0 = UInt8( UnicodeScalar( "0" ).value )
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
