//
//  String+Extensions.swift
//
//  Created by Vladimir Kazantsev on 10.02.15.
//  Copyright (c) 2015. All rights reserved.
//

import Foundation

extension String {
	
	var length: Int { return self.characters.count }

	func rangeFromNSRange( range: NSRange ) -> Range<String.Index> {
		let startIndex = self.startIndex.advancedBy(range.location )
		return Range( start: startIndex, end: startIndex.advancedBy(range.length ))
	}
	
	/// Не учтиывает спецсимволы юникода
	func NSRangeFromRange( range: Range<String.Index> ) -> NSRange {
		let start = self.startIndex.distanceTo(range.startIndex)
		let length = range.startIndex.distanceTo(range.endIndex)
		return NSMakeRange( start, length )
	}
	
	func stringByReplacingCharactersInRange( range: NSRange, withString replacement: String ) -> String {
		var newString = self
		newString.replaceRange( newString.rangeFromNSRange( range ), with: replacement )
		return newString
	}
	
	var asPhoneNumber: String {
		let tendigits = substringFromIndex( endIndex.advancedBy(-10 ))
		let city = tendigits.substringWithRange( rangeFromNSRange( NSMakeRange( 0, 3 )))
		let triad = tendigits.substringWithRange( rangeFromNSRange( NSMakeRange( 3, 3 )))
		let firstpair = tendigits.substringWithRange( rangeFromNSRange( NSMakeRange( 6, 2 )))
		let secondpair = tendigits.substringWithRange( rangeFromNSRange( NSMakeRange( 8, 2 )))
		
		return "+7 \( city ) \( triad ) \( firstpair ) \( secondpair )"
	}
	
	var digitsOnly: String {
		get {
			let range = Range<String.Index>( start: startIndex, end: endIndex )
			return stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: range )
		}
	}
	
	var phoneNumber: String {
		get {
			let number = digitsOnly
			let PhoneNumberLength = 10
			let index = number.length - PhoneNumberLength
			if index <= 0 { return number }
			
			return number.substringFromIndex( number.startIndex.advancedBy(index ) )
		}
	}

	var rub: String { return self + "₽" }
}