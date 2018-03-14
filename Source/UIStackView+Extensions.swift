//
//  UIStackView+Extensions.swift
//
//  Created by Vladimir Kazantsev on 14.03.2018.
//  Copyright © 2018 MC2Soft. All rights reserved.
//

import UIKit

public extension UIStackView {
	
	public func addArrangedSubviews( _ views: [ UIView ] ) {
		views.forEach { addArrangedSubview( $0 ) }
	}

	public func removeArrangedSubviews( _ views: [ UIView ] ) {
		views.forEach { removeArrangedSubview( $0 ) }
	}
	
	public func removeAllArrangedSubviews() {
		arrangedSubviews.forEach { removeArrangedSubview( $0 ) }
	}
}
