//
//  UIColor+Defaults.swift
//
//  Created by Vladimir Kazantsev on 24.11.14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

extension UIColor {
	
	convenience init( intRed: Int, intGreen: Int, intBlue: Int, alpha: CGFloat ) {
		self.init( red: CGFloat( intRed ) / 255, green: CGFloat( intGreen ) / 255, blue: CGFloat( intBlue ) / 255, alpha: alpha )
	}
	
	/// Returns a UIColor by scanning the string for a hex number.
	/// Skips any leading whitespace and ignores any trailing characters.
	convenience init?( hex: String, alpha: CGFloat = 1 ) {

		// Search for the first streak of six hexadecimal characters.
		let items = hex.components( separatedBy: UIColor.invertedHexCharactersSet )
		guard let hexString = items.element( where: { $0.characters.count >= 6 } ) else { return nil }
		
		let colorString = hexString.substring( to: hexString.characters.index( hexString.startIndex, offsetBy: 6 ))

		let scanner = Scanner( string: colorString )
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
		self.init( intRed: randomRed, intGreen: randomGreen, intBlue: randomBlue, alpha: alpha )
	}
	
	
	fileprivate convenience init( int: UInt32, alpha: CGFloat = 1 ) {
		
		let r = CGFloat(( int >> 16 ) & 0xFF )
		let g = CGFloat(( int >> 8 ) & 0xFF )
		let b = CGFloat( int & 0xFF )
		
		self.init( red: r / 255, green: g / 255, blue: b / 255, alpha: alpha )
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
