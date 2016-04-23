//
//  Numbers+Strings.swift
//
//  Created by Vladimir Kazantsev on 22.01.15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

extension Int {
	func toString() -> String {
		return "\( self )"
	}
}

extension Float {
	func toString() -> String {
		return "\( self )"
	}
	func toString( precisionString: String ) -> String {
		return String( format: "%" + precisionString + "f", self )
	}
}

extension NSTimeInterval {
	var toString: String {
		let seconds = Int( isNaN ? 0 : self )
		return String( format: "%.2d:%.2d:%.2d", seconds / 3600, seconds % 3600 / 60, seconds % 60 )
	}
}


infix operator |= { associativity left precedence 140 }
func |= ( inout left: Bool, right: Bool ) {
	left = left || right
}

func *= ( inout left: CGRect, right: CGFloat ) {
	left = CGRect( x: left.origin.x * right, y: left.origin.y * right, width: left.size.width * right, height: left.size.height * right )
}