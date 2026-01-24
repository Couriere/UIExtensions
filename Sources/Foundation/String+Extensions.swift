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

extension String {

	/// Returns range from start to end of the string.
	public var wholeRange: Range<String.Index> {
		return startIndex ..< endIndex
	}

	/// Returns NSRnge from start to end of the string.
	public var nsRange: NSRange {
		return NSRange( wholeRange, in: self )
	}

	/// Returns a new string in which the characters in a specified range of the receiver are replaced by a given string.
	/// - parameter range: A range of characters in the receiver.
	/// - parameter replacement: The string with which to replace the characters in range.
	/// - returns: A new string in which the characters in range of the receiver are replaced by replacement.
	public func replacingCharacters<T: StringProtocol>(
		in range: NSRange,
		with replacement: T
	) -> String {
		guard let range = Range( range, in: self ) else {
			fatalError( "range out of bounds" )
		}
		return replacingCharacters( in: range, with: replacement )
	}

	/// Accesses a contiguous subrange of the collection’s elements.
	/// - parameter range: A range of the collection’s indices.
	/// The bounds of the range must be valid indices of the collection.
	/// - returns: A substring covering the specified NSRange.
	///
	/// Accesses a substring using an NSRange in the receiver's indices.
	public subscript( range: NSRange ) -> Substring {
		let laneRange = Range( range, in: self )!
		return self[ laneRange.lowerBound..<laneRange.upperBound ]
	}

	/// Breaks up a string into an array of substrings,
	/// each containing `length` characters.
	/// - parameter length: The length of each substring. Must be greater than zero.
	/// - returns: An array of substrings, each containing `length` characters.
	public func chunk( _ length: Int ) -> [ String ] {
		precondition( length > 0, "length must be greater than zero" )
		return Array( self )
			.chunk( length )
			.map( String.init(_:) )
	}

	/// Returns new string by removing all non-digit symbols from receiver.
	public var digitsOnly: String {
		return replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression, range: wholeRange )
	}

	/// Replaces all spaces in string to non-breaking spaces.
	public var nonBreakingSpaces: String {
		self.replacingOccurrences( of: " ", with: "\u{a0}" )
	}

	/// Returns a new string made by removing from both ends of the String
	/// whitespace and newline characters.
	public var trimmed: String {
		return self.trimmingCharacters( in: CharacterSet.newlines.union(CharacterSet.whitespaces) )
	}


	/// Safely accesses a character by index, returning nil if out of bounds.
	/// - parameter index: The index of the character to access.
	/// - returns: The character at the specified index, or nil if index is out of bounds.
	public subscript( safe index: Int ) -> Character? {
		guard index < count else { return nil }

		let index = self.index( startIndex, offsetBy: index )
		return self[ index ]
	}


	/// Returns `true` if receiver holds correct email address.
	public var isValidEmail: Bool {
		let emailRegex = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,64}"
		return NSPredicate( format: "SELF MATCHES %@", emailRegex ).evaluate( with: self )
	}


	/// Returns string with stripped HTML tags.
	public func strippingHTMLTags() -> String {
		let range = NSRange( startIndex ..< endIndex, in: self )
		return String.regex.stringByReplacingMatches( in: self,
		                                              options: [],
		                                              range: range,
		                                              withTemplate: "" )
	}

	/// Initializes a String from a StaticString.
	/// - parameter staticString: The StaticString to initialize from.
	public init( _ staticString: StaticString ) {
		self = staticString.withUTF8Buffer {
			String( decoding: $0, as: UTF8.self )
		}
	}

	private static let regex = try! NSRegularExpression(
		pattern: "<[^>]*>",
		options: []
	)
}

extension String {

	/// Creates a URL from the string using `URL(string:)`.
	public var url: URL? {
		URL( string: self )
	}
}

extension [ String? ] {
	/// Joins non-nil strings using a separator.
	/// - parameter separator: The separator string
	/// to insert between each element. Default is empty string.
	/// - returns: A concatenated string of all
	/// non-nil elements separated by the separator.
	public func joined( separator: String = "" ) -> String {
		joinedStrings( self, separator: separator )
	}
}

/// Joins an array of optional strings by a separator, omitting nils.
/// - Parameters:
///   - strings: Array of optional strings.
///   - separator: Separator string.
/// - Returns: Joined string with non-nil elements separated by separator.
func joinedStrings(
	_ strings: [ String? ],
	separator: String = ""
) -> String {
	strings
		.compactMap()
		.joined( separator: separator )
}

/// Joins a variadic list of optional strings by a separator, omitting nils.
/// - Parameters:
///   - strings: Variadic optional strings.
///   - separator: Separator string.
/// - Returns: Joined string with non-nil elements separated by separator.
func joinedStrings(
	_ strings: String?...,
	separator: String = ""
) -> String {
	joinedStrings( strings, separator: separator )
}

extension Character {
	/// Returns a String containing this character.
	public var string: String { String( self ) }
}


/// Calculating Hashes.
import CommonCrypto
#if canImport(CryptoKit)
import CryptoKit
#endif

extension String {

	/// Calculates MD5 hash of the receiver and returns it as hex string.
	public var md5: String {
		Insecure.MD5.hash( data: Data( utf8 )).hexadecimalString
	}

	/// Calculates SHA1 hash of the receiver and returns it as hex string.
	public var sha1: String {
		Insecure.SHA1.hash( data: Data( utf8 )).hexadecimalString
	}

	/// Calculates SHA256 hash of the receiver and returns it as hex string.
	public var sha256: String {
		SHA256.hash( data: Data( utf8 )).hexadecimalString
	}

	/// Calculates SHA512 hash of the receiver and returns it as hex string.
	public var sha512: String {
		SHA512.hash( data: Data( utf8 )).hexadecimalString
	}
}

extension Digest {

	/// Returns the hexadecimal string representation of the digest.
	public var hexadecimalString: String {
		Data( self ).hexadecimalString
	}
}

extension String {

	/// Converts a camelCase string to snake_case.
	public var snakeCaseFromCamelCase: String {
		let string = self.trimmingCharacters(in: String.underscoreCharacterSet)
		guard !string.isEmpty else { return string }

		let split = string.split(separator: "_")
		return "\(split[0])\(split.dropFirst().map { $0.capitalized }.joined())"
	}

	/// Converts a snake_case string to camelCase.
	public var camelCaseFromSnakeCase: String {

		String.camelCasePatterns
			.reduce( self ) { string, regex in
				regex.stringByReplacingMatches(
					in: string,
					options: [],
					range: NSRange(location: 0, length: string.count),
					withTemplate: "$1_$2"
				)
			}
			.lowercased()
	}


	private static let underscoreCharacterSet = CharacterSet(arrayLiteral: "_")
	private static let camelCasePatterns: [NSRegularExpression] = [
		"([A-Z]+)([A-Z][a-z]|[0-9])",
		"([a-z])([A-Z]|[0-9])",
		"([0-9])([A-Z])",
	]
	.map { try! NSRegularExpression(pattern: $0, options: []) }
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

/// Returns the correct Russian noun form for the given number from three provided word forms.
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

extension String {

	/**
	 Возвращает корректную форму существительного для числительного
	 из слова с добавлением стандартных окончаний [а], [ов]

	 - parameter word:	Исходное слово

	 - returns: Правильную форму исходного слова для указанного числительного

	 word - слово для нормализации. Например:
	 Стол -> [ "Стол", "Стола", "Столов" ]
	 */
	public func plural( forNumber number: Int ) -> String {
		let wordForms = ( self, self + "а", self + "ов" )
		return pluralString( forNumber: number, fromWordForms: wordForms )
	}
}
