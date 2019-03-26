//
//  UIVIew+Extensions.swift
//
//  Created by Vladimir Kazantsev on 29/10/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

public extension UIView {

	/// Returns current first responder view that's contained in this view's subtree.
	/// Returns `nil` otherwise.
	var firstResponder: UIView? {

		if isFirstResponder { return self }

		for view in subviews {
			if let firstResponder = view.firstResponder { return firstResponder }
		}

		return nil
	}


	/// Adds views to the end of the receiver’s list of subviews.
	func addSubviews( _ views: [ UIView ] ) {
		views.forEach { addSubview( $0 ) }
	}

	/// Removes all subviews from the receiver.
	func removeAllSubviews() {
		subviews.forEach { $0.removeFromSuperview() }
	}
}

public extension UIView {

	/**
	Loads view from xib in memory.

	- parameter xib:    Name of the xib. Default to type name.
	- returns: Instance of ofType class, loaded from xib
	*/
	class func makeFromXib( named xibName: String? = nil ) -> Self? {

		guard let xibFile = xibName ??
			NSStringFromClass( self ).components( separatedBy: "." ).last
			else {
				return nil
		}

		let nib = UINib( nibName: xibFile, bundle: nil )
		let views = nib.instantiate( withOwner: nil, options: nil ) as [ AnyObject ]

		guard let selfObject = views.first( where : { type( of: $0 ) == self } )
			else { return nil }

		return helperConvertObject( selfObject, type: self )
	}

	private class func helperConvertObject<T>( _ object: AnyObject, type: T.Type ) -> T? {
		return object as? T
	}
}
