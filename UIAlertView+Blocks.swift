//
//  UIAlertView+Blocks.swift
//
//  Created by Vladimir Kazantsev on 10.12.14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

typealias AlertViewHandler = ( alertView: UIAlertView, selectedIndex: Int ) -> Void
var TAG_DISMISS_HANDLER: UInt8 = 0

class AlertViewHelper {
	var handler: AlertViewHandler?
	init( handler: AlertViewHandler? ) { self.handler = handler }
}

extension UIAlertView {
	
	class func showAlertViewWithTitle( title: String?, message: String?, buttonTitles: [ String ]? = nil, handler: AlertViewHandler? = nil ) {
		dispatch_main_thread_sync { () -> Void in
			let alert = UIAlertView.alertViewWithTitle( title, message: message, buttonTitles: buttonTitles, handler: handler )
			alert.show()
		}
	}
		
	class func alertViewWithTitle( title: String?, message: String?, buttonTitles: [ String ]?, handler: AlertViewHandler? ) -> UIAlertView {
		let cancelButtonTitle = buttonTitles != nil ? buttonTitles![ 0 ] : "OK"
	
		let view = UIAlertView( title: title, message: message, delegate: self, cancelButtonTitle: cancelButtonTitle )
	
		if let buttons = buttonTitles {
			for var i = 1; i < buttons.count; i++ {
				view.addButtonWithTitle( buttons[ i ] )
			}
		}
		
		objc_setAssociatedObject( view, &TAG_DISMISS_HANDLER, AlertViewHelper( handler: handler ), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
		return view;
	}
	
	class func alertView( alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int ) {
		let helper = objc_getAssociatedObject( alertView, &TAG_DISMISS_HANDLER ) as? AlertViewHelper
		objc_setAssociatedObject( alertView, &TAG_DISMISS_HANDLER, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		if helper != nil {
			if let handler = helper!.handler {
				handler( alertView: alertView, selectedIndex: buttonIndex )
			}
		}
	}

}
