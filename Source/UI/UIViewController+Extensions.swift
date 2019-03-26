//
//  UIViewController+Extensions.swift
//
//  Created by Vladimir on 29/11/2018.
//  Copyright © 2018 Vladimir Kazantsev. All rights reserved.
//

import UIKit

public extension UIViewController {

	/// Returns distance from top to safe area. If running on iOS versions prior to 11,
	/// uses `topLayoutGuide` length instead.
	var topSafeAreaInset: CGFloat {
		guard #available( iOS 11, * ) else { return topLayoutGuide.length }
		return view.safeAreaInsets.top
	}

	/// Returns distance from bottom to safe area. If running on iOS versions prior to 11,
	/// uses `bottomLayoutGuide` length instead.
	var bottomSafeAreaInset: CGFloat {
		guard #available( iOS 11, * ) else { return bottomLayoutGuide.length }
		return view.safeAreaInsets.bottom
	}
}
