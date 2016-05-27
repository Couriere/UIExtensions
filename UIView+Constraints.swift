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
			if parent!.isKindOfClass( UIViewController ) { break }
			parent = parent?.nextResponder()
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
	
	func constrainToSuperview() -> [ NSLayoutConstraint ]  {
		return constrainHorizontallyToSuperview() + constrainVerticallyToSuperview()
	}
	
	func constrainHorizontallyToSuperview() -> [ NSLayoutConstraint ] {
		let bindings = [ "self": self ]
		let constraints = NSLayoutConstraint
			.constraintsWithVisualFormat( "H:|[self]|", options: [], metrics: nil, views: bindings )
		superview!.addConstraints( constraints )
		return constraints
	}
	
	func constrainVerticallyToSuperview() -> [ NSLayoutConstraint ] {
		let bindings = [ "self": self ]
		let constraints = NSLayoutConstraint.constraintsWithVisualFormat( "V:|[self]|", options: [],
		                                                                  metrics: nil, views: bindings )
		superview!.addConstraints( constraints )
		return constraints
	}
		
	func constrainToSuperviewWithTopLayoutGuide() {
		let bindings: [ String: AnyObject ] = [ "self": self, "topGuide": parentViewController!.topLayoutGuide ]
		superview!.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat( "H:|[self]|", options: [],
			metrics: nil, views: bindings ))
		superview!.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat( "V:[topGuide][self]|", options: [],
			metrics: nil, views: bindings ))
	}
	
	func constrainToTopLayoutGuide() -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .Top, relatedBy: .Equal,
			toItem: parentViewController!.topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0 )
		superview!.addConstraint( constraint )
		return constraint
	}
	
	func constrainToBottomLayoutGuide() -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .Bottom, relatedBy: .Equal,
			toItem: parentViewController!.bottomLayoutGuide, attribute: .Top, multiplier: 1, constant: 0 )
		superview!.addConstraint( constraint )
		return constraint
	}

	
	
	// MARK: - Centering

	func centerInSuperview() -> [ NSLayoutConstraint ] {
		return [ centerHorizontallyInSuperview(), centerVerticallyInSuperview() ]
	}
	
	func centerWithView( view: UIView ) -> [ NSLayoutConstraint ] {
		return [ centerHorizontallyWithView( view ), centerVerticallyWithView( view ) ]
	}
	
		
	// MARK: - Horizontal center
		
		
	func centerHorizontallyInSuperview() -> NSLayoutConstraint {
		return centerHorizontallyWithView( superview!, constant: 0, priority: 1000 )
	}
	func centerHorizontallyInSuperview( constant: CGFloat ) -> NSLayoutConstraint {
		return centerHorizontallyWithView( superview!, constant: constant, priority: 1000 )
	}
	func centerHorizontallyInSuperview( constant: CGFloat, priority: UILayoutPriority ) -> NSLayoutConstraint {
		return centerHorizontallyWithView( superview!, constant: constant, priority: priority )
	}

	func centerHorizontallyWithView( view: UIView ) -> NSLayoutConstraint {
		return centerHorizontallyWithView( view, constant: 0, priority: 1000 )
	}
	func centerHorizontallyWithView( view: UIView, constant: CGFloat ) -> NSLayoutConstraint {
		return centerHorizontallyWithView( view, constant: constant, priority: 1000 )
	}
	func centerHorizontallyWithView( view: UIView, constant: CGFloat, priority: UILayoutPriority ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .CenterX, relatedBy: .Equal,
			toItem: view, attribute: .CenterX, multiplier: 1, constant: constant )
		constraint.priority = priority
		superview!.addConstraint( constraint )
		return constraint
	}

	// MARK: - Vertical center
	
	func centerVerticallyInSuperview() -> NSLayoutConstraint {
		return centerVerticallyWithView( superview!, constant: 0, priority: 1000 )
	}
	func centerVerticallyInSuperview( constant: CGFloat ) -> NSLayoutConstraint	{
		return centerVerticallyWithView( superview!, constant: constant, priority: 1000 )
	}
	func centerVerticallyInSuperview( constant: CGFloat, priority: UILayoutPriority ) -> NSLayoutConstraint	{
		return centerVerticallyWithView( superview!, constant: constant, priority: priority )
	}
	
	func centerVerticallyWithView( view: UIView ) -> NSLayoutConstraint {
		return centerVerticallyWithView( view, constant: 0, priority: 1000 )
	}
	func centerVerticallyWithView( view: UIView, constant: CGFloat ) -> NSLayoutConstraint	{
		return centerVerticallyWithView( view, constant: constant, priority: 1000 )
	}
	func centerVerticallyWithView( view: UIView, constant: CGFloat, priority: UILayoutPriority ) -> NSLayoutConstraint	{
		let constraint = NSLayoutConstraint( item: self, attribute: .CenterY, relatedBy: .Equal,
			toItem: view, attribute: .CenterY, multiplier: 1, constant: constant )
		constraint.priority = priority
		superview!.addConstraint( constraint )
		return constraint
	}
	
	

	// MARK: - Alignment constraints.
	
	func alignAttribute( attribute: NSLayoutAttribute, withView view: UIView,
	                     constant: CGFloat = 0, priority: UILayoutPriority = 1000 ) {
		
		let constraint = NSLayoutConstraint( item: self, attribute: attribute, relatedBy: .Equal,
		                                     toItem: view, attribute: attribute, multiplier: 1, constant: constant )
		constraint.priority = priority
		superview!.addConstraint( constraint )
	}
	
	
	
	// MARK: - Size constraints
	
	func constrainTo( width width: CGFloat ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .Width, relatedBy: .Equal,
			toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width )
		self.addConstraint( constraint )
		return constraint;
	}
	
	func constrainTo( height height: CGFloat ) -> NSLayoutConstraint	{
		let constraint = NSLayoutConstraint( item: self, attribute: .Height, relatedBy: .Equal,
			toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height )
		self.addConstraint( constraint )
		return constraint;
	}
	
	func constrainTo( size size: CGSize ) {
		constrainTo( width: size.width )
		constrainTo( height: size.height )
	}

	func equalSizeWithView( view: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1 ) -> [ NSLayoutConstraint ] {
		return [ equalWidthWithView( view, constant: constant, multiplier: multiplier ),
				 equalHeightWithView( view, constant: constant, multiplier: multiplier ) ]
	}

	func equalHeightWithView( view: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1 ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .Height, relatedBy: .Equal,
			toItem: view, attribute: .Height, multiplier: multiplier, constant: constant )
		superview!.addConstraint( constraint )
		return constraint;
	}

	func equalWidthWithView( view: UIView, constant: CGFloat = 0, multiplier: CGFloat = 1 ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .Width, relatedBy: .Equal,
			toItem: view, attribute: .Width, multiplier: multiplier, constant: constant )
		superview!.addConstraint( constraint )
		return constraint;
	}

	// MARK: - Aspect ratio
	func constrainAspectRatioTo( multiplier: CGFloat, constant: CGFloat = 0 ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: multiplier, constant: constant )
		addConstraint( constraint )
		return constraint
	}
	
	
	// MARK: - Arbitrary format constraints
	func constrainWithFormat( format: String ) -> [ NSLayoutConstraint ] {
		return constrainWithFormat( format, views: nil, metrics: nil )
	}
	
	func constrainWithFormat( format: String, views: [ String: UIView ]? ) -> [ NSLayoutConstraint ] {
		return constrainWithFormat( format, views: views, metrics: nil )
	}
	
	func constrainWithFormat( format: String, views: [ String: UIView ]? = nil, metrics: [ String: CGFloat ]? ) -> [ NSLayoutConstraint ] {
		var mutableViews = views
		if mutableViews != nil {
			mutableViews![ "self" ] = self
		} else {
			mutableViews = [ "self": self ]
		}
		
		let constraints = NSLayoutConstraint.constraintsWithVisualFormat( format, options: [], metrics: metrics, views: mutableViews! )
		superview!.addConstraints( constraints )
		return constraints
	}
	
	
	// MARK: - Calculating autolayout view size
	func systemLayoutSizeFittingSize( targetSize: CGSize, constrainedToWidth width: CGFloat ) -> CGSize {
		let constraint = constrainTo( width: width )
		let size = systemLayoutSizeFittingSize( targetSize )
		removeConstraint( constraint )
		return size
	}
}
