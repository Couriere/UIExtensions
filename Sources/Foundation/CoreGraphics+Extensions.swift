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

import CoreGraphics

#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

public extension CGPoint {

	/// Returns a new `CGPoint` offset by specified `dx` and `dy` values.
	/// - Parameters:
	///   - dx: The offset to apply along the x-axis. Defaults to 0.
	///   - dy: The offset to apply along the y-axis. Defaults to 0.
	/// - Returns: A new `CGPoint` offset by `dx` and `dy` from the original point.
	func offset( dx: Double = 0, dy: Double = 0 ) -> CGPoint {
		CGPoint( x: x + dx, y: y + dy )
	}

	/// Returns distance between self and provided point.
	func distance( to point: CGPoint ) -> CGFloat {

		let c1 = x - point.x
		let c2 = y - point.y
		let distance = sqrt( c1 * c1 + c2 * c2 )

		return distance
	}
}

public extension CGSize {

	init( square side: Double ) { self.init( width: side, height: side ) }
	init( square side: Int ) { self.init( width: side, height: side ) }

	/// Aspect ratio of the CGSize object.
	var aspectRatio: Double { width / height }

	/// Returns whether a size has zero or negative width or height, or is an invalid size.
	var isEmpty: Bool { return !( width > 0 && height > 0 ) }
}

public extension CGSize {

	/// Adds the width and height of two `CGSize` values
	/// and returns a new `CGSize` with the combined dimensions.
	/// - Parameters:
	///   - lhs: The left-hand side `CGSize` to add.
	///   - rhs: The right-hand side `CGSize` to add.
	/// - Returns: A new `CGSize` whose width and height are the sum
	/// of the respective widths and heights of `lhs` and `rhs`.
	static func +( lhs: Self, rhs: Self ) -> CGSize {
		CGSize(
			width: lhs.width + rhs.width,
			height: lhs.height + rhs.height
		)
	}

	/// Multiplies the width and height of a `CGSize` by a floating-point value,
	/// returning a new `CGSize` scaled by the specified factor.
	/// - Parameters:
	///   - lhs: The `CGSize` to scale.
	///   - rhs: The floating-point scaling factor.
	/// - Returns: A new `CGSize` with width and height scaled by `rhs`.
	static func *<FloatingPoint>(
		lhs: Self,
		rhs: FloatingPoint
	) -> CGSize where FloatingPoint: BinaryFloatingPoint {
		CGSize(
			width: lhs.width * Double( rhs ),
			height: lhs.height * Double( rhs )
		)
	}

	/// Divides the width and height of a `CGSize` by a floating-point value,
	/// returning a new `CGSize` scaled down by the divisor.
	/// - Parameters:
	///   - lhs: The `CGSize` to scale.
	///   - rhs: The floating-point divisor.
	/// - Returns: A new `CGSize` with width and height divided by `rhs`.
	static func /<FloatingPoint>(
		lhs: Self,
		rhs: FloatingPoint
	) -> CGSize where FloatingPoint: BinaryFloatingPoint {
		lhs * ( 1 / rhs )
	}
}

public extension CGRect {

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

	/// Initializes a `CGRect` using the top-left and bottom-right corner points.
	/// - Parameters:
	///   - topLeft: The top-left corner point of the rectangle.
	///   - bottomRight: The bottom-right corner point of the rectangle.
	init( topLeft: CGPoint, bottomRight: CGPoint ) {
		self.init(
			origin: topLeft,
			size: CGSize(
				width: bottomRight.x - topLeft.x,
				height: bottomRight.y - topLeft.y
			)
		)
	}

	/// Returns a new `CGRect` inset by the specified distance on all sides.
	/// - Parameter d: The distance to inset each edge by.
	/// - Returns: A new `CGRect` with each side inset by `d`.
	@inlinable
	func insetBy( _ d: Double ) -> CGRect {
		insetBy( dx: d, dy: d )
	}

	/// Aspect ratio of the rectangle.
	var aspectRatio: Double { width / height }

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

public extension CGRect {

	/// Returns a new `CGRect` by scaling the origin and size of `rect` by
	/// a specified multiplier.
	/// - Parameters:
	///   - rect: The `CGRect` to scale.
	///   - multiplier: The factor to scale the rectangle by.
	/// - Returns: A new `CGRect` with origin and size scaled by `multiplier`.
	static func *( rect: CGRect, multiplier: CGFloat ) -> CGRect {
		CGRect(
			x: rect.origin.x * multiplier,
			y: rect.origin.y * multiplier,
			width: rect.size.width * multiplier,
			height: rect.size.height * multiplier
		)
	}

	/// Returns a new `CGRect` by dividing the origin and size of `rect`
	/// by a specified divider.
	/// - Parameters:
	///   - rect: The `CGRect` to divide.
	///   - divider: The factor to divide the rectangle by.
	/// - Returns: A new `CGRect` with origin and size divided by `divider`.
	static func /( rect: CGRect, divider: CGFloat ) -> CGRect {
		CGRect(
			x: rect.origin.x / divider,
			y: rect.origin.y / divider,
			width: rect.size.width / divider,
			height: rect.size.height / divider
		)
	}

	/// Scales the origin and size of `rect` by a specified multiplier
	/// in-place.
	/// - Parameters:
	///   - rect: The `CGRect` to scale.
	///   - multiplier: The factor to scale the rectangle by.
	static func *=( rect: inout CGRect, multiplier: CGFloat ) {
		rect = rect * multiplier
	}

	/// Divides the origin and size of `rect` by a specified divider
	/// in-place.
	/// - Parameters:
	///   - rect: The `CGRect` to divide.
	///   - divider: The factor to divide the rectangle by.
	static func /= ( rect: inout CGRect, divider: CGFloat ) {
		rect = rect / divider
	}
}


public extension XTEdgeInsets {

	init( constantInset inset: CGFloat ) {
		self.init( top: inset, left: inset, bottom: inset, right: inset )
	}

	init( _ inset: CGFloat ) {
		self.init( top: inset, left: inset, bottom: inset, right: inset )
	}

	init( horizontal: CGFloat = 0, vertical: CGFloat = 0 ) {
		self.init( top: vertical, left: horizontal, bottom: vertical, right: horizontal )
	}

	init( top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil ) {
		self.init( top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0 )
	}

	/// Inverts all insets.
	var inverted: XTEdgeInsets {
		return XTEdgeInsets( top: -top, left: -left, bottom: -bottom, right: -right )
	}

	var vertical: Double {
		top + bottom
	}

	var horizontal: Double {
		left + right
	}
}

#if canImport(AppKit)
public extension NSEdgeInsets {
	static let zero: NSEdgeInsets = NSEdgeInsets()
}
#endif

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
