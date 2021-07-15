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

#if os(iOS)||os(tvOS)

import UIKit

public extension Date {

	// ..<
	@available( swift, deprecated: 4.2, message: "Use isBetween(_: and: )" )
	func isBetweenDate( _ firstDate: Date, andDate secondDate: Date ) -> Bool {
		let startResult = firstDate.compare( self )
		return ( startResult == .orderedSame || startResult == .orderedAscending ) && compare( secondDate ) == .orderedAscending
	}

	@available( swift, deprecated: 4.2, message: "Use Date.addingMonths(_:)" )
	func dateByAddingMonths( _ months: Int ) -> Date {
		return addingMonths( months )
	}
}

public extension Dictionary {
	
	@available( swift, deprecated: 4.0, obsoleted: 5.0, message: "Use Dictionary( uniqueKeysWithValues: ) instead" )
	init(_ elements: [Element]) {
		self.init()
		for (k, v) in elements {
			self[k] = v
		}
	}

	@available( swift, deprecated: 4.0, obsoleted: 5.0, message: "Use `Dictionary[ key, default: value ] instead" )
	func valueForKey<T>( _ key: Key, defaultValue: T ) -> T {
		if let value = self[ key ] as? T {
			return value
		}
		else {
			return defaultValue
		}
	}
}

public extension URL {

#if os( iOS )
	@available( iOS, deprecated: 11.0, message: "Use UIDevice.current.freeSpace instead" )
	var freeSpace: Int64? {
		return UIDevice.current.freeSpace
	}
#endif
}


@available( swift, deprecated: 5.1, message: "User @UserDefault property wrapper instead." )
public final class DefaultsKey<T> {

	public let key: String
	public let userDefaults: UserDefaults

	private let archive: ( ( T ) throws -> Any )?
	private let unarchive: ( ( Any? ) throws -> T? )?

	public init(
		key: String,
		userDefaults: UserDefaults = UserDefaults.standard,
		archive: ( ( T ) throws -> Any )? = nil,
		unarchive: ( ( Any? ) throws -> T? )? = nil ) {

		self.key = key
		self.userDefaults = userDefaults

		switch "\(T.self)" {
		case NSStringFromClass( UIColor.self ):
			self.archive = { color in
				NSKeyedArchiver.archivedData( withRootObject: color )
			}
			self.unarchive = { object in
				guard let data = object as? Data else { return nil }
				return NSKeyedUnarchiver.unarchiveObject( with: data ) as? T
			}

		default:
			self.archive = archive
			self.unarchive = unarchive
		}
	}

	public subscript() -> T? {
		get { return unarchiveValue() }
		set { userDefaults.setValue( archiveValue( newValue ), forKey: key ) }
	}

	public subscript( defaultValue: T ) -> T {
		get { return unarchiveValue() ?? defaultValue }
		set { userDefaults.setValue( archiveValue( newValue ), forKey: key ) }
	}

	public func remove() {
		userDefaults.removeObject( forKey: key )
	}


	private func unarchiveValue() -> T? {
		let data = userDefaults.value( forKey: key )
		guard let unarchive = unarchive else { return data as? T }
		do { return try unarchive( data ) } catch { return nil }
	}

	private func archiveValue( _ value: T? ) -> Any? {
		guard let value = value else { return nil }
		guard let archive = archive else { return value }
		do { return try archive( value ) } catch { return nil }
	}
}


public extension String {

	@available( *, deprecated, renamed: "attributes" )
	@inlinable
	func withAttributes( _ attributes: [ NSAttributedString.Key: AnyObject ] ) -> NSMutableAttributedString {
		self.attributes( attributes )
	}

	@available( *, deprecated, renamed: "color" )
	@inlinable
	func withColor( _ color: UIColor ) -> NSMutableAttributedString {
		self.color( color )
	}

	@available( *, deprecated, renamed: "font" )
	@inlinable
	func withFont( _ font: UIFont ) -> NSMutableAttributedString {
		self.font( font )
	}

	@available( *, deprecated, renamed: "kern" )
	@inlinable
	func withKern( _ kern: CGFloat ) -> NSMutableAttributedString {
		self.kern( kern )
	}

	@available( *, deprecated, renamed: "baselineOffset" )
	@inlinable
	func withBaselineOffset( _ offset: CGFloat ) -> NSMutableAttributedString {
		self.baselineOffset( offset )
	}

	@available( *, deprecated, renamed: "strikethroughStyle" )
	@inlinable
	func withStrikethroughStyle( _ style: NSUnderlineStyle, color: UIColor = .black ) -> NSMutableAttributedString {
		self.strikethroughStyle( style, color: color )
	}

	@available( *, deprecated, renamed: "underlineStyle" )
	@inlinable
	func withUnderlineStyle( _ style: NSUnderlineStyle, color: UIColor = .black ) -> NSMutableAttributedString {
		self.underlineStyle( style, color: color )
	}

	@available( *, deprecated, renamed: "paragraphStyle" )
	@inlinable
	func withParagraphStyle( _ paragraphStyle: NSParagraphStyle ) -> NSMutableAttributedString {
		self.paragraphStyle( paragraphStyle )
	}

