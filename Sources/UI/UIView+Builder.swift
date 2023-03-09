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

public func CustomSpacing( _ length: CGFloat ) -> XTView {
	XTStackView._CustomBuilderSpacer( length )
}

@resultBuilder
public class UIViewBuilder {
	public static func buildBlock( _ children: UIViewBuilderArgument... ) -> [ XTView ] {
		return children.flatMap { $0.arrayOfViews }
	}

	public static func buildOptional( _ component: UIViewBuilderArgument? ) -> [ XTView ] {
		component?.arrayOfViews ?? []
	}

	public static func buildEither( first component: UIViewBuilderArgument ) -> [ XTView ] {
		component.arrayOfViews
	}
	public static func buildEither( second component: UIViewBuilderArgument ) -> [ XTView ] {
		component.arrayOfViews
	}

	public static func buildArray( _ components: [UIViewBuilderArgument] ) -> [ XTView ] {
		components.flatMap { $0.arrayOfViews }
	}
}

public protocol UIViewBuilderArgument {
	var arrayOfViews: [ XTView ] { get }
}
extension XTView: UIViewBuilderArgument {
	public var arrayOfViews: [XTView] { [ self ] }
}
extension Array: UIViewBuilderArgument where Element: XTView {
	public var arrayOfViews: [XTView] { self }
}


internal extension XTStackView {
	final class _CustomBuilderSpacer: XTView {
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
