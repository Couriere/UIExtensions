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

public extension UIView {

	/// A view that pads this view inside the specified edge insets with
	/// specified amount of padding.
	func padding(
		_ edges: Edges = .all,
		_ length: Double = 16,
		forceNewContainer: Bool = false
	) -> UIView {
		let insets = UIEdgeInsets(
			top: edges.contains( .top ) ? length : 0,
			left: edges.contains( .leading ) ? length : 0,
			bottom: edges.contains( .bottom ) ? length : 0,
			right: edges.contains( .trailing ) ? length : 0
		)
		return padding( insets )
	}

	/// A view that pads this view inside the specified edge insets with
	/// specified amount of padding.
	func padding( _ length: Double = 16 ) -> UIView {
		padding( .all, length )
	}


	func padding(
		_ insets: UIEdgeInsets,
		forceNewContainer: Bool = false
	) -> UIView {
		if !forceNewContainer, let paddingContainer = self as? PaddingContainer {
			paddingContainer.updateConstants( insets: insets )
			return paddingContainer
		} else {
			let paddingContainer = PaddingContainer( containedView: self )
			paddingContainer.updateConstants( insets: insets )
			return paddingContainer
		}
	}
}

/// Container that envelops supplied view with optional insets.
open class PaddingContainer: UIView {

	private var paddingConstraints: [ Edges : NSLayoutConstraint ]!

	fileprivate init( containedView: UIView ) {

		super.init( frame: .zero )

		translatesAutoresizingMaskIntoConstraints = false
		containedView.translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .clear


		addSubview( containedView )
		let constraints: [ ( Edges, NSLayoutConstraint ) ] = [
			( .leading, containedView.leadingAnchor.constraint( equalTo: self.leadingAnchor )),
			( .trailing, self.trailingAnchor.constraint( equalTo: containedView.trailingAnchor )),
			( .top, containedView.topAnchor.constraint( equalTo: self.topAnchor )),
			( .bottom, self.bottomAnchor.constraint( equalTo: containedView.bottomAnchor ))
		]

		paddingConstraints = Dictionary( uniqueKeysWithValues: constraints )
		NSLayoutConstraint.activate( constraints.map { $1 } )
	}
	public override init( frame: CGRect ) {
		fatalError("init(frame:) has not been implemented")
	}
	public required convenience init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open override func hitTest(
		_ point: CGPoint,
		with event: UIEvent?
	) -> UIView? {
		guard let hitView = super.hitTest( point, with: event ) else {
			return nil
		}
		return hitView == self ? nil : hitView
	}
}

private extension PaddingContainer {

	func updateConstants( insets: UIEdgeInsets ) {
		paddingConstraints[ .top ]!.constant += insets.top
		paddingConstraints[ .leading ]!.constant += insets.left
		paddingConstraints[ .bottom ]!.constant += insets.bottom
		paddingConstraints[ .trailing ]!.constant += insets.right
	}
}
#endif