	@available( *, deprecated, renamed: "lineSpacing" )
	@inlinable
	func withLineSpacing( _ lineSpacing: CGFloat ) -> NSMutableAttributedString {
		self.lineSpacing( lineSpacing )
	}

	@available( *, deprecated, renamed: "lineHeightMultiple" )
	@inlinable
	func withLineHeightMultiple( _ multiple: CGFloat ) -> NSMutableAttributedString {
		self.lineHeightMultiple( multiple )
	}

	@available( *, deprecated, renamed: "minimumLineHeight" )
	@inlinable
	func withMinimumLineHeight( _ minimumLineHeight: CGFloat ) -> NSMutableAttributedString {
		self.minimumLineHeight( minimumLineHeight )
	}

	@available( *, deprecated, renamed: "alignment" )
	@inlinable
	func withAlignment( _ alignment: NSTextAlignment ) -> NSMutableAttributedString {
		self.alignment( alignment )
	}

	@available( *, deprecated, renamed: "lineBreakMode" )
	@inlinable
	func withLineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> NSMutableAttributedString {
		self.lineBreakMode( lineBreakMode )
	}

	/// Creates attributed string and inserts image in it at specified location.
	/// - parameter image: Image to insert in string.
	/// - parameter location: Location in string to insert. If `nil`, image will be appended to the string.
	/// - parameter verticalOffset: Offset in points, will be applied to image position.
	@available( *, deprecated, renamed: "image" )
	@inlinable
	func withImage( _ image: UIImage,
					atLocation location: Int? = nil,
					verticalOffset: CGFloat = 0 ) -> NSMutableAttributedString {
		self.image( image )
	}
}

public extension NSAttributedString {
	/// Returns a copy of an attributed string with `text color` attribute set.
	@available( *, deprecated, renamed: "color" )
	func settingColor( _ color: UIColor ) -> NSAttributedString {
		self.mutable().color( color )
	}

	/// Returns a copy of an attributed string with `text font` attribute set.
	@available( *, deprecated, renamed: "font" )
	func settingFont( _ font: UIFont ) -> NSAttributedString {
		self.mutable().font( font )
	}

	/// Returns a copy of an attributed string with `kern` attribute set.
	@available( *, deprecated, renamed: "kern" )
	func settingKern( _ kern: CGFloat ) -> NSAttributedString {
		self.mutable().kern( kern )
	}

	/// Returns a copy of an attributed string with `baselineOffset` attributes set.
	@available( *, deprecated, renamed: "baselineOffset" )
	func settingBaselineOffset( _ offset: CGFloat ) -> NSAttributedString {
		self.mutable().baselineOffset( offset )
	}

	/// Returns a copy of an attributed string with `striketrough style and color` attributes set.
	@available( *, deprecated, renamed: "strikethroughStyle" )
	func settingStrikethroughStyle( _ style: NSUnderlineStyle, color: UIColor = .black ) -> NSAttributedString {
		self.mutable().strikethroughStyle( style, color: color )
	}

	/// Returns a copy of an attributed string with `underline style and color` attributes set.
	@available( *, deprecated, renamed: "underlineStyle" )
	func settingUnderlineStyle( _ style: NSUnderlineStyle, color: UIColor = .black ) -> NSAttributedString {
		self.mutable().underlineStyle( style, color: color )
	}


	/// Returns a copy of an attributed string with `paragraphStyle` attribute set.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@available( *, deprecated, renamed: "paragraphStyle" )
	func settingParagraphStyle( _ paragraphStyle: NSParagraphStyle ) -> NSAttributedString {
		self.mutable().paragraphStyle( paragraphStyle )
	}

	/// Returns a copy of an attributed string with `lineSpacing` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `lineSpacing` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@available( *, deprecated, renamed: "lineSpacing" )
	func settingLineSpacing( _ lineSpacing: CGFloat ) -> NSAttributedString {
		self.mutable().lineSpacing( lineSpacing )
	}

	/// Returns a copy of an attributed string with `paragraphSpacing` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `paragraphSpacing` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@available( *, deprecated, renamed: "paragraphSpacing" )
	func settingParagraphSpacing( _ paragraphSpacing: CGFloat ) -> NSAttributedString {
		self.mutable().paragraphSpacing( paragraphSpacing )
	}

	/// Returns a copy of an attributed string with `lineHeightMultiple` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `lineHeightMultiple` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@available( *, deprecated, renamed: "lineHeightMultiple" )
	func settingLineHeightMultiple( _ multiple: CGFloat ) -> NSAttributedString {
		self.mutable().lineHeightMultiple( multiple )
	}

	/// Returns a copy of an attributed string with `minimumLineHeight` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `minimumLineHeight` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@available( *, deprecated, renamed: "minimumLineHeight" )
	func settingMinimumLineHeight( _ minimumLineHeight: CGFloat ) -> NSAttributedString {
		self.mutable().minimumLineHeight( minimumLineHeight )
	}

