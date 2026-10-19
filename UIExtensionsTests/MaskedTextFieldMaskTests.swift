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

#if os(iOS) || os(macOS)
import Testing
@testable import UIExtensions

private typealias Mask = MaskedTextField.Mask

@Suite( "Letter tokens" )
struct MaskLetterTests {

	@Test( arguments: [
		( "AB", "AB" ),
		( "Яё", "Яё" ),
		( "éß", "éß" ),
		( "1A2B", "AB" ),
		( "12🙂", "" ),
		( "", "" ),
	] )
	func `letter token accepts letters`( input: String, expected: String ) throws {
		let mask = try #require( Mask( pattern: "@@" ) )
		#expect( mask.significantCharacters( in: input ) == expected )
	}

	@Test
	func `letter token combines with other tokens`() throws {
		let mask = try #require( Mask( pattern: "ID-@@-#*" ) )
		#expect( mask.prefix == "ID-" )
		#expect( mask.tokens == [ .letter, .letter, .digit, .alphanumeric ] )
		#expect( mask.isNumeric == false )
		#expect( mask.significantCharacters( in: "1A2B-C3D" ) == "AB3D" )
		#expect( mask.format( "AB3D" ) == "AB-3D" )
		#expect( mask.remainder( after: 2, fillSymbol: "_" ) == "-__" )
		#expect( mask.caretOffset( afterSignificantCount: 3, in: "AB-3D" ) == 4 )
		#expect( mask.overflows( "AB-3D" ) == false )
		#expect( mask.overflows( "AB-3DE" ) )
		let letters = try #require( Mask( pattern: "@@" ) )
		#expect( letters.overflows( "AB1" ) == false )
		#expect( letters.overflows( "ABC" ) )
	}
}

@Suite( "Mask parsing" )
struct MaskPatternTests {

	@Test
	func `pattern splits prefix and body`() throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.prefix == "+998 " )
		#expect( mask.body == "## ### ## ##" )
		#expect( mask.tokens.count == 9 )
	}

	@Test
	func `pattern without prefix`() throws {

		let mask = try #require( Mask( pattern: "##.##.####" ) )

		#expect( mask.prefix.isEmpty )
		#expect( mask.body == "##.##.####" )
		#expect( mask.tokens.count == 8 )
	}

	@Test
	func `letters before first token belong to prefix`() throws {

		let mask = try #require( Mask( pattern: "AA-####" ) )

		#expect( mask.prefix == "AA-" )
		#expect( mask.body == "####" )
	}

	@Test
	func `tokens retain their types`() throws {

		let mask = try #require( Mask( pattern: "** #######" ) )

		#expect(
			mask.tokens == [
				.alphanumeric, .alphanumeric,
				.digit, .digit, .digit, .digit, .digit, .digit, .digit,
			],
		)
	}

	@Test
	func `pattern without tokens is invalid`() {
		#expect( Mask( pattern: "+998" ) == nil )
		#expect( Mask( pattern: "" ) == nil )
	}

	@Test
	func `numeric mask detection`() throws {

		let cardMask = try #require( Mask( pattern: "#### #### #### ####" ) )
		let dateMask = try #require( Mask( pattern: "##.##.####" ) )
		let passportMask = try #require( Mask( pattern: "** #######" ) )

		#expect( cardMask.isNumeric )
		#expect( dateMask.isNumeric )
		#expect( passportMask.isNumeric == false )
	}
}

@Suite( "Significant characters" )
struct MaskSignificantCharactersTests {

	@Test(

		arguments: [
			( "93 133 14 00", "931331400" ),
			( "931331400", "931331400" ),
			( "93 1", "931" ),
			( "", "" ),
		],
	)
	func `separators are discarded`( input: String, expected: String ) throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.significantCharacters( in: input ) == expected )
	}

	@Test
	func `invalid characters are discarded`() throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.significantCharacters( in: "9a3b1" ) == "931" )
	}

	@Test
	func `input is truncated to mask capacity`() throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.significantCharacters( in: "9313314001234" ) == "931331400" )
	}

	@Test(

		arguments: [
			( "AB 1234567", "AB1234567" ),
			( "12 3456789", "123456789" ),
			( "AB CDEFGHI", "AB" ),
		],
	)
	func `tokens validate their own positions`( input: String, expected: String ) throws {

		let mask = try #require( Mask( pattern: "** #######" ) )

		#expect( mask.significantCharacters( in: input ) == expected )
	}
}

