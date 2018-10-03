//
//  UIStoryboard+Extensions.swift
//
//  Created by Vladimir Kazantsev on 14.03.2018.
//  Copyright © 2018 MC2Soft. All rights reserved.
//

import UIKit

public extension UIViewController {
	
	// If something fails here, it almost certanly a fatal error for application.
	// So we will return actual value or fail instead of returning optional.
	
	class func instantiate( from storyboard: UIStoryboard, storyboardId: String? = nil ) -> Self {
		
		let id = storyboardId ?? NSStringFromClass( self ).components( separatedBy: "." ).last!

		let result = storyboard.instantiateViewController( withIdentifier: id )
		return helperConvertObject( result, type: self )
	}
	
	class func instantiateAsInitialViewController( in storyboard: UIStoryboard ) -> Self {
		let result = storyboard.instantiateInitialViewController()!
		return helperConvertObject( result, type: self )
	}
	
	private class func helperConvertObject<T>( _ object: AnyObject, type: T.Type ) -> T {
		return object as! T
	}
}
