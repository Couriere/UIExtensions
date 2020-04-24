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

public extension UIViewController {

	/// Returns distance from top to safe area. If running on iOS versions prior to 11,
	/// uses `topLayoutGuide` length instead.
	var topSafeAreaInset: CGFloat {
		guard #available( iOS 11, tvOS 11, * ) else { return topLayoutGuide.length }
		return view.safeAreaInsets.top
	}

	/// Returns distance from bottom to safe area. If running on iOS versions prior to 11,
	/// uses `bottomLayoutGuide` length instead.
	var bottomSafeAreaInset: CGFloat {
		guard #available( iOS 11, tvOS 11, * ) else { return bottomLayoutGuide.length }
		return view.safeAreaInsets.bottom
	}
}