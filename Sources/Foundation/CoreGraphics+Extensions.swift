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
import CoreGraphics

public extension CGPoint {

	/// Returns distance between self and provided point.
	func distance( to point: CGPoint ) -> CGFloat {

		let c1 = x - point.x
		let c2 = y - point.y
		let distance = sqrt( c1 * c1 + c2 * c2 )

		return distance
	}
}


public extension CGRect {

	static func *= ( rect: inout CGRect, multiplier: CGFloat ) {
		rect = CGRect( x: rect.origin.x * multiplier,
		               y: rect.origin.y * multiplier,
		               width: rect.size.width * multiplier,
		               height: rect.size.height * multiplier )
	}
}


public extension CGRect {

	init( square side: CGFloat ) {
		self.init( x: 0, y: 0, width: side, height: side )
	}

	init( square side: Double ) {
		self.init( x: 0, y: 0, width: side, height: side )
	}

	init( square side: Int ) {
		self.init( x: 0, y: 0, width: side, height: side )
	}

	/// Create CGRect with `.zero` origin point and supplied size.
	init( size: CGSize ) {
		self.init( origin: .zero, size: size )
	}

	/// Center of rect property.
	var center: CGPoint {
		get { return CGPoint( x: midX, y: midY ) }
		set { origin = CGPoint( x: newValue.x - width / 2, y: newValue.y - height / 2 ) }
	}

	/// Top-Left corner point.
	var topLeft: CGPoint { return CGPoint( x: minX, y: minY ) }

	/// Top-Right corner point.
	var topRight: CGPoint { return CGPoint( x: maxX, y: minY ) }

	/// Bottom-Left corner point.
	var bottomLeft: CGPoint { return CGPoint( x: minX, y: maxY ) }

	/// Bottom-Right corner point.
	var bottomRight: CGPoint { return CGPoint( x: maxX, y: maxY ) }
}

public extension CGSize {

	init( square side: CGFloat ) { self.init( width: side, height: side ) }
	init( square side: Double ) { self.init( width: side, height: side ) }
	init( square side: Int ) { self.init( width: side, height: side ) }

	/// Returns whether a size has zero or negative width or height, or is an invalid size.
	var isEmpty: Bool { return !( width > 0 && height > 0 ) }
}


public extension UIEdgeInsets {

	init( constantInset inset: CGFloat ) {
		self.init( top: inset, left: inset, bottom: inset, right: inset )
	}

	init( horizontal: CGFloat = 0, vertical: CGFloat = 0 ) {
		self.init( top: vertical, left: horizontal, bottom: vertical, right: horizontal )
	}

	init( top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil ) {
		self.init( top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0 )
	}

	/// Inverts all insets.
	var inverted: UIEdgeInsets {
		return UIEdgeInsets( top: -top, left: -left, bottom: -bottom, right: -right )
	}
}

public extension Int {

	/// Returns radians value of the receivers degrees.
	var radians: CGFloat { return .pi * CGFloat( self ) / 180 }
}

public extension CGFloat {

	/// Returns radians value of the receivers degrees.
	var radians: CGFloat { return .pi * self / 180 }

	/// Returns degree value of the receivers radians.
	var degrees: CGFloat { return self / .pi * 180 }
}
