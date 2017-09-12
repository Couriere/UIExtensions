//
//  UIColor+Defaults.swift
//
//  Created by Vladimir Kazantsev on 24.11.14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

extension UIColor {

	convenience init( intRed: Int, green: Int, blue: Int, alpha: CGFloat = 1 ) {
		self.init( red: CGFloat( intRed ) / 255, green: CGFloat( green ) / 255, blue: CGFloat( blue ) / 255, alpha: alpha )
	}

	/// Returns a UIColor by scanning the string for a hex number.
	/// Skips any leading whitespace and ignores any trailing characters.
	convenience init?( hex: String, alpha: CGFloat = 1 ) {

		// Search for the first streak of six hexadecimal characters.
		let items = hex.components( separatedBy: UIColor.invertedHexCharactersSet )
		guard let hexString = items.first( where: { $0.characters.count >= 6 } ) else { return nil }

		let colorString = hexString[ ..<hexString.index( hexString.startIndex, offsetBy: 6 ) ]

		let scanner = Scanner( string: String( colorString ))
		var hexNum: UInt32 = 0

		guard scanner.scanHexInt32( &hexNum ) else { return nil }
		self.init( int: hexNum, alpha: alpha )
	}
	private static let invertedHexCharactersSet = CharacterSet( charactersIn: "0123456789abcdefABCDEF" ).inverted

	/// Returns random color with supplied alpha.
	convenience init( randomWithAlpha alpha: CGFloat ) {
		let randomRed = Int( arc4random_uniform( 256 ) )
		let randomGreen = Int( arc4random_uniform( 256 ) )
		let randomBlue = Int( arc4random_uniform( 256 ) )
		self.init( intRed: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha )
	}


	private convenience init( int: UInt32, alpha: CGFloat = 1 ) {

		let red = Int( ( int >> 16 ) & 0xFF )
		let green = Int( ( int >> 8 ) & 0xFF )
		let blue = Int( int & 0xFF )

		self.init( intRed: red, green: green, blue: blue, alpha: alpha )
	}
}

extension UIColor {

	/// Returns contrast color to receivers one.
	var contrast: UIColor {
		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0

		getRed( &red, green: &green, blue: &blue, alpha: &alpha )
		let lightness = ( red + green + blue ) / 3
		return lightness > 0.5 ? .black : .white
	}
}
