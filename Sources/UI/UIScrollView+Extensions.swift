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

#if canImport(UIKit)
import UIKit

public extension UIScrollView {

	/// Creates a new UIScrollView with a content view containing subviews,
	/// pinned to frame layout guide horizontally
	/// and to content layout guide vertically.
	///
	/// - Parameters:
	///   - showIndicators: A Boolean value that determines whether or not
	/// the scroll view should display scroll indicators.
	///   - content: A closure that returns an array of UIViews that
	/// will be used as the content view's subviews.
	///
	/// - Returns: A new UIScrollView with the specified content view.
	///
	/// This convenience initializer simplifies the process of creating
	/// a scroll view with a content view containing multiple subviews.
	/// It takes care of setting up the scroll view's properties
	/// and adding the content view as a subview, and automatically lays
	/// out the content view to fill the scroll view.
	///
	/// - note: Scroll view subviews are pinned to frame layout guide horizontally
	/// and to content layout guide vertically.
	///
	/// If the array of subviews returned by the `content` closure
	/// contains only one view, that view is used as the content view.
	/// Otherwise, a vertical UIStackView is created with the subviews
	/// as arranged subviews.
	///
	/// Example usage:
	/// ```
	/// let scrollView = UIScrollView {
	///   [
	///     UILabel(),
	///     UIImageView(),
	///     UIButton(),
	///   ]
	/// }
	/// ```
	///
	/// or:
	/// ```
	/// let scrollView = UIScrollView {
	///     UIStackView( .horizontal ) {
	///         UILabel()
	///         UIImageView()
	///         UIButton()
	///     }
	/// }
	/// ```
	convenience init(
		showIndicators: Bool = true,
		@UIViewBuilder _ content: () -> [ UIView ] ) {

		self.init( frame: .zero )

		translatesAutoresizingMaskIntoConstraints = false
		showsVerticalScrollIndicator = showIndicators
		showsHorizontalScrollIndicator = showIndicators

		let innerView: UIView

		let builtViews = content()
		precondition( builtViews.isNotEmpty )

		if builtViews.count == 1 {
			innerView = builtViews[0]
		} else {
			innerView = UIStackView { builtViews }
		}
		
		addSubview( innerView )
		innerView.translatesAutoresizingMaskIntoConstraints = false

		innerView.pin( .horizontal, to: frameLayoutGuide )
		innerView.pin( .vertical, to: contentLayoutGuide )
	}
}

public extension UIScrollView {

	/// Constrains the width of the content inside the scroll view
	/// to be equal to the width of the scroll view's frame,
	/// with an optional constant value added to the width.
	///
	/// - parameter constant: The constant value to add to the width of the content.
	/// - returns: The layout constraint that was activated.
	///
	/// This method is useful when you want the content to stay centered
	/// in the scroll view horizontally, regardless of the size
	/// of the scroll view. To achieve this, the content inset
	/// of the scroll view is adjusted, effectively centering the content.
	///
	@discardableResult
	func constrainContentWidthToFrame( constant: CGFloat = 0 ) -> NSLayoutConstraint {
		let constraint = contentLayoutGuide.widthAnchor.constraint(
			equalTo: frameLayoutGuide.widthAnchor,
			constant: constant
		)
		constraint.isActive = true
		contentInset = UIEdgeInsets( horizontal: -constant / 2, vertical: 0 )
		return constraint
	}
}
#endif
