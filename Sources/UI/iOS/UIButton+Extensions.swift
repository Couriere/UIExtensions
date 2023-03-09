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

public extension UIButton {

	/// Creates a new instance of UIButton with the specified title.
	///
	/// - parameter title: The title for the normal state of the button.
	/// - returns: A new instance of UIButton with the specified title.
	///
	convenience init( _ title: String ) {
		self.init( frame: .zero )
		self.setTitle( title, for: .normal )
	}
	
	/// Creates a new instance of UIButton with the specified icon and optional title.
	///
	/// - Parameters:
	///   - icon: The image to use for the normal state of the button.
	///   - title: Optional title for the normal state of the button.
	/// - returns: A new instance of UIButton with the specified icon and optional title.
	convenience init( _ icon: UIImage?, _ title: String? = nil ) {
		self.init( frame: .zero )
		self.setTitle( title, for: .normal )
		self.setImage( icon, for: .normal )
	}
	
	/// Creates a new instance of UIButton with the specified icon name and optional title.
	///
	/// - Parameters:
	///   - icon: The name of the image to use for the normal state of the button.
	///   - title: Optional title for the normal state of the button.
	/// - returns: A new instance of UIButton with the specified icon and optional title.
	convenience init( icon: String, _ title: String? = nil ) {
		self.init( frame: .zero )
		self.setTitle( title, for: .normal )
		self.setImage( UIImage( named: icon ), for: .normal )
	}
	

	/// Creates a custom UIButton with a set of subviews arranged
	/// in a horizontal UIStackView.
	///	- parameters:
	///   - spacing: The spacing between the arranged subviews in the stack view.
	///   - alignment: The alignment of the arranged subviews in the stack view.
	///	  - dimsOnTouch: Whether the alpha of the button's content
	/// should be reduced when the button is touched. Defaults to true.
	///	  - content: A closure that returns an array of UIView objects
	/// to be arranged in a horizontal stack view.
	///
	/// This method provides a convenient way to create a custom button
	/// with a horizontal stack of subviews.
	/// The content closure should return an array of views to be arranged
	/// horizontally in the stack view.
	/// If only one view is returned, it will be used directly
	/// as the content view of the button.
	/// If multiple views are returned, they will be arranged
	/// in a horizontal stack view with the specified spacing and alignment.
	///
	/// The content view of the button is set to be user interaction disabled
	///
	/// If dimsOnTouch is true, the alpha of the content view will be reduced
	/// when the button is touched to provide visual feedback.
	///
	convenience init(
		spacing: Double = 8,
		alignment: UIStackView.Alignment = .center,
		dimsOnTouch: Bool = true,
		@UIViewBuilder _ content: () -> [UIView]
	) {
		self.init( type: .custom )

		let contentViews = content()
		precondition( contentViews.isNotEmpty )

		let contentView: UIView

		if contentViews.count == 1 {
			contentView = contentViews[ 0 ]
		} else {
			contentView = UIStackView(
				.horizontal,
				spacing: spacing,
				alignment: alignment,
				content
			)
		}
		contentView.isUserInteractionEnabled = false
		contentView.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview( contentView )
		contentView.pin()
		
		if dimsOnTouch {
			addHandler( for: .allTouchEvents ) {
				// Pause to update the `isHighlighted` state.
				DispatchQueue.main.async { [unowned self] in
					contentView.alpha = isHighlighted ? 0.5 : 1
				}
			}
		}
	}
}
#endif
