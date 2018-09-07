//
//  UIVIew+Extensions.swift
//
//  Created by Vladimir Kazantsev on 29/10/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

public extension UIView {

	/// Adds views to the end of the receiver’s list of subviews.
	public func addSubviews( _ views: [ UIView ] ) {
		views.forEach { addSubview( $0 ) }
	}

	/// Removes all subviews from the receiver.
	public func removeAllSubviews() {
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
