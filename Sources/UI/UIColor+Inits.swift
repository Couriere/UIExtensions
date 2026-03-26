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

#if canImport(UIKit)
import UIKit
public typealias NativeColor = UIColor
#elseif canImport(AppKit)
import AppKit
public typealias NativeColor = NSColor
#endif

extension NativeColor {

	/// Initializes and returns a color object using the specified opacity and Int RGB component values.
	/// - parameter intRed: The red value of the color object, specified as a value from 0 to 255.
	/// - parameter green: The red value of the color object, specified as a value from 0 to 255.
	/// - parameter blue: The red value of the color object, specified as a value from 0 to 255.
	/// - parameter alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0.
	/// Alpha values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0.
	public convenience init( intRed: Int, green: Int, blue: Int, alpha: Double = 1 ) {
		self.init(
			red: Double( intRed ) / 255,
			green: Double( green ) / 255,
			blue: Double( blue ) / 255,
			alpha: alpha
		)
	}

	/// Returns random color with supplied alpha.
	public convenience init( randomWithAlpha alpha: CGFloat ) {
		let randomRed = Int( arc4random_uniform( 256 ) )
		let randomGreen = Int( arc4random_uniform( 256 ) )
		let randomBlue = Int( arc4random_uniform( 256 ) )
		self.init( intRed: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha )
	}

	/// Initializes a color from a `UInt64` integer, extracting the red, green,
	/// and blue components from the integer. The `alpha` component is optional
	/// and defaults to 1.
	/// - Parameters:
	///   - int: A `UInt64` integer representing a color in RGB format.
	///   - alpha: An optional alpha value, defaulting to 1.
	public convenience init( _ int: Int, alpha: Double = 1 ) {
		let red = Int( ( int >> 16 ) & 0xFF )
		let green = Int( ( int >> 8 ) & 0xFF )
		let blue = Int( int & 0xFF )

		self.init( intRed: red, green: green, blue: blue, alpha: alpha )
	}

	/// Initializes a color object using an integer representing RGBA values.
	/// - Parameter rgba: Integer representing RGBA components. The first
	///   byte is red, the second is green, the third is blue, and the last
	///   byte is alpha.
	public convenience init( rgba: Int ) {
		let red = Int( ( rgba >> 24 ) & 0xFF )
		let green = Int( ( rgba >> 16 ) & 0xFF )
		let blue = Int( ( rgba >> 8 ) & 0xFF )
		let alpha = Double( rgba & 0xFF ) / 0xFF

		self.init( intRed: red, green: green, blue: blue, alpha: alpha )
	}


	@available( *, deprecated, renamed: "init(_:alpha:)" )
	public convenience init( int: UInt32, alpha: CGFloat = 1 ) {
		self.init( Int( int ), alpha: alpha )
	}
}

#if canImport(UIKit) && !os(watchOS)
extension NativeColor {

	/// Initializes a dynamic color that adapts to the system appearance.
	///
	/// This initializer returns `light` color when the user interface style is
	/// light (or unspecified) and `dark` color when the user interface style is dark.
	///
	/// - Parameters:
	///   - light: The color to use in light mode (and when the style is unspecified).
	///   - dark: The color to use in dark mode.
	public convenience init(
		light: NativeColor,
		dark: NativeColor
	) {

		self.init(
			dynamicProvider: { traits in
				switch traits.userInterfaceStyle {
				case .light, .unspecified: light
				case .dark: dark
				@unknown default: light
				}
			}
		)
	}
}
#elseif canImport(AppKit)
extension NativeColor {

	/// Initializes a dynamic color that adapts to the system appearance.
	///
	/// This initializer returns `light` color when the system appearance is
	/// light (or unspecified) and `dark` color when the system appearance is dark.
	///
	/// - Parameters:
	///   - light: The color to use in light mode (and when the style is unspecified).
	///   - dark: The color to use in dark mode.
	public convenience init(
		light: NativeColor,
		dark: NativeColor
	) {

		self.init(
			name: nil,
			dynamicProvider: { appearance in
				if appearance.bestMatch( from: [.aqua, .darkAqua] ) == .darkAqua {
					dark
				} else {
					light
				}
			}
		)
	}
}
#endif

public extension NativeColor {

