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

public extension UIStackView {

	/// Adds views to the end of the arrangedSubviews array.
	func addArrangedSubviews( _ views: [ UIView ] ) {
		views.forEach { addArrangedSubview( $0 ) }
	}

	/// Removes provided views from the stack’s array of arranged subviews.
	///
	/// This method removes provided views from the stack’s arrangedSubviews array.
	/// The view’s position and size will no longer be managed by the stack view.
	/// However, this method does not remove provided views from the stack’s
	/// subviews array; therefore, the views are still displayed
	/// as part of the view hierarchy.
	func removeArrangedSubviews( _ views: [ UIView ] ) {
		views.forEach { removeArrangedSubview( $0 ) }
	}
}
