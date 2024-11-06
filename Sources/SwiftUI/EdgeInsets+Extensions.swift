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

import SwiftUI

public extension EdgeInsets {

	init( _ inset: CGFloat ) {
		self.init( top: inset, leading: inset, bottom: inset, trailing: inset )
	}

	init( horizontal: CGFloat = 0, vertical: CGFloat = 0 ) {
		self.init( top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal )
	}

	init( top: CGFloat? = nil, leading: CGFloat? = nil,
		  bottom: CGFloat? = nil, trailing: CGFloat? = nil ) {
		self.init( top: top ?? 0, leading: leading ?? 0,
				   bottom: bottom ?? 0, trailing: trailing ?? 0 )
	}

	/// Inverts all insets.
	var inverted: EdgeInsets {
		return EdgeInsets( top: -top, leading: -leading, bottom: -bottom, trailing: -trailing )
	}
}
