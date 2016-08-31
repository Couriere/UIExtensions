//
//  UINavigationController+Blocks.swift
//
//  Created by Vladimir Kazantsev on 14.04.15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

extension UIViewController {
	static var topPresentedViewController: UIViewController? {
		var controller = UIApplication.sharedApplication().keyWindow?.rootViewController
		while controller?.presentedViewController != nil {
			controller = controller?.presentedViewController
		}
		return controller
	}
}

extension UINavigationController {
	
	func pushViewController( viewController: UIViewController, animated: Bool, completion: () -> Void ) {
			
		pushViewController( viewController, animated: animated )
		setCompletionHandler( completion )
	}

	func popViewControllerAnimated( animated: Bool, completion: () -> Void ) {
		
		popViewControllerAnimated( animated )
		setCompletionHandler( completion )
	}

	func popToViewController( viewController: UIViewController, animated: Bool, completion: () -> Void ) {

		popToViewController( viewController, animated: animated )
		setCompletionHandler( completion )
	}
	
	func popToRootViewControllerAnimated( animated: Bool, completion: () -> Void ) {
		
		popToRootViewControllerAnimated( animated )
		setCompletionHandler( completion )
	}
	
	private func setCompletionHandler( completion: () -> Void ) {
		if let coordinator = transitionCoordinator() {
			coordinator.animateAlongsideTransition( nil ) { _ in
				completion()
			}
		}
	}
}


/// Pre iOS7 push/pop animation style
extension UINavigationController {
	func pushViewControllerRetro( viewController: UIViewController ) {
		let transition = CATransition()
		transition.duration = 0.25
		transition.timingFunction = CAMediaTimingFunction( name: kCAMediaTimingFunctionEaseInEaseOut )
		transition.type = kCATransitionPush;
		transition.subtype = kCATransitionFromRight;
		view.layer.addAnimation( transition, forKey: "RetroPush" )
		
		pushViewController( viewController, animated: false )
	}
	
	func popViewControllerRetro() {
		let transition = CATransition()
		transition.duration = 0.25
		transition.timingFunction = CAMediaTimingFunction( name: kCAMediaTimingFunctionEaseInEaseOut )
		transition.type = kCATransitionPush
		transition.subtype = kCATransitionFromLeft
		view.layer.addAnimation( transition, forKey: "RetroPop" )
		
		popViewControllerAnimated( false )
	}
}

/// Custom segues for retro Push/Pop
class RetroPushSegue: UIStoryboardSegue {
	override func perform() {
		
		guard let navigationController = self.sourceViewController.navigationController else {
			assertionFailure( "Must be called within UINavigationController" )
			return
		}
		navigationController.pushViewControllerRetro( self.destinationViewController )
	}
}

class RetroPushSegueUnwind: UIStoryboardSegue {
	override func perform() {
		
		guard let navigationController = self.sourceViewController.navigationController else {
			assertionFailure( "Must be called within UINavigationController" )
			return
		}
		navigationController.popViewControllerRetro()
	}
}


