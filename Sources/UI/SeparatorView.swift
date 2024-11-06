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

public final class SeparatorView: UIView {

	public enum Side {
		case top, left, bottom, right
	}

	@discardableResult
	public static func create(
		in view: UIView,
		attachedTo side: Side,
		color: UIColor = UIColor( white: 0, alpha: 0.2 ),
		insets: UIEdgeInsets = .zero,
		length: CGFloat = 1 / UIScreen.main.scale
	) -> SeparatorView {

		let axis: NSLayoutConstraint.Axis = side.isIn( .top, .bottom ) ? .horizontal : .vertical
		let separator = SeparatorView( axis: axis, color: color, length: length )
		view.addSubview( separator )
		separator.attach( to: side, insets: insets )

		return separator
	}

	public func attach(
		to side: Side,
		insets: UIEdgeInsets = .zero
	) {

		switch side {
		case .top, .bottom:
			pinAttribute( .left, constant: insets.left )
			pinAttribute( .right, constant: -insets.right )
			pinAttribute( side == .top ? .top : .bottom,
				 constant: side == .top ? insets.top : -insets.bottom )
		case .left, .right:
			pinAttribute( .top, constant: insets.top )
			pinAttribute( .bottom, constant: -insets.bottom )
			pinAttribute( side == .left ? .left : .right,
				 constant: side == .left ? insets.left : -insets.right )
		}
	}

	public init(
		axis: NSLayoutConstraint.Axis = .horizontal,
		color: UIColor = UIColor( white: 0, alpha: 0.2 ),
		length: CGFloat = 1 / UIScreen.main.scale
	) {
		super.init( frame: .zero )
		backgroundColor = color
		translatesAutoresizingMaskIntoConstraints = false
		switch axis {
		case .horizontal: constrain( height: length )
		case .vertical: constrain( width: length )
		@unknown default: fatalError()
		}
	}

	required public init?( coder aDecoder: NSCoder ) {
		super.init( coder: aDecoder )
	}

	// For convenience, if you need one pixel height/width separator in Xib or Storyboard,
	// add UIView, assign `SeparatorView` as its class name, add position constraints,
	// and add height or width (depending on the type of the separator you need ) constraint
	// with a constant value of one. After initialization, this constraint will change to
	// one pixel height or width.
	override public func awakeFromNib() {
		super.awakeFromNib()

		// It will almost certanly be called on main thread. 🤔
		MainActor.assumeIsolated {
			
			// Looking for height constraint and setting it to exactly one pixel.
			for constraint in constraints where constraint.firstItem === self && constraint.firstAttribute == .height {
				constraint.constant = 1 / UIScreen.main.scale
				return
			}
			
			// Looking for width constraint and setting it to exactly one pixel.
			for constraint in constraints where constraint.firstItem === self && constraint.firstAttribute == .width {
				constraint.constant = 1 / UIScreen.main.scale
				break
			}
		}
	}
}
#endif
