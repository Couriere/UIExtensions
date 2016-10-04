//
//  UIVIew+Extensions.swift
//
//  Created by Vladimir Kazantsev on 29/10/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

extension UIView {

	/**
	Load xib in memory
	
	- parameter xib:    Name of the xib
	- parameter ofType: View type to search in xib. Ex: MyViewClass.self
	
	- returns: Instance of ofType class, loaded from xib
	*/
	class func viewFromXib( _ xib: String? = nil ) -> Self? {

		let xibFile = xib ?? NSStringFromClass( self as! AnyClass ).components( separatedBy: "." ).last!

		let nib = UINib( nibName: xibFile, bundle: nil )
		let views = nib.instantiate( withOwner: nil, options: nil )
		
		for anyObject in views {
			if type(of: (anyObject) as AnyObject) === self {
				return helperConvertObject( anyObject as AnyObject, type: self )
			}
		}
	
		return nil
	}
	
	fileprivate class func helperConvertObject<T>( _ object: AnyObject, type: T.Type ) -> T? {
		return object as? T
	}

}

extension UIView {
	///
	convenience init( useAutolayout: Bool ) {
		self.init( frame: .zero )
		translatesAutoresizingMaskIntoConstraints = useAutolayout
	}
}
