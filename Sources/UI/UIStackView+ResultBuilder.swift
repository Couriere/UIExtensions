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
#elseif canImport(AppKit)
import AppKit
#endif

public extension XTStackView {

	@available( *, deprecated, renamed: "UIViewBuilder" )
	typealias StackViewBuilder = UIViewBuilder

	#if os(iOS) || os(tvOS)
	convenience init(
		_ axis: NSLayoutConstraint.Axis = .vertical,
		spacing: CGFloat = 0,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .fill,
		@UIViewBuilder _ content: () -> [ UIView ]
	) {
		self.init()
		self.translatesAutoresizingMaskIntoConstraints = false
		self.axis = axis
		self.spacing = spacing
		self.distribution = distribution
		self.alignment = alignment

		addArrangedSubviews( content )
	}
	#elseif os(macOS)
	convenience init(
		_ orientation: NSUserInterfaceLayoutOrientation = .vertical,
		spacing: CGFloat = 0,
		distribution: NSStackView.Distribution = .fill,
		alignment: NSLayoutConstraint.Attribute? = nil,
		@UIViewBuilder _ content: () -> [ NSView ]
	) {
		self.init()
		self.translatesAutoresizingMaskIntoConstraints = false
		self.orientation = orientation
		self.spacing = spacing
		self.distribution = distribution
		self.alignment = alignment ?? self.alignment

		addArrangedSubviews( content )
	}
	#endif


	func addArrangedSubviews( @UIViewBuilder _ content: () -> [ XTView ] ) {
		var customSpaces: [ XTView : CGFloat ] = [:]
		var arrangedSubviews: [ XTView ] = []
		for view in content() {
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
