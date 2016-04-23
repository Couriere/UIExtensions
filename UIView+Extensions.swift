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
	class func viewFromXib( xib: String ) -> Self? {
		let views = NSBundle.mainBundle().loadNibNamed( xib, owner: nil, options: nil )
		for anyObject in views {
			if anyObject.dynamicType === self {
				return helperConvertObject( anyObject, type: self )
			}
		}
		
		return nil
	}
	
	private class func helperConvertObject<T>( object: AnyObject, type: T.Type ) -> T? {
		return object as? T
	}

}
