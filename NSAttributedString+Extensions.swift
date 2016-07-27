//
//  NSAttributedString+Extensions.swift
//
//  Created by Vladimir Kazantsev on 19/11/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

public func +( left: NSAttributedString, right: NSAttributedString ) -> NSAttributedString {
	let mutable = NSMutableAttributedString( attributedString: left )
	mutable.appendAttributedString( right )
	return mutable
}

extension NSMutableAttributedString {
	
	/// Вставляет изображение в строку и устанавливает его
	/// вертикально в центр строки.
	func insertImage( image: UIImage, atLocation location: Int, verticalOffset: CGFloat = 0 ) {
		
		let textAttachment = NSTextAttachment()
		textAttachment.image = image
		let attrStringWithImage = NSAttributedString( attachment: textAttachment )
		
		let safeLocation = max( 0, min( self.length - 1, location ))
		let font = attribute( NSFontAttributeName, atIndex: safeLocation, effectiveRange: nil ) as? UIFont ?? UIFont.systemFontOfSize( UIFont.systemFontSize() )
		let mid = font.descender + font.capHeight
		textAttachment.bounds = CGRectIntegral(
			CGRect( x: 0, y: font.descender - image.size.height / 2 + mid + 2 - verticalOffset,
				width: image.size.width, height: image.size.height ))
		
		self.insertAttributedString( attrStringWithImage, atIndex: location )
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