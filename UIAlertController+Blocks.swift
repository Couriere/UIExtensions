//
//  UIAlertController+Blocks.swift
//
//  Created by Vladimir Kazantsev on 15/09/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

@available(iOS 8.0, *) typealias UIAlertControllerHandler = ( _ alertController: UIAlertController, _ selectedIndex: Int ) -> Void

@available(iOS 8.0, *)
extension UIAlertController {
	
	class func showAlertControllerWithTitle( _ title: String?, message: String?, buttonTitles: [ String ]? = nil, parentController: UIViewController? = nil, handler: UIAlertControllerHandler? = nil ) {
		dispatch_main_thread_sync {
			let alert = UIAlertController.alertControllerWithTitle( title, message: message, buttonTitles: buttonTitles, handler: handler )
			if let parentController = parentController {
				parentController.present( alert, animated: true, completion: nil )
			} else {
				UIViewController.topPresentedViewController?.present( alert, animated: true, completion: nil )
			}
		}
	}
	
	class func alertControllerWithTitle( _ title: String?, message: String?, buttonTitles: [ String ]?, handler: UIAlertControllerHandler? ) -> UIAlertController {
		let cancelButtonTitle = buttonTitles != nil ? buttonTitles![ 0 ] : "OK"
		
		let alert = UIAlertController( title: title, message: message, preferredStyle: .alert )

		let actionHandler = { ( action: UIAlertAction ) -> Void in
			handler?( alert, alert.actions.index( of: action ) ?? -1 )
		}
		
		alert.addAction( UIAlertAction( title: cancelButtonTitle, style: .cancel, handler: actionHandler ))

		if let buttons = buttonTitles {
			for buttonTitle in buttons[ 1..<buttons.count ] {
				alert.addAction( UIAlertAction( title: buttonTitle, style: .default, handler: actionHandler ) )
			}
		}

		return alert
	}
}

@available(iOS 8.0, *)
extension UIViewController {
	func showUIAlertControllerWithTitle( _ title: String?, message: String?, buttonTitles: [ String ]? = nil, handler: UIAlertControllerHandler? = nil ) {
		UIAlertController.showAlertControllerWithTitle( title, message: message, buttonTitles: buttonTitles, parentController: self, handler: handler )
	}
}
