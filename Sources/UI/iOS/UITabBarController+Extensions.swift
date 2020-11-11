// MIT License
//
// Copyright (c) 2015-present Vladimir Kazantsev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
			if let childController = viewControllers?[ selectedIndex ] {

				var newInsets = childController.additionalSafeAreaInsets
				newInsets.bottom += -offsetY

				childController.additionalSafeAreaInsets = newInsets
				childController.view.setNeedsLayout()
			}

			tabBar.frame = endFrame
		}
	}
}
