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

#if canImport(UIKit)
import UIKit

public extension UILabel {

	///  Initialize UILabel and setting it's attributedText property with parameter.
	/// - parameters attributedText: Text to set after initialization.
	convenience init( _ attributedText: NSAttributedString? ) {
		self.init( frame: .zero )
		self.attributedText = attributedText
		self.isHidden = attributedText == nil
		self.numberOfLines = 0
	}
}

public extension UILabel {

	/// Changes UILabel text with crossfade effect.
	/// Transition is noop if new text is equal to old one.
	/// - parameters text: Text to set on receiver with crossfade effect.
	/// - parameters duration: Duration of crossfade effect.
	func crossfadeTo( text: String, duration: TimeInterval = 0.2 ) {
		guard text != self.text else { return }
		applyFadeAnimation( duration: duration )
		self.text = text
	}


	/// Changes UILabel text with crossfade effect.
	/// Transition is noop if new text is equal to old one.
	/// - parameters text: Text to set on receiver with crossfade effect.
	/// - parameters duration: Duration of crossfade effect.
	func crossfadeTo( text: NSAttributedString, duration: TimeInterval = 0.2 ) {
		guard text != self.attributedText else { return }
		applyFadeAnimation( duration: duration )
		self.attributedText = text
	}

	private func applyFadeAnimation( duration: TimeInterval ) {
		let animation = CATransition().then {
			$0.timingFunction = CAMediaTimingFunction( name: .easeInEaseOut )
			$0.type = CATransitionType.fade
			$0.duration = duration
		}
		layer.add( animation, forKey: CATransitionType.fade.rawValue )
	}
}


public extension UILabel {

	///  Initialize UILabel and setting it's text property with parameter.
	/// - parameters text: Text to set after initialization.
	convenience init( _ text: String? ) {
		self.init( frame: .zero )
		self.text = text
		self.isHidden = text == nil
		self.numberOfLines = 0
	}

	/// Changes font of the text in the `UILabel`.
	func font( _ uiFont: UIFont ) -> Self {
		attributedText = attributedText?.font( uiFont )
		return self
	}

	/// Changes color of the text in the `UILabel`.
	func color( _ uiColor: UIColor ) -> Self {
		attributedText = attributedText?.color( uiColor )
		return self
	}

	/// Sets `kern` attribute of the text in the `UILabel`.
	func kern( _ kern: CGFloat ) -> Self {
		attributedText = attributedText?.kern( kern )
		return self
	}

	/// Sets `baselineOffset` attribute of the text in the `UILabel`.
	func baselineOffset( _ offset: CGFloat ) -> Self {
		attributedText = attributedText?.baselineOffset( offset )
		return self
	}

	/// Sets `strikethroughStyle` attribute of the text in the `UILabel`.
	func strikethroughStyle( _ style: NSUnderlineStyle, color: UIColor = .black ) -> Self {
		attributedText = attributedText?.strikethroughStyle( style, color: color )
		return self
	}

	/// Sets `underlineStyle` attribute of the text in the `UILabel`.
	func underlineStyle( _ style: NSUnderlineStyle, color: UIColor = .black ) -> Self {
		attributedText = attributedText?.underlineStyle( style, color: color )
		return self
	}

	/// Sets `paragraphStyle` attribute of the text in the `UILabel`.
	/// - note: All existing paragraph styles will be overwritten.
	func paragraphStyle( _ paragraphStyle: NSParagraphStyle ) -> Self {
		attributedText = attributedText?.paragraphStyle( paragraphStyle )
		return self
	}

	/// Sets `lineSpacing` value in `paragraphStyle` attribute
	/// of the text in the `UILabel`.
	func lineSpacing( _ lineSpacing: CGFloat ) -> Self {
		attributedText = attributedText?.lineSpacing( lineSpacing )
		return self
	}

	/// Sets `paragraphSpacing` value in `paragraphStyle` attribute
	/// of the text in the `UILabel`.
	func paragraphSpacing( _ paragraphSpacing: CGFloat ) -> Self {
		attributedText = attributedText?.paragraphSpacing( paragraphSpacing )
		return self
	}

	/// Sets `lineHeightMultiple` value in `paragraphStyle` attribute
	/// of the text in the `UILabel`.
	func lineHeightMultiple( _ multiple: CGFloat ) -> Self {
		attributedText = attributedText?.lineHeightMultiple( multiple )
		return self
	}

	/// Sets `minimumLineHeight` value in `paragraphStyle` attribute
	/// of the text in the `UILabel`.
	func minimumLineHeight( _ minimumLineHeight: CGFloat ) -> Self {
		attributedText = attributedText?.minimumLineHeight( minimumLineHeight )
		return self
	}

	/// Sets `alignment` value in `paragraphStyle` attribute
	/// of the text in the `UILabel`.
	func alignment( _ alignment: NSTextAlignment ) -> Self {
		attributedText = attributedText?.alignment( alignment )
		return self
	}

	/// Sets `lineBreakMode` value in `paragraphStyle` attribute
	/// of the text in the `UILabel`.
	func lineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> Self {
		attributedText = attributedText?.lineBreakMode( lineBreakMode )
		return self
	}

	/// Sets `paragraphStyle` attribute of the text in the `UILabel`.
	/// - note: All existing paragraph styles will be overwritten.
	func image(
		_ image: UIImage,
		at location: Int? = nil,
		verticalOffset: CGFloat = 0
	) -> Self {
		attributedText = attributedText?
			.image( image, at: location, verticalOffset: verticalOffset )
		return self
	}


	/// Sets attributes of the text in the `UILabel`.
	/// - note: All existing attributes will be overwritten.
	func attributes( _ attributes: [NSAttributedString.Key: Any] ) -> Self {
		attributedText = text?.attributes( attributes )
		return self
	}
}

#endif
