//
//  ContainerView.swift
//  UIExtensions
//
//  Created by Vladimir Kazantsev on 18.12.2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

/// Container that envelops supplied view with optional insets.
/// Each inset can be made flexible.
open class ContainerView: UIView {

	/// Constraint flexibility options.
	public struct Options: OptionSet {
		public let rawValue: Int

		public init( rawValue: ContainerView.Options.RawValue ) {
			self.rawValue = rawValue
		}

		/// Flexible left constraint.
		public static let flexibleLeft = Options( rawValue: 1 << 0 )
		/// Flexible right constraint.
		public static let flexibleRight = Options( rawValue: 1 << 1 )
		/// Flexible top constraint.
		public static let flexibleTop = Options( rawValue: 1 << 2 )
		/// Flexible bottom constraint.
		public static let flexibleBottom = Options( rawValue: 1 << 3 )
	}

	public init( containedView: UIView, insets: UIEdgeInsets = .zero, options: Options = [] ) {
		super.init( frame: containedView.frame.inset( by: insets.inverted ) )

		addSubview( containedView )
		containedView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate( [
			containedView.leftAnchor.constraint( to: self.leftAnchor,
			                                     greaterRelation: options.contains( .flexibleLeft ),
			                                     constant: insets.left ),
			self.rightAnchor.constraint( to: containedView.rightAnchor,
			                             greaterRelation: options.contains( .flexibleRight ),
			                             constant: insets.right ),
			containedView.topAnchor.constraint( to: self.topAnchor,
			                                    greaterRelation: options.contains( .flexibleTop ),
			                                    constant: insets.top ),
			self.bottomAnchor.constraint( to: containedView.bottomAnchor,
			                              greaterRelation: options.contains( .flexibleBottom ),
			                              constant: insets.bottom ),
		])
	}

	public required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


private extension NSLayoutAnchor {

	@discardableResult
	@objc func constraint( to anchor: NSLayoutAnchor<AnchorType>,
	                       greaterRelation: Bool, constant: CGFloat ) -> NSLayoutConstraint {

		if greaterRelation {
			return constraint( greaterThanOrEqualTo: anchor, constant: constant )
		}
		else {
			return constraint( equalTo: anchor, constant: constant )
		}
	}
}