	/// Returns a copy of an attributed string with `alignment` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `alignment` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@available( *, deprecated, renamed: "alignment" )
	func settingAlignment( _ alignment: NSTextAlignment ) -> NSAttributedString {
		self.mutable().alignment( alignment )
	}

	/// Returns a copy of an attributed string with `lineBreakMode` property of
	/// `paragraphStyle` attribute set.
	/// - note: Searches source string for the first `paragraphStyle` attribute,
	/// change its `lineBreakMode` property and set `paragraphStyle` over the whole string.
	/// If no existing `paragraphStyle` attribute found, creates a new one.
	/// - note: All existing paragraph styles attributes in string will be overwritten.
	@available( *, deprecated, renamed: "lineBreakMode" )
	func settingLineBreakMode( _ lineBreakMode: NSLineBreakMode ) -> NSAttributedString {
		self.mutable().lineBreakMode( lineBreakMode )
	}
}


public extension UIViewController {

	/// Returns distance from top to safe area. If running on iOS versions prior to 11,
	/// uses `topLayoutGuide` length instead.

	@available( iOS, deprecated: 11.0, message: "Use view.safeAreaInsets.top instead", renamed: "view.safeAreaInsets.top" )
	@available( tvOS, deprecated: 11.0, message: "Use view.safeAreaInsets.top instead", renamed: "view.safeAreaInsets.top" )
	var topSafeAreaInset: CGFloat {
		return view.safeAreaInsets.top
	}

	/// Returns distance from bottom to safe area. If running on iOS versions prior to 11,
	/// uses `bottomLayoutGuide` length instead.
	@available( iOS, deprecated: 11.0, message: "Use view.safeAreaInsets.bottom instead", renamed: "view.safeAreaInsets.bottom" )
	@available( tvOS, deprecated: 11.0, message: "Use view.safeAreaInsets.bottom instead", renamed: "view.safeAreaInsets.bottom" )
	var bottomSafeAreaInset: CGFloat {
		return view.safeAreaInsets.bottom
	}
}

public extension UIView {
	@available( *, deprecated, renamed: "systemLayoutSizeFitting(width:)" )
	func systemLayoutSizeFittingSize( _ targetSize: CGSize, constrainedToWidth width: CGFloat ) -> CGSize {
		let constraint = constrainTo( width: width )
		let size = systemLayoutSizeFitting( targetSize )
		constraint.isActive = false
		return size
	}
}

public extension LayoutGuideProtocol {
	

	@available( iOS, deprecated: 11.0, message: "Use pin( .top, to: safeAreaLayoutGuide ) instead" )
	@available( tvOS, deprecated: 11.0, message: "Use pin( .top, to: safeAreaLayoutGuide ) instead" )
	@discardableResult
	func constrainToTopLayoutGuide( inset: CGFloat = 0 ) -> NSLayoutConstraint {

		let topGuide = owningView!.safeAreaLayoutGuide
		let constraint = topAnchor.constraint( equalTo: topGuide.topAnchor, constant: inset )
		constraint.isActive = true
		return constraint
	}

	@available( iOS, deprecated: 11.0, message: "Use pin( .bottom, to: safeAreaLayoutGuide ) instead" )
	@available( tvOS, deprecated: 11.0, message: "Use pin( .bottom, to: safeAreaLayoutGuide ) instead" )
	@discardableResult
	func constrainToBottomLayoutGuide( inset: CGFloat = 0 ) -> NSLayoutConstraint {

		let bottomGuide = owningView!.safeAreaLayoutGuide
		let constraint = bottomGuide.bottomAnchor.constraint( equalTo: bottomAnchor, constant: inset )
		constraint.isActive = true
		return constraint
	}
}

public extension UIAlertController {

	#if swift(<5.5)
	@available( swift, deprecated: 5.0, message: "Use UIViewController.showUIAlertControllerWithTitle" )
	class func showAlertControllerWithTitle(
		_ title: String?,
		message: String?,
		buttonTitles: [ String ]? = nil,
		parentController: UIViewController? = nil,
		handler: UIAlertControllerHandler? = nil
	) {
		dispatch_main_thread_sync {
			let alert = UIAlertController( title: title, message: message, buttonTitles: buttonTitles, handler: handler )
			if let parentController = parentController {
				parentController.present( alert, animated: true, completion: nil )
			}
			else {
				UIViewController.topPresentedViewController?.present( alert, animated: true, completion: nil )
			}
		}
	}
	#else
	@available( *, unavailable, message: "Use UIViewController.showUIAlertControllerWithTitle" )
	class func showAlertControllerWithTitle(
		_ title: String?,
		message: String?,
		buttonTitles: [ String ]? = nil,
		parentController: UIViewController? = nil,
		handler: UIAlertControllerHandler? = nil
	) {
	}
	#endif


	@available( swift, deprecated: 5.5, message: "Use UIAlertController( title: message: buttonTitles: handler: )" )
	class func alertControllerWith(
		title: String?,
		message: String?,
		buttonTitles: [ String ]?,
		handler: UIAlertControllerHandler?
	) -> UIAlertController {
		return UIAlertController( title: title, message: message, buttonTitles: buttonTitles, handler: handler )
	}
}
#endif
