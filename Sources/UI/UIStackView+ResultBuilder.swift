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

public func CustomSpacing( _ length: CGFloat ) -> UIView {
	UIStackView._CustomBuilderSpacer( length )
}

public extension UIStackView {

	@resultBuilder
	class StackViewBuilder {
		public static func buildBlock( _ children: StackViewBuilderArgument... ) -> [ UIView ] {
			return children.flatMap { $0.arrayOfViews }
		}

		public static func buildOptional( _ component: StackViewBuilderArgument? ) -> [ UIView ] {
			component?.arrayOfViews ?? []
		}

		public static func buildEither( first component: StackViewBuilderArgument ) -> [ UIView ] {
			component.arrayOfViews
		}
		public static func buildEither( second component: StackViewBuilderArgument ) -> [ UIView ] {
			component.arrayOfViews
		}

		public static func buildArray( _ components: [StackViewBuilderArgument] ) -> [ UIView ] {
			components.flatMap { $0.arrayOfViews }
		}
	}

	convenience init(
		axis: NSLayoutConstraint.Axis = .vertical,
		spacing: CGFloat = 0,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .fill,
		@StackViewBuilder _ builder: () -> [ UIView ]
	) {
		self.init()
		self.translatesAutoresizingMaskIntoConstraints = false
		self.axis = axis
		self.spacing = spacing
		self.distribution = distribution
		self.alignment = alignment

		addArrangedSubviews( builder )
	}

	func addArrangedSubviews( @StackViewBuilder _ builder: () -> [ UIView ] ) {
		var customSpaces: [ UIView : CGFloat ] = [:]
		var arrangedSubviews: [ UIView ] = []
		for view in builder() {
			if let customSpacing = view as? _CustomBuilderSpacer {
				arrangedSubviews.last.then { customSpaces[ $0 ] = customSpacing.length }
			} else {
				arrangedSubviews.append( view )
			}
		}
		self.addArrangedSubviews( arrangedSubviews )
		customSpaces.forEach { self.setCustomSpacing( $1, after: $0 )}
	}
}

public protocol StackViewBuilderArgument {
	var arrayOfViews: [ UIView ] { get }
}
extension UIView: StackViewBuilderArgument {
	public var arrayOfViews: [UIView] { [ self ] }
}
extension Array: StackViewBuilderArgument where Element: UIView {
	public var arrayOfViews: [UIView] { self }
}


private extension UIStackView {
	final class _CustomBuilderSpacer: UIView {
		let length: CGFloat
		init( _ length: CGFloat ) {
			self.length = length
			super.init(frame: .zero)
		}
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
#endif
