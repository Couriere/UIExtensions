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

	/// A static instance representing zero edge insets.
	static let zero = EdgeInsets()

	/// The total vertical inset, calculated as the sum of `top`
	/// and `bottom`.
	var vertical: Double {
		top + bottom
	}

	/// The total horizontal inset, calculated as the sum of `leading`
	/// and `trailing`.
	var horizontal: Double {
		leading + trailing
	}

	/// Inverts all insets.
	var inverted: EdgeInsets {
		return EdgeInsets( top: -top, leading: -leading, bottom: -bottom, trailing: -trailing )
	}
}

extension EdgeInsets {

	/// Creates an `EdgeInsets` instance from a `UIEdgeInsets`.
	/// - parameter uiEdgeInsets: The `UIEdgeInsets` to convert.
	public init( _ uiEdgeInsets: UIEdgeInsets ) {

		self.init(
			top: uiEdgeInsets.top,
			leading: uiEdgeInsets.left,
			bottom: uiEdgeInsets.bottom,
			trailing: uiEdgeInsets.right
		)
	}

	/// Creates an `EdgeInsets` instance with all sides set to the same value.
	/// - Parameter inset: The value to apply to all sides.
	public init( _ inset: Double ) {
		self.init( top: inset, leading: inset, bottom: inset, trailing: inset )
	}

	/// Creates an `EdgeInsets` instance with specified horizontal and
	/// vertical insets.
	/// - Parameters:
	///   - horizontal: The inset to apply to `leading` and `trailing`.
	///   - vertical: The inset to apply to `top` and `bottom`.
	public init( horizontal: Double = 0, vertical: Double = 0 ) {
		self.init( top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal )
	}

	/// Creates an `EdgeInsets` instance with optional values for each side.
	/// Missing values default to 0.
	/// - Parameters:
	///   - top: The inset for the top edge, or `nil` to use 0.
	///   - leading: The inset for the leading edge, or `nil` to use 0.
	///   - bottom: The inset for the bottom edge, or `nil` to use 0.
	///   - trailing: The inset for the trailing edge, or `nil` to use 0.
	public init( top: Double? = nil, leading: Double? = nil,
		  bottom: Double? = nil, trailing: Double? = nil ) {
		self.init(
			top: CGFloat( top ?? 0 ),
			leading: CGFloat( leading ?? 0 ),
			bottom: CGFloat( bottom ?? 0 ),
			trailing: CGFloat( trailing ?? 0 )
		)
	}
}
