//
//  NSAttributedString+Extensions.swift
//
//  Created by Vladimir Kazantsev on 19/11/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

extension NSAttributedString {
	
	func color( color: UIColor ) -> NSAttributedString {
		
		let mutable = self is NSMutableAttributedString ?
			self as! NSMutableAttributedString : NSMutableAttributedString( attributedString: self )
		let range = NSMakeRange( 0, mutable.length )
		mutable.addAttribute( NSForegroundColorAttributeName, value: color, range: range )
		return mutable
	}
	
	func font( font: UIFont ) -> NSAttributedString {
		let mutable = self is NSMutableAttributedString ?
			self as! NSMutableAttributedString : NSMutableAttributedString( attributedString: self )
		let range = NSMakeRange( 0, mutable.length )
		mutable.addAttribute( NSFontAttributeName, value: font, range: range )
		return mutable
	}
	
}

extension String {
	
	func color( color: UIColor ) -> NSAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ NSForegroundColorAttributeName: color ] )
		return result
	}
	
	func font( font: UIFont ) -> NSAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ NSFontAttributeName: font ] )
		return result
	}
}