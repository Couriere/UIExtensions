//
//  Dictionary+Extensions.swift
//
//  Created by Vladimir Kazantsev on 04.04.17.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit
import CoreGraphics

public extension CGRect {

	/// Center of rect property.
	var center: CGPoint {
		get { return CGPoint( x: midX, y: midY ) }
		set { origin = CGPoint( x: newValue.x - width / 2, y: newValue.y - height / 2 ) }
	}
}


public extension UIEdgeInsets {
	
	public init( constantInset inset: CGFloat ) {
		self.init( top: inset, left: inset, bottom: inset, right: inset )
	}

	public init( horizontal: CGFloat = 0, vertical: CGFloat = 0 ) {
		self.init( top: vertical, left: horizontal, bottom: vertical, right: horizontal )
	}
}
