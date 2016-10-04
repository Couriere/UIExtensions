//
//  UIAlertView+Blocks.swift
//
//  Created by Vladimir Kazantsev on 10.12.14.
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

typealias AlertViewHandler = ( _ alertView: UIAlertView, _ selectedIndex: Int ) -> Void
var TAG_DISMISS_HANDLER: UInt8 = 0

class AlertViewHelper {
	var handler: AlertViewHandler?
	init( handler: AlertViewHandler? ) { self.handler = handler }
}

extension UIAlertView {
	
	class func showAlertViewWithTitle( _ title: String?, message: String?, buttonTitles: [ String ]? = nil, handler: AlertViewHandler? = nil ) {
		dispatch_main_thread_sync { () -> Void in
			let alert = UIAlertView.alertViewWithTitle( title, message: message, buttonTitles: buttonTitles, handler: handler )
			alert.show()
		}
	}
		
	class func alertViewWithTitle( _ title: String?, message: String?, buttonTitles: [ String ]?, handler: AlertViewHandler? ) -> UIAlertView {
		let cancelButtonTitle = buttonTitles != nil ? buttonTitles![ 0 ] : "OK"
	
		let view = UIAlertView( title: title, message: message, delegate: self, cancelButtonTitle: cancelButtonTitle )
	
		buttonTitles?.forEach { view.addButton( withTitle: $0 ) }
		
		objc_setAssociatedObject( view, &TAG_DISMISS_HANDLER, AlertViewHelper( handler: handler ), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
		return view;
	}
	
	class func alertView( _ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int ) {
		let helper = objc_getAssociatedObject( alertView, &TAG_DISMISS_HANDLER ) as? AlertViewHelper
		objc_setAssociatedObject( alertView, &TAG_DISMISS_HANDLER, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		if helper != nil {
			if let handler = helper!.handler {
				handler( alertView, buttonIndex )
			}
		}
	}

}
