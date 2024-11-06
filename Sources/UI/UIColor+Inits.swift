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

#if canImport(UIKit)
import UIKit

public extension UIColor {

	/// Initializes and returns a color object using the specified opacity and Int RGB component values.
	/// - parameter intRed: The red value of the color object, specified as a value from 0 to 255.
	/// - parameter green: The red value of the color object, specified as a value from 0 to 255.
	/// - parameter blue: The red value of the color object, specified as a value from 0 to 255.
	/// - parameter alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0.
	/// Alpha values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0.
	convenience init( intRed: Int, green: Int, blue: Int, alpha: CGFloat = 1 ) {
		self.init( red: CGFloat( intRed ) / 255, green: CGFloat( green ) / 255, blue: CGFloat( blue ) / 255, alpha: alpha )
	}

	/// Returns a UIColor by scanning the string for a hex number.
	/// Skips any leading whitespace and ignores any trailing characters.
	convenience init?( hex: String, alpha: CGFloat = 1 ) {

		// Search for the first streak of six hexadecimal characters.
		let items = hex.components( separatedBy: UIColor.invertedHexCharactersSet )
		guard let hexString = items.first( where: { $0.count >= 6 } ) else { return nil }

		let colorString = hexString[..<hexString.index( hexString.startIndex, offsetBy: 6 ) ]

		let scanner = Scanner( string: String( colorString ))
		guard let hexNum = scanner.scanUInt64( representation: .hexadecimal ) else {
			return nil
		}
		self.init( hexNum, alpha: alpha )
	}

	private static let invertedHexCharactersSet = CharacterSet( charactersIn: "0123456789abcdefABCDEF" ).inverted


	/// Returns random color with supplied alpha.
	convenience init( randomWithAlpha alpha: CGFloat ) {
		let randomRed = Int( arc4random_uniform( 256 ) )
		let randomGreen = Int( arc4random_uniform( 256 ) )
		let randomBlue = Int( arc4random_uniform( 256 ) )
		self.init( intRed: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha )
	}

	convenience init( _ int: UInt32, alpha: CGFloat = 1 ) {
		let red = Int( ( int >> 16 ) & 0xFF )
		let green = Int( ( int >> 8 ) & 0xFF )
		let blue = Int( int & 0xFF )

		self.init( intRed: red, green: green, blue: blue, alpha: alpha )
	}
	convenience init( _ int: UInt64, alpha: CGFloat = 1 ) {
		self.init( UInt32( int ), alpha: alpha )
	}



	@available( *, deprecated, renamed: "init(_:alpha:)" )
	convenience init( int: UInt32, alpha: CGFloat = 1 ) {
		self.init( int, alpha: alpha )
	}
}

public extension UIColor {

	/// Returns contrast color for the receiver.
	/// - returns: Either black or white color, depending on lightness of the receiver.
	var contrastColor: UIColor {
		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0

		getRed(&red, green: &green, blue: &blue, alpha: &alpha )
		let lightness = ( red + green + blue ) / 3
		return lightness > 0.5 ? .black : .white
	}
}

public extension UIColor {

	/// Returns an alpha value of the receiver.
	var alpha: CGFloat {
		var alpha: CGFloat = 1
		self.getWhite( nil, alpha: &alpha )
		return alpha
	}
}


public extension UIColor {

	/// Returns white color with specified alpha value.
	static func white( _ alpha: CGFloat ) -> UIColor {
		UIColor( white: 1, alpha: alpha )
	}

	/// Returns black color with specified alpha value.
	static func black( _ alpha: CGFloat ) -> UIColor {
		UIColor( white: 0, alpha: alpha )
	}

	/// Returns gray color with specified shade and alpha.
	static func gray( _ white: CGFloat, alpha: CGFloat = 1 ) -> UIColor {
		UIColor( white: white, alpha: alpha )
	}

	/// Returns gray color with specified shade and alpha.
	static func iGray( _ white: Int, alpha: CGFloat = 1 ) -> UIColor {
		UIColor( white: CGFloat( white ) / 255 , alpha: alpha )
	}
}
#endif
