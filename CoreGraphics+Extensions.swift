//
//  Dictionary+Extensions.swift
//
//  Created by Vladimir Kazantsev on 04.04.17.
//  Copyright (c) 2015. All rights reserved.
//

import CoreGraphics

extension CGRect {

	/// Center of rect property.
	var center: CGPoint {
		get { return CGPoint( x: midX, y: midY ) }
		set { origin = CGPoint( x: newValue.x - width / 2, y: newValue.y - height / 2 ) }
	}
}


