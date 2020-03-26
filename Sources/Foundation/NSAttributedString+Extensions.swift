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

import UIKit

public func + ( left: NSAttributedString, right: NSAttributedString ) -> NSAttributedString {
	let mutable = left.mutable()
	mutable.append( right )
	return mutable
}

public extension NSAttributedString {

	/// Converts HTML string to NSAttributed string.
	convenience init( htmlString: String ) throws {

		try self.init( data: Data( htmlString.utf8 ),
		               options: [ .documentType: NSAttributedString.DocumentType.html,
		                          .characterEncoding: String.Encoding.utf8.rawValue ],
		               documentAttributes: nil )
	}
}

public extension NSAttributedString {

	/// Returns mutable copy of NSAttributedString.
	func mutable() -> NSMutableAttributedString {
		return NSMutableAttributedString( attributedString: self )
	}

	/// Return range, that covers all attributed string.
	var wholeRange: NSRange { return NSMakeRange( 0, length ) }

	/// Returns a copy of an attributed string with requested attributes.
	func addingAttributes( _ attributes: [ NSAttributedString.Key: AnyObject ] ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttributes( attributes, range: wholeRange )
		return mutable
	}

	/// Returns a copy of an attributed string with `text color` attribute set.
	func settingColor( _ color: UIColor ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttribute( .foregroundColor, value: color, range: wholeRange )
		return mutable
	}

	/// Returns a copy of an attributed string with `text font` attribute set.
	func settingFont( _ font: UIFont ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttribute( .font, value: font, range: wholeRange )
		return mutable
	}

	/// Returns a copy of an attributed string with `kern` attribute set.
	func settingKern( _ kern: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttribute( .kern, value: kern, range: wholeRange )
		return mutable
	}

	/// Returns a copy of an attributed string with `baselineOffset` attributes set.
	func settingBaselineOffset( _ offset: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttribute( .baselineOffset, value: offset, range: wholeRange )
		return mutable
	}

	/// Returns a copy of an attributed string with `striketrough style and color` attributes set.
	func settingStrikethroughStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> NSAttributedString {
		let attributes: [ NSAttributedString.Key: Any? ] = [ .strikethroughStyle: style.rawValue,
															 .strikethroughColor: color ]
		let mutable = self.mutable()
		mutable.addAttributes( attributes.sanitized, range: wholeRange )
		return mutable
	}

	/// Returns a copy of an attributed string with `underline style and color` attributes set.
	func settingUnderlineStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> NSAttributedString {
		let attributes: [ NSAttributedString.Key: Any? ] = [ .underlineStyle: style.rawValue,
															 .underlineColor: color ]
		let mutable = self.mutable()
		mutable.addAttributes( attributes.sanitized, range: wholeRange )
		return mutable
	}


	/// Returns a copy of an attributed string with `paragraphStyle` attribute set.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	func settingParagraphStyle( _ paragraphStyle: NSParagraphStyle ) -> NSAttributedString {
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
	func settingLineSpacing( _ lineSpacing: CGFloat ) -> NSAttributedString {
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
	func settingLineHeightMultiple( _ multiple: CGFloat ) -> NSAttributedString {
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
	func settingMinimumLineHeight( _ minimumLineHeight: CGFloat ) -> NSAttributedString {
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
	func settingAlignment( _ alignment: NSTextAlignment ) -> NSAttributedString {
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
	func settingLineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> NSAttributedString {
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
	func color( _ color: UIColor ) -> Self {
		addAttribute( .foregroundColor, value: color, range: wholeRange )
		return self
	}

	/// Sets new `font` attribute over the whole string.
	@discardableResult
	func font( _ font: UIFont ) -> Self {
		addAttribute( .font, value: font, range: wholeRange )
		return self
	}

	/// Sets new `kern` attribute over the whole string.
	@discardableResult
	func kern( _ kern: CGFloat ) -> Self {
		addAttribute( .kern, value: kern, range: wholeRange )
		return self
	}

	/// Sets new `baselineOffset` attribute over the whole string.
	@discardableResult
	func baselineOffset( _ offset: CGFloat ) -> Self {
		addAttribute( .baselineOffset, value: offset, range: wholeRange )
		return self
	}

	/// Sets new `strikethrough style and color` attributes over the whole string.
	@discardableResult
	func strikethroughStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> Self {
		let attributes: [ NSAttributedString.Key: Any? ] = [ .strikethroughStyle: style.rawValue,
															 .strikethroughColor: color ]
		addAttributes( attributes.sanitized, range: wholeRange )
		return self
	}

	/// Sets new `underline style and color` attributes over the whole string.
	@discardableResult
	func underlineStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> Self {
		let attributes: [ NSAttributedString.Key: Any? ] = [ .underlineStyle: style.rawValue,
															 .underlineColor: color ]
		addAttributes( attributes.sanitized, range: wholeRange )
		return self
	}


	/// Sets `paragraphStyle` attribute set over the whole string.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	func paragraphStyle( _ paragraphStyle: NSParagraphStyle ) -> Self {
		addAttribute( .paragraphStyle, value: paragraphStyle, range: wholeRange )
		return self
	}

	/// Sets `lineSpacing` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `lineSpacing` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	func lineSpacing( _ lineSpacing: CGFloat ) -> Self {
		let paragraph = paragraphStyle
		paragraph.lineSpacing = lineSpacing
		addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}

	/// Sets `lineHeightMultiple` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `lineHeightMultiple` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	func lineHeightMultiple( _ multiple: CGFloat ) -> Self {
		let paragraph = paragraphStyle
		paragraph.lineHeightMultiple = multiple
		addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}

	/// Sets `minimumLineHeight` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `minimumLineHeight` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	func minimumLineHeight( _ minimumLineHeight: CGFloat ) -> Self {
		let paragraph = paragraphStyle
		paragraph.minimumLineHeight = minimumLineHeight
		addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}

	/// Sets `alignment` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `alignment` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	func alignment( _ alignment: NSTextAlignment ) -> Self {
		let paragraph = paragraphStyle
		paragraph.alignment = alignment
		addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}

