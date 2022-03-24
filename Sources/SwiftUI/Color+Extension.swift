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

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Color {

	/// Initializes and returns a color object using the specified opacity and Int RGB component values.
	/// - parameter intRed: The red value of the color object, specified as a value from 0 to 255.
	/// - parameter green: The red value of the color object, specified as a value from 0 to 255.
	/// - parameter blue: The red value of the color object, specified as a value from 0 to 255.
	/// - parameter opacity: The opacity value of the color object, specified as a value from 0.0 to 1.0.
	/// opacity values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0.
	init( intRed: Int, green: Int, blue: Int, opacity: Double = 1 ) {
		self.init( red: Double( intRed ) / 255, green: Double( green ) / 255, blue: Double( blue ) / 255, opacity: opacity )
	}

	/// Returns a Color by scanning the string for a hex number.
	/// Skips any leading whitespace and ignores any trailing characters.
	init?( hex: String, opacity: Double = 1 ) {

		// Search for the first streak of six hexadecimal characters.
		let items = hex.components( separatedBy: Color.invertedHexCharactersSet )
		guard let hexString = items.first( where: { $0.count >= 6 } ) else { return nil }

		let colorString = hexString[..<hexString.index( hexString.startIndex, offsetBy: 6 ) ]

		let scanner = Scanner( string: String( colorString ))

		guard let hexNum = scanner.scanInt( representation: .hexadecimal ) else { return nil }
		self.init( hexNum, opacity: opacity )
	}

	private static let invertedHexCharactersSet = CharacterSet( charactersIn: "0123456789abcdefABCDEF" ).inverted


	/// Returns random color with supplied opacity.
	init( randomWithopacity opacity: Double ) {
		let randomRed = Int( arc4random_uniform( 256 ) )
		let randomGreen = Int( arc4random_uniform( 256 ) )
		let randomBlue = Int( arc4random_uniform( 256 ) )
		self.init( intRed: randomRed, green: randomGreen, blue: randomBlue, opacity: opacity )
	}


	/// Initializes and returns a color object using the specified opacity and Int RGB component values.
	/// i.e. `Color( 0xFFFF00, opacity: 0.5 )` for yellow color.
	/// - parameter int: Integer representation of color. This number will be divided by three 8-bit
	/// parts for red, green and blue components.
	/// - parameter opacity: The opacity value of the color object, specified as a value from 0.0 to 1.0.
	/// opacity values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0.
	init( _ int: Int, opacity: Double = 1 ) {

		let int = UInt32( int )

		let red = Int( ( int >> 16 ) & 0xFF )
		let green = Int( ( int >> 8 ) & 0xFF )
		let blue = Int( int & 0xFF )

		self.init( intRed: red, green: green, blue: blue, opacity: opacity )
	}
}


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Color {

	/// Returns white color with specified opacity value.
	static func white( _ opacity: Double ) -> Color {
		Color( white: 1, opacity: opacity )
	}

	/// Returns black color with specified opacity value.
	static func black( _ opacity: Double ) -> Color {
		Color( white: 0, opacity: opacity )
	}

	/// Returns gray color with specified shade and opacity.
	static func gray( _ white: Double, opacity: Double = 1 ) -> Color {
		Color( white: white, opacity: opacity )
	}

	/// Returns gray color with specified shade and opacity.
	static func iGray( _ white: Int, opacity: Double = 1 ) -> Color {
		Color( white: Double( white ) / 255 , opacity: opacity )
	}
}