@Suite( "Overflow" )
struct MaskOverflowTests {

	@Test(

		arguments: [ "", "93", "93 133 14 00", "931331400" ],
	)
	func `input within capacity does not overflow`( input: String ) throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.overflows( input ) == false )
	}

	@Test
	func `extra significant character overflows`() throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.overflows( "593 133 14 00" ) )
		#expect( mask.overflows( "93 133 14 005" ) )
	}

	@Test
	func `extra separators do not overflow`() throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.overflows( "93 133 14 00 " ) == false )
	}

	@Test
	func `unmatched characters do not overflow`() throws {

		let mask = try #require( Mask( pattern: "##.##.####" ) )

		#expect( mask.overflows( "01.02.2026" ) == false )
		#expect( mask.overflows( "01.02.2026a" ) == false )
		#expect( mask.overflows( "01.02.20261" ) )
	}

	@Test
	func `mixed token overflow`() throws {

		let mask = try #require( Mask( pattern: "** #######" ) )

		#expect( mask.overflows( "AB 1234567" ) == false )
		#expect( mask.overflows( "AB 12345678" ) )
	}
}

@Suite( "Formatting" )
struct MaskFormatTests {

	@Test(

		arguments: [
			( "931331400", "93 133 14 00" ),
			( "93", "93" ),
			( "931", "93 1" ),
			( "9313", "93 13" ),
			( "", "" ),
		],
	)
	func `characters follow mask separators`( input: String, expected: String ) throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.format( input ) == expected )
	}

	@Test(

		arguments: [
			( "0102", "01.02" ),
			( "01023", "01.02.3" ),
			( "01022026", "01.02.2026" ),
		],
	)
	func `trailing separator waits for next character`( input: String, expected: String ) throws {

		let mask = try #require( Mask( pattern: "##.##.####" ) )

		#expect( mask.format( input ) == expected )
	}
}

@Suite( "Mask remainder" )
struct MaskRemainderTests {

	@Test(

		arguments: [
			( 0, "__ ___ __ __" ),
			( 2, " ___ __ __" ),
			( 6, " __ __" ),
			( 12, "" ),
		],
	)
	func `remainder uses fill symbol`( offset: Int, expected: String ) throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.remainder( after: offset, fillSymbol: "_" ) == expected )
	}

	@Test
	func `remainder preserves separators`() throws {

		let mask = try #require( Mask( pattern: "##.##.####" ) )

		#expect( mask.remainder( after: 0, fillSymbol: "_" ) == "__.__.____" )
		#expect( mask.remainder( after: 3, fillSymbol: "_" ) == "__.____" )
	}
}

@Suite( "Caret position" )
struct MaskCaretOffsetTests {

	@Test(

		arguments: [
			( 0, 0 ),
			( 1, 1 ),
			( 2, 2 ),
			( 3, 4 ),
			( 5, 6 ),
			( 9, 12 ),
		],
	)
	func `caret follows significant character`( count: Int, expected: Int ) throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.caretOffset( afterSignificantCount: count, in: "93 133 14 00" ) == expected )
	}

	@Test
	func `caret offset stays within formatted text`() throws {

		let mask = try #require( Mask( pattern: "+998 ## ### ## ##" ) )

		#expect( mask.caretOffset( afterSignificantCount: 5, in: "93" ) == 2 )
		#expect( mask.caretOffset( afterSignificantCount: 3, in: "" ) == 0 )
	}
}

@Suite( "Number grouping" )
struct NumberInputTests {

	@Test( arguments: [
		( "", "" ),
		( "0", "0" ),
		( "0000", "0" ),
		( "001000", "1 000" ),
		( "12", "12" ),
		( "123", "123" ),
		( "1234", "1 234" ),
		( "12345", "12 345" ),
		( "123456", "123 456" ),
		( "1234567", "1 234 567" ),
		( "0000123", "123" ),
		( "1234567890123456789012345", "1 234 567 890 123 456 789 012 345" ),
	] )
	@MainActor
	func grouping( input: String, expected: String ) {
		#expect( MaskedTextField.groupedNumber( MaskedTextField.normalizedNumber( input ) ) == expected )
	}
}
#endif
