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

#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

public extension NSAttributedString {

	static func +( left: NSAttributedString, right: NSAttributedString ) -> NSAttributedString {
		let mutable = left.mutable()
		mutable.append( right )
		return mutable
	}

	static func +=( left: NSAttributedString, right: NSAttributedString ) -> NSAttributedString {
		let mutable = left.mutable()
		mutable.append( right )
		return mutable
	}
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
	@inlinable
	func mutable() -> NSMutableAttributedString {
		return NSMutableAttributedString( attributedString: self )
	}

	/// Return range, that covers all attributed string.
	var wholeRange: NSRange { return NSMakeRange( 0, length ) }

	/// Returns a copy of an attributed string with requested attributes.
	func addingAttributes( _ attributes: [ NSAttributedString.Key: Any ] ) -> NSAttributedString {
		let mutable = self.mutable()
		mutable.addAttributes( attributes, range: wholeRange )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `text color` attribute set.
	@objc func color( _ color: XTColor ) -> NSAttributedString {
		let mutable = self.mutable().color( color )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `text font` attribute set.
	@objc func font( _ font: XTFont ) -> NSAttributedString {
		let mutable = self.mutable().font( font )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `kern` attribute set.
	@objc func kern( _ kern: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable().kern( kern )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `baselineOffset` attributes set.
	@objc func baselineOffset( _ offset: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable().baselineOffset( offset )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `striketrough style and color` attributes set.
	@objc func strikethroughStyle( _ style: NSUnderlineStyle, color: XTColor = .black ) -> NSAttributedString {
		let mutable = self.mutable().strikethroughStyle( style, color: color )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `underline style and color` attributes set.
	@objc func underlineStyle( _ style: NSUnderlineStyle, color: XTColor = .black ) -> NSAttributedString {
		let mutable = self.mutable().underlineStyle( style, color: color )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `.link` attribute set.
	@objc func link( _ link: URL ) -> NSAttributedString {
		let mutable = self.mutable().link(link)
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `paragraphStyle` attribute set.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@objc func paragraphStyle( _ paragraphStyle: NSParagraphStyle ) -> NSAttributedString {
		let mutable = self.mutable().paragraphStyle( paragraphStyle )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `lineSpacing` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `lineSpacing` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@objc func lineSpacing( _ lineSpacing: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable().lineSpacing( lineSpacing )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `paragraphSpacing` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `paragraphSpacing` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@objc func paragraphSpacing( _ paragraphSpacing: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable().paragraphSpacing( paragraphSpacing )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `lineHeightMultiple` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `lineHeightMultiple` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@objc func lineHeightMultiple( _ multiple: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable().lineHeightMultiple( multiple )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `minimumLineHeight` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `minimumLineHeight` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@objc func minimumLineHeight( _ minimumLineHeight: CGFloat ) -> NSAttributedString {
		let mutable = self.mutable().minimumLineHeight( minimumLineHeight )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `alignment` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `alignment` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@objc func alignment( _ alignment: NSTextAlignment ) -> NSAttributedString {
		let mutable = self.mutable().alignment( alignment )
		return NSAttributedString( attributedString: mutable )
	}

	/// Returns a copy of an attributed string with `lineBreakMode` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `lineBreakMode` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@objc func lineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> NSAttributedString {
		let mutable = self.mutable().lineBreakMode( lineBreakMode )
		return NSAttributedString( attributedString: mutable )
	}

	/// Inserts image in attributed string at specified location.
	/// - parameter image: Image to insert in string.
	/// - parameter location: Location in string to insert. If `nil`, image will be appended to the string.
	/// - parameter verticalOffset: Offset in points, will be applied to image position.
	func image(
		_ image: XTImage,
		at location: Int? = nil,
		verticalOffset: CGFloat = 0
	) -> NSAttributedString {
		let mutable = self.mutable()
			.insertImage( image, at: location, verticalOffset: verticalOffset )
		return NSAttributedString( attributedString: mutable )
	}

}

public extension NSMutableAttributedString {

	/// Sets new `text color` attribute over the whole string.
	override func color( _ color: XTColor ) -> Self {
		addAttribute( .foregroundColor, value: color, range: wholeRange )
		return self
	}

	/// Sets new `font` attribute over the whole string.
	override func font( _ font: XTFont ) -> Self {
		addAttribute( .font, value: font, range: wholeRange )
		return self
	}

	/// Sets new `kern` attribute over the whole string.
	override func kern( _ kern: CGFloat ) -> Self {
		addAttribute( .kern, value: kern, range: wholeRange )
		return self
	}

	/// Sets new `baselineOffset` attribute over the whole string.
	override func baselineOffset( _ offset: CGFloat ) -> Self {
		addAttribute( .baselineOffset, value: offset, range: wholeRange )
		return self
	}

	/// Sets new `strikethrough style and color` attributes over the whole string.
	override func strikethroughStyle( _ style: NSUnderlineStyle, color: XTColor = .black ) -> Self {
		let attributes: [ NSAttributedString.Key: Any ] = [ .strikethroughStyle: style.rawValue,
															.strikethroughColor: color ]
		addAttributes( attributes, range: wholeRange )
		return self
	}

	/// Sets new `underline style and color` attributes over the whole string.
	override func underlineStyle( _ style: NSUnderlineStyle, color: XTColor = .black ) -> Self {
		let attributes: [ NSAttributedString.Key: Any ] = [ .underlineStyle: style.rawValue,
															.underlineColor: color ]
		addAttributes( attributes, range: wholeRange )
		return self
	}

	/// Sets `.link` attribute over the whole string.
	override func link( _ link: URL ) -> Self {
		addAttribute( .link, value: link, range: wholeRange )
		return self
	}


	/// Sets `paragraphStyle` attribute set over the whole string.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	override func paragraphStyle( _ paragraphStyle: NSParagraphStyle ) -> Self {
		addAttribute( .paragraphStyle, value: paragraphStyle, range: wholeRange )
		return self
	}

	/// Sets `lineSpacing` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `lineSpacing` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	override func lineSpacing( _ lineSpacing: CGFloat ) -> Self {
		let paragraph = paragraphStyle
		paragraph.lineSpacing = lineSpacing
		addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}

	/// Sets `lineSpacing` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `lineSpacing` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	override func paragraphSpacing( _ paragraphSpacing: CGFloat ) -> Self {
		let paragraph = paragraphStyle
		paragraph.paragraphSpacing = paragraphSpacing
		addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}

	/// Sets `lineHeightMultiple` property of `paragraphStyle` attribute.
	/// - note: Searches string for the first `paragraphStyle` attribute,
	/// change its `lineHeightMultiple` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	override func lineHeightMultiple( _ multiple: CGFloat ) -> Self {
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
	override func minimumLineHeight( _ minimumLineHeight: CGFloat ) -> Self {
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
	override func alignment( _ alignment: NSTextAlignment ) -> Self {
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
	override func lineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> Self {
		let paragraph = paragraphStyle
		paragraph.lineBreakMode = lineBreakMode
		addAttribute( .paragraphStyle, value: paragraph, range: wholeRange )
		return self
	}

	/// Inserts image in attributed string at specified location.
	/// - parameter image: Image to insert in string.
	/// - parameter location: Location in string to insert. If `nil`, image will be appended to the string.
	/// - parameter verticalOffset: Offset in points, will be applied to image position.
	func insertImage(
		_ image: XTImage,
		at location: Int? = nil,
		verticalOffset: CGFloat = 0
	) -> Self {

		let textAttachment = NSTextAttachment()
		textAttachment.image = image
		let attrStringWithImage = NSAttributedString( attachment: textAttachment )

		let location = location ?? length
		let safeLocation = max( 0, min( length - 1, location ))
		#if os(tvOS)
			let systemFontSize: CGFloat = 29
		#else
			let systemFontSize: CGFloat = XTFont.systemFontSize
		#endif

		let font: XTFont = length > 0 ?
			attribute( .font, at: safeLocation, effectiveRange: nil ) as? XTFont ?? .systemFont( ofSize: systemFontSize ) :
			.systemFont( ofSize: systemFontSize )

		let mid = font.descender + font.capHeight
		textAttachment.bounds = CGRect( x: 0, y: font.descender - image.size.height / 2 + mid + 2 - verticalOffset,
		                                width: image.size.width + 1, height: image.size.height ).integral

		insert( attrStringWithImage, at: location )
		return self
	}
}

public extension String {

	/// Returns attributed string with no attributes.
	var attributed: NSAttributedString { NSAttributedString( string: self ) }

	func attributes( _ attributes: [ NSAttributedString.Key: Any ] ) -> NSAttributedString {
		NSAttributedString( string: self, attributes: attributes )
	}

	func color( _ color: XTColor ) -> NSAttributedString {
		NSAttributedString( string: self, attributes: [ .foregroundColor: color ] )
	}

	func font( _ font: XTFont ) -> NSAttributedString {
		NSAttributedString( string: self, attributes: [ .font: font ] )
	}

	func kern( _ kern: CGFloat ) -> NSAttributedString {
		NSAttributedString( string: self, attributes: [ .kern: kern ] )
	}

	func baselineOffset( _ offset: CGFloat ) -> NSAttributedString {
		NSAttributedString( string: self, attributes: [ .baselineOffset: offset ] )
	}

	func strikethroughStyle( _ style: NSUnderlineStyle, color: XTColor = .black ) -> NSAttributedString {
		let attributes: [ NSAttributedString.Key: Any ] = [ .strikethroughStyle: style.rawValue,
															.strikethroughStyle: color ]
		return NSAttributedString( string: self, attributes: attributes )
	}

	func underlineStyle( _ style: NSUnderlineStyle, color: XTColor = .black ) -> NSAttributedString {
		let attributes: [ NSAttributedString.Key: Any ] = [ .underlineStyle: style.rawValue,
															.underlineColor: color ]
		return NSAttributedString( string: self, attributes: attributes )
	}

	func link( _ link: URL ) -> NSAttributedString {
		NSAttributedString( string: self, attributes: [ .link: link ] )
	}

	func paragraphStyle( _ paragraphStyle: NSParagraphStyle ) -> NSAttributedString {
		NSAttributedString( string: self, attributes: [ .paragraphStyle: paragraphStyle ] )
	}

	func lineSpacing( _ lineSpacing: CGFloat ) -> NSAttributedString {
		let paragraph = NSMutableParagraphStyle.standard
		paragraph.lineSpacing = lineSpacing
		return paragraphStyle( paragraph )
	}

	func paragraphSpacing( _ paragraphSpacing: CGFloat ) -> NSAttributedString {
		let paragraph = NSMutableParagraphStyle.standard
		paragraph.paragraphSpacing = paragraphSpacing
		return paragraphStyle( paragraph )
	}

	func lineHeightMultiple( _ multiple: CGFloat ) -> NSAttributedString {
		let paragraph = NSMutableParagraphStyle.standard
		paragraph.lineHeightMultiple = multiple
		return paragraphStyle( paragraph )
	}

	func minimumLineHeight( _ minimumLineHeight: CGFloat ) -> NSAttributedString {
		let paragraph = NSMutableParagraphStyle.standard
		paragraph.minimumLineHeight = minimumLineHeight
		return paragraphStyle( paragraph )
	}

	func alignment( _ alignment: NSTextAlignment ) -> NSAttributedString {
		let paragraph = NSMutableParagraphStyle.standard
		paragraph.alignment = alignment
		return paragraphStyle( paragraph )
	}

	func lineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> NSAttributedString {
		let paragraph = NSMutableParagraphStyle.standard
		paragraph.lineBreakMode = lineBreakMode
		return paragraphStyle( paragraph )
	}

	/// Creates attributed string and inserts image in it at specified location.
	/// - parameter image: Image to insert in string.
	/// - parameter location: Location in string to insert. If `nil`, image will be appended to the string.
	/// - parameter verticalOffset: Offset in points, will be applied to image position.
	func image(
		_ image: XTImage,
		at location: Int? = nil,
		verticalOffset: CGFloat = 0
	) -> NSAttributedString {
		NSMutableAttributedString( string: self )
			.insertImage( image, at: location, verticalOffset: verticalOffset )
	}
}

public extension NSMutableParagraphStyle {

	@objc class var standard: NSMutableParagraphStyle {
		let defaultStyle = NSMutableParagraphStyle()
		defaultStyle.lineBreakMode = .byTruncatingTail
		if #available(iOS 14.0, macOS 11.0, tvOS 14, *) {
			defaultStyle.lineBreakStrategy = .standard
		}
		return defaultStyle
	}
}

private extension NSAttributedString {
	var paragraphStyle: NSMutableParagraphStyle {

		guard length > 0,
			  let currentStyle =
				self.attribute( .paragraphStyle, at: 0, longestEffectiveRange: nil, in: wholeRange ) as? NSParagraphStyle
		else {
			return .standard
		}

		return currentStyle.mutableCopy() as! NSMutableParagraphStyle
	}
}
