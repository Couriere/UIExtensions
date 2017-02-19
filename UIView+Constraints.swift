//
//  UIView+Constraints.swift
//
//  Created by Vladimir Kazantsev
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

extension UIView {
	
	var parentViewController: UIViewController? {

		var parent: UIResponder? = self
		repeat {
			if parent!.isKind( of: UIViewController.self ) { break }
			parent = parent?.next
		} while parent != nil
		
		return parent as? UIViewController;
	}
	
	func removeOutsideConstraints() {
		if let superview = self.superview {
			self.removeFromSuperview()
			superview.addSubview( self )
		}
	}
	
	func removeAllConstraints() {
		// Removing all constraints for self even from superview
		removeOutsideConstraints()
		self.removeConstraints( constraints )
	}
	
	@discardableResult
	func constrainHorizontallyToSuperview( inset: CGFloat = 0 ) -> [ NSLayoutConstraint ] {
		let bindings = [ "self": self ]
		let constraints = NSLayoutConstraint
			.constraints( withVisualFormat: "H:|-(inset)-[self]-(inset)-|",
			                              options: [], metrics: [ "inset": inset ], views: bindings )
		constraints.forEach { $0.isActive = true }
		return constraints
	}
	
	@discardableResult
	func constrainVerticallyToSuperview( inset: CGFloat = 0 ) -> [ NSLayoutConstraint ] {
		let bindings = [ "self": self ]
		let constraints = NSLayoutConstraint
			.constraints( withVisualFormat: "V:|-(inset)-[self]-(inset)-|",
			                              options: [], metrics: [ "inset": inset ], views: bindings )
		constraints.forEach { $0.isActive = true }
		return constraints
	}

