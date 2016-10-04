//
//  NSAttributedString+Extensions.swift
//
//  Created by Vladimir Kazantsev on 19/11/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

public func +( left: NSAttributedString, right: NSAttributedString ) -> NSAttributedString {
	let mutable = NSMutableAttributedString( attributedString: left )
	mutable.append( right )
	return mutable
}

extension NSMutableAttributedString {
	
	/// Вставляет изображение в строку и устанавливает его
	/// вертикально в центр строки.
	func insertImage( _ image: UIImage, atLocation location: Int, verticalOffset: CGFloat = 0 ) {
		
		let textAttachment = NSTextAttachment()
		textAttachment.image = image
		let attrStringWithImage = NSAttributedString( attachment: textAttachment )
		
		let safeLocation = max( 0, min( self.length - 1, location ))
		let font = attribute( NSFontAttributeName, at: safeLocation, effectiveRange: nil ) as? UIFont ?? UIFont.systemFont( ofSize: UIFont.systemFontSize )
		let mid = font.descender + font.capHeight
		textAttachment.bounds = CGRect( x: 0, y: font.descender - image.size.height / 2 + mid + 2 - verticalOffset,
				width: image.size.width + 1, height: image.size.height ).integral
		
		self.insert( attrStringWithImage, at: location )
	}
}


extension NSAttributedString {
	
	func setAttributes( _ attributes: [ String: AnyObject ] ) -> NSAttributedString {
		let mutable = self is NSMutableAttributedString ?
			self as! NSMutableAttributedString : NSMutableAttributedString( attributedString: self )
		let range = NSMakeRange( 0, mutable.length )
		mutable.addAttributes( attributes, range: range )
		return mutable
	}
	
	func color( _ color: UIColor ) -> NSAttributedString {
		
		let mutable = self is NSMutableAttributedString ?
			self as! NSMutableAttributedString : NSMutableAttributedString( attributedString: self )
		let range = NSMakeRange( 0, mutable.length )
		mutable.addAttribute( NSForegroundColorAttributeName, value: color, range: range )
		return mutable
	}
	
	func font( _ font: UIFont ) -> NSAttributedString {
		let mutable = self is NSMutableAttributedString ?
			self as! NSMutableAttributedString : NSMutableAttributedString( attributedString: self )
		let range = NSMakeRange( 0, mutable.length )
		mutable.addAttribute( NSFontAttributeName, value: font, range: range )
		return mutable
	}
	
}

extension String {
	
	func setAttributes( _ attributes: [ String: AnyObject ] ) -> NSAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: attributes )
		return result
	}
	

	func color( _ color: UIColor ) -> NSAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ NSForegroundColorAttributeName: color ] )
		return result
	}
	
	func font( _ font: UIFont ) -> NSAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ NSFontAttributeName: font ] )
		return result
	}
}