	/// Initializes a color object by scanning the string for a hex number.
	///
	/// Searches the string for the first continuous sequence of 6 or 8
	/// hexadecimal characters and interprets it as an RGB or RGBA color value.
	/// Non-hex characters (including `#`, spaces, etc.) are automatically stripped.
	///
	/// - For a **6-character** hex string (`RRGGBB`), the `alpha` parameter
	///   is used as the color's opacity.
	/// - For an **8-character** hex string (`RRGGBBAA`), the alpha component
	///   is extracted from the last two characters and the `alpha` parameter is **ignored**.
	///
	/// - Parameters:
	///   - hex: A string containing a hex color value (e.g. `"#FF8800"`, `"FF8800CC"`).
	///   - alpha: The opacity value for 6-character hex strings, from 0.0 to 1.0.
	///            Ignored when the hex string contains 8 characters. Defaults to 1.
	/// - Returns: `nil` if no valid 6- or 8-character hex sequence is found in the string.
	convenience init?( hex: String, alpha: Double = 1 ) {

		// Search for the first streak of six hexadecimal characters.
		let items = hex.components( separatedBy: NativeColor.invertedHexCharactersSet )
		guard let hexString = items.first( where: { $0.count.isIn( 6, 8 ) } ) else { return nil }

		let scanner = Scanner( string: hexString.string )
		guard let hexNum = scanner.scanInt( representation: .hexadecimal ) else {
			return nil
		}
		if hexString.count == 8 {
			self.init( rgba: hexNum )
		} else {
			self.init( hexNum, alpha: alpha )
		}
	}

	/// Returns the color in HEX format as `#rrggbb`.
	/// If the color cannot be represented in RGB, it defaults to `#000000`.
	var hexRGB: String {
		hexRGBA.dropLast( 2 ).string
	}

	/// Returns the color in HEX format as `#rrggbbaa`.
	/// If the color cannot be represented in RGB, it defaults to `#00000000`.
	var hexRGBA: String {
		var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
#if canImport( UIKit )
		guard getRed( &r, green: &g, blue: &b, alpha: &a ) else { return "#000000" }
#else
		getRed( &r, green: &g, blue: &b, alpha: &a )
#endif

		return String(
			format: "#%02X%02X%02X%02X",
			Int((r * 255).rounded()), Int((g * 255).rounded()), Int((b * 255).rounded()), Int((a * 255).rounded())
		)
	}

	private static let invertedHexCharactersSet = CharacterSet( charactersIn: "0123456789abcdefABCDEF" ).inverted
}


extension NativeColor {

	/// Calculates the contrast color scheme based
	/// on the luminance of the receiver.
	///
	/// - Returns: A `ColorScheme` value indicating whether
	/// the contrast color should be `.light` or `.dark`.
	public var contrastScheme: ColorScheme {

		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0

		#if canImport(AppKit)
		guard let rgbColor = self.usingColorSpace(.deviceRGB) else {
			return .light
		}
		rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		#else
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		#endif

		let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
		return luminance > 0.5 ? .dark : .light
	}

	/// Replaces the receiver's color with a contrast
	/// color based on its lightness.
	///
	/// This method allows customization of the light
	/// and dark contrast colors. It determines whether
	/// the receiver is light or dark using
	/// the ``contrastScheme`` property.
	///
	/// - Parameters:
	///   - light: The color to use as the contrast color
	///   when the receiver is light.
	///   - dark: The color to use as the contrast color
	///   when the receiver is dark.
	/// - Returns: The contrast color chosen based on the receiver's lightness.
	public func replaceWithContrastColor(
		light: NativeColor,
		dark: NativeColor
	) -> NativeColor {
		contrastScheme == .light ? light : dark
	}

	/// Returns a contrast color for the receiver.
	///
	/// The contrast color is determined based on the
	/// lightness of the receiver.
	/// If the receiver is light, the contrast color will be black;
	/// if dark, the contrast color will be white.
	///
	/// - Returns: Either black or white color, depending on the lightness of the receiver.
	public var contrastColor: NativeColor {
		replaceWithContrastColor( light: .white, dark: .black )
	}
}

public extension NativeColor {

	/// Returns an alpha value of the receiver.
	var alpha: Double {

#if canImport( UIKit )
		var alpha: CGFloat = 1
		self.getWhite( nil, alpha: &alpha )
		return alpha
#else
		alphaComponent
#endif
	}
}


public extension NativeColor {

	/// Returns white color with specified alpha value.
	static func white( _ alpha: CGFloat ) -> NativeColor {
		NativeColor( white: 1, alpha: alpha )
	}

	/// Returns black color with specified alpha value.
	static func black( _ alpha: CGFloat ) -> NativeColor {
		NativeColor( white: 0, alpha: alpha )
	}

	/// Returns gray color with specified shade and alpha.
	static func gray( _ white: CGFloat, alpha: CGFloat = 1 ) -> NativeColor {
		NativeColor( white: white, alpha: alpha )
	}

	/// Returns gray color with specified shade and alpha.
	static func iGray( _ white: Int, alpha: CGFloat = 1 ) -> NativeColor {
		NativeColor( white: CGFloat( white ) / 255 , alpha: alpha )
	}
}
