//
//  UITabBarController+Extensions.swift
//  UIExtensions
//
//  Created by Vladimir on 30/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

public extension UITabBarController {

	/// Shows/hides tab bar in UITabBarController.
	/// Correctly changes safe area zone in subviews.
	var isTabBarHidden: Bool {
		get { return !tabBar.frame.intersects( view.frame ) }
		set {
			guard isTabBarHidden != newValue else { return }

			let offsetY = newValue ? tabBar.frame.height : -tabBar.frame.height
			let endFrame = tabBar.frame.offsetBy( dx: 0, dy: offsetY )

			// Update safe area insets for the current view controller.
			if #available( iOS 11, * ),
				let childController = viewControllers?[ selectedIndex ] {

				var newInsets = childController.additionalSafeAreaInsets
				newInsets.bottom += -offsetY

				childController.additionalSafeAreaInsets = newInsets
				childController.view.setNeedsLayout()
			}

			tabBar.frame = endFrame
		}
	}
}
