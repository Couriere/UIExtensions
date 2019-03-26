//
//  Dictionary+Extensions.swift
//
//  Created by Vladimir Kazantsev on 04.04.17.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit
import CoreGraphics

public extension CGPoint {

	/// Returns distance between self and provided point.
	func distance( to point: CGPoint ) -> CGFloat {

		let c1 = x - point.x
		let c2 = y - point.y
		let distance = sqrt( c1 * c1 + c2 * c2  )

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

	init( square side: Int ) {
		self.init( x: 0, y: 0, width: side, height: side )
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
