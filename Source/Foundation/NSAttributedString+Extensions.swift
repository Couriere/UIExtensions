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


public extension NSAttributedString {
	
	/// Returns mutable copy of NSAttributedString.
	public func mutable() -> NSMutableAttributedString {
		return NSMutableAttributedString( attributedString: self )
	}
	/// Return range, that covers all attributed string.
	public var wholeRange: NSRange { return NSMakeRange( 0, self.length ) }
	
	/// Returns a copy of an attributed string with requested attributes.
	public func addingAttributes( _ attributes: [ NSAttributedString.Key: AnyObject ] ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttributes( attributes, range: wholeRange )
		return mutable
	}
	
	/// Returns a copy of an attributed string with `text color` attribute set.
	public func settingColor( _ color: UIColor ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttribute( .foregroundColor, value: color, range: wholeRange )
		return mutable
	}
	
	/// Returns a copy of an attributed string with `text font` attribute set.
	public func settingFont( _ font: UIFont ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttribute( .font, value: font, range: wholeRange )
		return mutable
	}
	
	/// Returns a copy of an attributed string with `kern` attribute set.
	public func settingKern( _ kern: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttribute( .kern, value: kern, range: wholeRange )
		return mutable
	}
	
	/// Returns a copy of an attributed string with `striketrough style and color` attributes set.
	public func settingStrikethroughStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttributes( [ .strikethroughStyle: style.rawValue, .strikethroughColor: color as Any ], range: wholeRange )
		return mutable
	}
	
	/// Returns a copy of an attributed string with `underline style and color` attributes set.
	public func settingUnderlineStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttributes( [ .underlineStyle: style.rawValue, .underlineColor: color as Any ], range: wholeRange )
		return mutable
	}
	
	/// Returns a copy of an attributed string with `paragraphStyle` attribute set.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	public func settingParagraphStyle( _ paragraphStyle: NSParagraphStyle ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttribute( .paragraphStyle, value: paragraphStyle, range: wholeRange )
		return mutable
	}
	
	/// Returns a copy of an attributed string with `lineSpacing` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `lineSpacing` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	public func settingLineSpacing( _ lineSpacing: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable()
		let paragraph = mutable.paragraphStyle
		paragraph.lineSpacing = lineSpacing
		mutable.addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return mutable
	}
	
	/// Returns a copy of an attributed string with `lineHeightMultiple` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `lineHeightMultiple` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	public func settingLineHeightMultiple( _ multiple: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable()
		let paragraph = mutable.paragraphStyle
		paragraph.lineHeightMultiple = multiple
		mutable.addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return mutable
	}
	
	/// Returns a copy of an attributed string with `minimumLineHeight` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `minimumLineHeight` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	public func settingMinimumLineHeight( _ minimumLineHeight: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable()
		let paragraph = mutable.paragraphStyle
		paragraph.minimumLineHeight = minimumLineHeight
		mutable.addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return mutable
	}
	
	/// Returns a copy of an attributed string with `alignment` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `alignment` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	public func settingAlignment( _ alignment: NSTextAlignment ) -> NSAttributedString {
		let mutable = self.mutable()
		let paragraph = mutable.paragraphStyle
		paragraph.alignment = alignment
		mutable.addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return mutable
	}

	/// Returns a copy of an attributed string with `lineBreakMode` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `lineBreakMode` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	public func settingLineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> NSAttributedString {
		let mutable = self.mutable()
		let paragraph = mutable.paragraphStyle
		paragraph.lineBreakMode = lineBreakMode
		mutable.addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return mutable
	}
}

public extension NSMutableAttributedString {
	
	/// Sets new `text color` attribute over the whole string.
	@discardableResult
	public func color( _ color: UIColor ) -> Self {
		self.addAttribute( .foregroundColor, value: color, range: wholeRange )
		return self
	}
	
	/// Sets new `font` attribute over the whole string.
	@discardableResult
	public func font( _ font: UIFont ) -> Self {
		self.addAttribute( .font, value: font, range: wholeRange )
		return self
	}
	
	/// Sets new `kern` attribute over the whole string.
	@discardableResult
	public func kern( _ kern: CGFloat ) -> Self {
		self.addAttribute( .kern, value: kern, range: wholeRange )
		return self
	}
	
	/// Sets new `strikethrough style and color` attributes 		.
	@discardableResult
	public func strikethroughStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> Self {
		self.addAttributes( [ .strikethroughStyle: style.rawValue, .strikethroughColor: color as Any ], range: wholeRange )
		return self
	}
	
	/// Sets new `underline style and color` attributes over the whole string.
	@discardableResult
	public func underlineStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> Self {
		self.addAttributes( [ .underlineStyle: style.rawValue, .underlineColor: color as Any ], range: wholeRange )
		return self
	}
	