	/// Sets `lineBreakMode` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `lineBreakMode` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@discardableResult
	func lineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> Self {
		let paragraph = paragraphStyle
		paragraph.lineBreakMode = lineBreakMode
		addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}

	/// Inserts image in attributed string at specified location.
	/// - parameter image: Image to insert in string.
	/// - parameter location: Location in string to insert. If `nil`, image will be appended to the string.
	/// - parameter verticalOffset: Offset in points, will be applied to image position.
	@discardableResult
	func insertImage( _ image: UIImage, atLocation location: Int? = nil, verticalOffset: CGFloat = 0 ) -> Self {

		let textAttachment = NSTextAttachment()
		textAttachment.image = image
		let attrStringWithImage = NSAttributedString( attachment: textAttachment )

		let location = location ?? length
		let safeLocation = max( 0, min( length - 1, location ))
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

		insert( attrStringWithImage, at: location )
		return self
	}
}

public extension String {

	func withAttributes( _ attributes: [ NSAttributedString.Key: AnyObject ] ) -> NSMutableAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: attributes )
		return result
	}

	func withColor( _ color: UIColor ) -> NSMutableAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ .foregroundColor: color ] )
		return result
	}

	func withFont( _ font: UIFont ) -> NSMutableAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ .font: font ] )
		return result
	}

	func withKern( _ kern: CGFloat ) -> NSMutableAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ .kern: kern ] )
		return result
	}

	func withBaselineOffset( _ offset: CGFloat ) -> NSMutableAttributedString {
		let result = NSMutableAttributedString( string: self, attributes: [ .baselineOffset: offset ] )
		return result
	}

	func withStrikethroughStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> NSMutableAttributedString {
		let attributes: [ NSAttributedString.Key: Any? ] = [ .strikethroughStyle: style.rawValue,
															 .strikethroughStyle: color ]
		let result = NSMutableAttributedString( string: self, attributes: attributes.sanitized )
		return result
	}

	func withUnderlineStyle( _ style: NSUnderlineStyle, color: UIColor? = nil ) -> NSMutableAttributedString {
		let attributes: [ NSAttributedString.Key: Any? ] = [ .underlineStyle: style.rawValue,
															 .underlineColor: color ]
		let result =
			NSMutableAttributedString( string: self, attributes: attributes.sanitized )
		return result
	}

	func withParagraphStyle( _ paragraphStyle: NSParagraphStyle ) -> NSMutableAttributedString {
		let result =
			NSMutableAttributedString( string: self, attributes: [ .paragraphStyle: paragraphStyle ] )
		return result
	}

	func withLineSpacing( _ lineSpacing: CGFloat ) -> NSMutableAttributedString {
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineSpacing = lineSpacing
		return withParagraphStyle( paragraph )
	}

	func withLineHeightMultiple( _ multiple: CGFloat ) -> NSMutableAttributedString {
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineHeightMultiple = multiple
		return withParagraphStyle( paragraph )
	}

	func withMinimumLineHeight( _ minimumLineHeight: CGFloat ) -> NSMutableAttributedString {
		let paragraph = NSMutableParagraphStyle()
		paragraph.minimumLineHeight = minimumLineHeight
		return withParagraphStyle( paragraph )
	}

	func withAlignment( _ alignment: NSTextAlignment ) -> NSMutableAttributedString {
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = alignment
		return withParagraphStyle( paragraph )
	}

	func withLineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> NSMutableAttributedString {
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineBreakMode = lineBreakMode
		return withParagraphStyle( paragraph )
	}

	/// Creates attributed string and inserts image in it at specified location.
	/// - parameter image: Image to insert in string.
	/// - parameter location: Location in string to insert. If `nil`, image will be appended to the string.
	/// - parameter verticalOffset: Offset in points, will be applied to image position.
	func withImage( _ image: UIImage, atLocation location: Int? = nil, verticalOffset: CGFloat = 0 ) -> NSMutableAttributedString {
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

