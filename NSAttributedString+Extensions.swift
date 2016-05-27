//
//  NSAttributedString+Extensions.swift
//
//  Created by Vladimir Kazantsev on 19/11/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
	
	/// Вставляет изображение в строку и устанавливает его
	/// вертикально в центр строки.
	func insertImage( image: UIImage, atLocation location: Int ) {
		
		let textAttachment = NSTextAttachment()
		textAttachment.image = image
		let attrStringWithImage = NSAttributedString( attachment:textAttachment )
		
		let font = attribute( NSFontAttributeName, atIndex: location, effectiveRange: nil ) as? UIFont ?? UIFont.systemFontOfSize( UIFont.systemFontSize() )
		let mid = font.descender + font.capHeight
		textAttachment.bounds = CGRectIntegral(
			CGRect( x: 0, y: font.descender - image.size.height / 2 + mid + 2,
				width: image.size.width, height: image.size.height ))
		
		self.replaceCharactersInRange( NSMakeRange( location, 0 ), withAttributedString: attrStringWithImage )
	}
}


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