	/// Sets `paragraphStyle` attribute set over the whole string.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	public func paragraphStyle( _ paragraphStyle: NSParagraphStyle ) -> Self {
		self.addAttribute( .paragraphStyle, value: paragraphStyle, range: wholeRange )
		return self
	}
	
	/// Sets `lineSpacing` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `lineSpacing` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	public func lineSpacing( _ lineSpacing: CGFloat ) -> Self {
		let paragraph = self.paragraphStyle
		paragraph.lineSpacing = lineSpacing
		self.addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}
	
	/// Sets `lineHeightMultiple` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `lineHeightMultiple` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	public func lineHeightMultiple( _ multiple: CGFloat ) -> Self {
		let paragraph = self.paragraphStyle
		paragraph.lineHeightMultiple = multiple
		self.addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}
	
	/// Sets `minimumLineHeight` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `minimumLineHeight` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	public func minimumLineHeight( _ minimumLineHeight: CGFloat ) -> Self {
		let paragraph = self.paragraphStyle
		paragraph.minimumLineHeight = minimumLineHeight
		self.addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}
	
	/// Sets `alignment` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `alignment` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	public func alignment( _ alignment: NSTextAlignment ) -> Self {
		let paragraph = self.paragraphStyle
		paragraph.alignment = alignment
		self.addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}

	/// Sets `lineBreakMode` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `lineBreakMode` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	public func lineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> Self {
		let paragraph = self.paragraphStyle
		paragraph.lineBreakMode = lineBreakMode
		self.addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}

	/// Inserts image in attributed string at specified location.
	/// - parameter image: Image to insert in string.
	/// - parameter location: Location in string to insert. If `nil`, image will be appended to the string.
	/// - parameter verticalOffset: Offset in points, will be applied to image position.
	@discardableResult
	public func insertImage( _ image: UIImage, atLocation location: Int? = nil, verticalOffset: CGFloat = 0 ) -> Self {
		
		let textAttachment = NSTextAttachment()
		textAttachment.image = image
		let attrStringWithImage = NSAttributedString( attachment: textAttachment )
		
		let location = location ?? length
		let safeLocation = max( 0, min( self.length - 1, location ))
		#if os(tvOS)
			let systemFontSize: CGFloat = 29
		#else
			let systemFontSize: CGFloat = UIFont.systemFontSize
		#endif
		
		let font: UIFont = length > 0 ?
			attribute( .font, at: safeLocation, effectiveRange: nil ) as? UIFont ?? .systemFont( ofSize: systemFontSize ) :
			.systemFont( ofSize: systemFontSize )
		
		let mid = font.descender + font.capHeight
		textAttachment.bounds = CGRect( x: 0, y: font.descender - image.size.height / 2 + mid + 2 - verticalOffset,
										width: image.size.width + 1, height: image.size.height ).integral
		
		self.insert( attrStringWithImage, at: location )
		return self
	}
}

public extension String {
	
	public func withAttributes( _ attributes: [ NSAttributedString.Key: AnyObject ] ) -> NSMutableAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: attributes )
		return result
	}
	
	public func withColor( _ color: UIColor ) -> NSMutableAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ .foregroundColor: color ] )
		return result
	}
	
	public func withFont( _ font: UIFont ) -> NSMutableAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ .font: font ] )
		return result
	}
	
	public func withKern( _ kern: CGFloat ) -> NSMutableAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ .kern: kern ] )
		return result
	}
	
	public func withStrikethroughStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> NSMutableAttributedString {
		let result =
			NSMutableAttributedString( string: self,
									   attributes: [ .strikethroughStyle: style.rawValue, .strikethroughColor: color as Any ] )
		return result
	}
	
	public func withUnderlineStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> NSMutableAttributedString {
		let result =
			NSMutableAttributedString( string: self,
									   attributes: [ .underlineStyle: style.rawValue, .underlineColor: color as Any ] )
		return result
	}
	
	public func withParagraphStyle( _ paragraphStyle: NSParagraphStyle ) -> NSMutableAttributedString {
		let result =
			NSMutableAttributedString( string: self, attributes: [ .paragraphStyle: paragraphStyle ] )
		return result
	}
	
	public func withLineSpacing( _ lineSpacing: CGFloat ) -> NSMutableAttributedString {
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineSpacing = lineSpacing
		return withParagraphStyle( paragraph )
	}
	
	public func withLineHeightMultiple( _ multiple: CGFloat ) -> NSMutableAttributedString {
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineHeightMultiple = multiple
		return withParagraphStyle( paragraph )
	}
	
	public func withMinimumLineHeight( _ minimumLineHeight: CGFloat ) -> NSMutableAttributedString {
		let paragraph = NSMutableParagraphStyle()
		paragraph.minimumLineHeight = minimumLineHeight
		return withParagraphStyle( paragraph )
	}
	
	public func withAlignment( _ alignment: NSTextAlignment ) -> NSMutableAttributedString {
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = alignment
		return withParagraphStyle( paragraph )
	}

	public func withLineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> NSMutableAttributedString {
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineBreakMode = lineBreakMode
		return withParagraphStyle( paragraph )
	}

	/// Creates attributed string and inserts image in it at specified location.
	/// - parameter image: Image to insert in string.
	/// - parameter location: Location in string to insert. If `nil`, image will be appended to the string.
	/// - parameter verticalOffset: Offset in points, will be applied to image position.
	public func withImage( _ image: UIImage, atLocation location: Int? = nil, verticalOffset: CGFloat = 0 ) -> NSMutableAttributedString {
		return NSMutableAttributedString( string: self )
			.insertImage( image, atLocation: location, verticalOffset: verticalOffset )
	}
}




private extension NSAttributedString {
	var paragraphStyle: NSMutableParagraphStyle {
		
		guard length > 0,
			let currentStyle =
			self.attribute( .paragraphStyle, at: 0, longestEffectiveRange: nil, in: wholeRange ) as? NSParagraphStyle else {
				return NSMutableParagraphStyle()
		}
		
		return currentStyle.mutableCopy() as! NSMutableParagraphStyle
	}
}