	@discardableResult
	func constrainToSuperview( insets: UIEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {
		
		let constraints = [
			NSLayoutConstraint( item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: insets.left ),
			NSLayoutConstraint( item: superview!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: insets.right ),
			NSLayoutConstraint( item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: insets.top ),
			NSLayoutConstraint( item: superview!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: insets.bottom )
		]

		constraints.forEach { $0.isActive = true }
		return constraints
	}
	
	@discardableResult
	func constrainToSuperviewWithTopLayoutGuide() -> [ NSLayoutConstraint ] {
		let bindings: [ String: AnyObject ] = [ "self": self, "topGuide": parentViewController!.topLayoutGuide ]
		let constraints = [
			NSLayoutConstraint.constraints( withVisualFormat: "H:|[self]|", options: [], metrics: nil, views: bindings ),
			NSLayoutConstraint.constraints( withVisualFormat: "V:[topGuide][self]|", options: [], metrics: nil, views: bindings ) ].flatMap { $0 }
		constraints.forEach { $0.isActive = true }
		return constraints
	}
	
	@discardableResult
	func constrainToTopLayoutGuide() -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .top, relatedBy: .equal,
			toItem: parentViewController!.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0 )
		constraint.isActive = true
		return constraint
	}
	
	@discardableResult
	func constrainToBottomLayoutGuide() -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .bottom, relatedBy: .equal,
			toItem: parentViewController!.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0 )
		constraint.isActive = true
		return constraint
	}

	
	
	// MARK: - Centering

	@discardableResult
	func centerInSuperview() -> [ NSLayoutConstraint ] {
		return [ centerHorizontallyInSuperview(), centerVerticallyInSuperview() ]
	}
	
	@discardableResult
	func centerWithView( _ view: UIView ) -> [ NSLayoutConstraint ] {
		return [ centerHorizontallyWithView( view ), centerVerticallyWithView( view ) ]
	}
	
		
	// MARK: - Horizontal center
		
		
	@discardableResult
	func centerHorizontallyInSuperview( _ constant: CGFloat = 0, priority: UILayoutPriority = 1000 ) -> NSLayoutConstraint {
		return centerHorizontallyWithView( superview!, constant: constant, priority: priority )
	}

	@discardableResult
	func centerHorizontallyWithView( _ view: UIView, constant: CGFloat = 0, priority: UILayoutPriority = 1000 ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .centerX, relatedBy: .equal,
			toItem: view, attribute: .centerX, multiplier: 1, constant: constant )
		constraint.priority = priority
		constraint.isActive = true
		return constraint
	}

	// MARK: - Vertical center
	
	@discardableResult func centerVerticallyInSuperview( _ constant: CGFloat = 0, priority: UILayoutPriority = 1000 ) -> NSLayoutConstraint	{
		return centerVerticallyWithView( superview!, constant: constant, priority: priority )
	}
	
	@discardableResult func centerVerticallyWithView( _ view: UIView, constant: CGFloat = 0, priority: UILayoutPriority = 1000 ) -> NSLayoutConstraint	{
		let constraint = NSLayoutConstraint( item: self, attribute: .centerY, relatedBy: .equal,
			toItem: view, attribute: .centerY, multiplier: 1, constant: constant )
		constraint.priority = priority
		constraint.isActive = true
		return constraint
	}
	
	

	// MARK: - Alignment constraints.
	
	/**
		Constrain receiver to another view.
		- parameter attribute: Receiver attribute to constrain to.
		- parameter view: View to constrain receiver to.
		- parameter attribute: Attribute of another view to constrain receiver to. If `nil` it become equal to `attribute`.
		- parameter constant: Constant of a newly created constraint. Defaults to zero.
		- parameter priority: Priority of a newly created constraint. Defaults to `Required`
	*/
	@discardableResult func align( attribute: NSLayoutAttribute, withView view: UIView,
	                      viewAttribute: NSLayoutAttribute? = nil,
	                      relation: NSLayoutRelation = .equal,
	                      constant: CGFloat = 0, priority: UILayoutPriority = 1000 ) -> NSLayoutConstraint {
		
		let constraint = NSLayoutConstraint( item: self, attribute: attribute, relatedBy: relation,
		                                     toItem: view, attribute: viewAttribute ?? attribute, multiplier: 1, constant: constant )
		constraint.priority = priority
		constraint.isActive = true
		return constraint
	}
	
	
	
	// MARK: - Size constraints
	
	@discardableResult func constrainTo( width: CGFloat, relatedBy: NSLayoutRelation? = nil ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .width, relatedBy: relatedBy ?? .equal,
			toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width )
		constraint.isActive = true
		return constraint
	}
	
	@discardableResult func constrainTo( height: CGFloat, relatedBy: NSLayoutRelation? = nil ) -> NSLayoutConstraint	{
		let constraint = NSLayoutConstraint( item: self, attribute: .height, relatedBy: relatedBy ?? .equal,
			toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height )
		constraint.isActive = true
		return constraint
	}
	
	@discardableResult func constrainTo( size: CGSize ) -> [ NSLayoutConstraint ] {
		return [ constrainTo( width: size.width ),
		         constrainTo( height: size.height ) ]
	}

	@discardableResult func equalSizeWithView( _ view: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1 ) -> [ NSLayoutConstraint ] {
		return [ equalWidthWithView( view, constant: constant, multiplier: multiplier ),
				 equalHeightWithView( view, constant: constant, multiplier: multiplier ) ]
	}

	@discardableResult func equalHeightWithView( _ view: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1 ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .height, relatedBy: .equal,
			toItem: view, attribute: .height, multiplier: multiplier, constant: constant )
		constraint.isActive = true
		return constraint
	}

	@discardableResult func equalWidthWithView( _ view: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1 ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .width, relatedBy: .equal,
			toItem: view, attribute: .width, multiplier: multiplier, constant: constant )
		constraint.isActive = true
		return constraint
	}

	// MARK: - Aspect ratio
	@discardableResult func constrainAspectRatioTo( _ multiplier: CGFloat, constant: CGFloat = 0 ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: multiplier, constant: constant )
		constraint.isActive = true
		return constraint
	}
	
	
	// MARK: - Arbitrary format constraints
	@discardableResult func constrainWithFormat( _ format: String ) -> [ NSLayoutConstraint ] {
		return constrainWithFormat( format, views: nil, metrics: nil )
	}
	
	@discardableResult func constrainWithFormat( _ format: String, views: [ String: UIView ]? ) -> [ NSLayoutConstraint ] {
		return constrainWithFormat( format, views: views, metrics: nil )
	}
	
	@discardableResult func constrainWithFormat( _ format: String, views: [ String: UIView ]? = nil, metrics: [ String: CGFloat ]? ) -> [ NSLayoutConstraint ] {
		var mutableViews = views
		if mutableViews != nil {
			mutableViews![ "self" ] = self
		} else {
			mutableViews = [ "self": self ]
		}
		
		let constraints = NSLayoutConstraint.constraints( withVisualFormat: format, options: [], metrics: metrics, views: mutableViews! )
		constraints.forEach { $0.isActive = true }
		return constraints
	}
	
	
	// MARK: - Calculating autolayout view size
	func systemLayoutSizeFittingSize( _ targetSize: CGSize, constrainedToWidth width: CGFloat ) -> CGSize {
		let constraint = constrainTo( width: width )
		let size = systemLayoutSizeFitting( targetSize )
		constraint.isActive = false
		return size
	}
}
