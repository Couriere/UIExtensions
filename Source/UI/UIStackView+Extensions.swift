//
//  UIStackView+Extensions.swift
//
//  Created by Vladimir Kazantsev on 14.03.2018.
//  Copyright © 2018 MC2Soft. All rights reserved.
//

import UIKit

public extension UIStackView {

	/// Adds views to the end of the arrangedSubviews array.
	public func addArrangedSubviews( _ views: [ UIView ] ) {
		views.forEach { addArrangedSubview( $0 ) }
	}

	/// Removes provided views from the stack’s array of arranged subviews.
	///
	/// This method removes provided views from the stack’s arrangedSubviews array.
	/// The view’s position and size will no longer be managed by the stack view.
	/// However, this method does not remove provided views from the stack’s
	/// subviews array; therefore, the views are still displayed
	/// as part of the view hierarchy.
	public func removeArrangedSubviews( _ views: [ UIView ] ) {
		views.forEach { removeArrangedSubview( $0 ) }
	}
}
