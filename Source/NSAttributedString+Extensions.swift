//
//  NSAttributedString+Extensions.swift
//
//  Created by Vladimir Kazantsev on 19/11/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

public func +( left: NSAttributedString, right: NSAttributedString ) -> NSAttributedString {
	let mutable = left.mutable()
	mutable.append( right )
	return mutable
}

public extension NSMutableAttributedString {
	
	/// Вставляет изображение в строку и устанавливает его
	/// вертикально в центр строки.
	func insertImage( _ image: UIImage, atLocation location: Int, verticalOffset: CGFloat = 0 ) {
		
		let textAttachment = NSTextAttachment()
		textAttachment.image = image
		let attrStringWithImage = NSAttributedString( attachment: textAttachment )
		
		let safeLocation = max( 0, min( self.length - 1, location ))
		#if os(tvOS)
			let systemFontSize: CGFloat = 12
		#else
			let systemFontSize = UIFont.systemFontSize
		#endif
		let font = attribute( .font, at: safeLocation, effectiveRange: nil ) as? UIFont ?? UIFont.systemFont( ofSize: systemFontSize )
		let mid = font.descender + font.capHeight
		textAttachment.bounds = CGRect( x: 0, y: font.descender - image.size.height / 2 + mid + 2 - verticalOffset,
				width: image.size.width + 1, height: image.size.height ).integral
		
		self.insert( attrStringWithImage, at: location )
	}
}


public extension NSAttributedString {

	func mutable() -> NSMutableAttributedString {
		return self as? NSMutableAttributedString ?? NSMutableAttributedString( attributedString: self )
	}

	func setAttributes( _ attributes: [ NSAttributedStringKey: AnyObject ] ) -> NSAttributedString {
		
		let mutable = self.mutable()
		let range = NSMakeRange( 0, mutable.length )
		mutable.addAttributes( attributes, range: range )
		return mutable
	}

	func color( _ color: UIColor ) -> NSAttributedString {
		
		let mutable = self.mutable()
		let range = NSMakeRange( 0, mutable.length )
		mutable.addAttribute( .foregroundColor, value: color, range: range )
		return mutable
	}

	func font( _ font: UIFont ) -> NSAttributedString {
		
		let mutable = self.mutable()
		let range = NSMakeRange( 0, mutable.length )
		mutable.addAttribute( .font, value: font, range: range )
		return mutable
	}
}

public extension String {
	
	func setAttributes( _ attributes: [ NSAttributedStringKey: AnyObject ] ) -> NSAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: attributes )
		return result
	}
	

	func color( _ color: UIColor ) -> NSAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ .foregroundColor: color ] )
		return result
	}
	
	func font( _ font: UIFont ) -> NSAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ .font: font ] )
		return result
	}
}
