//
//  UIView+Constraints.swift
//
//  Created by Vladimir Kazantsev
//  Copyright (c) 2014. All rights reserved.
//

import UIKit

extension UILayoutGuide: LayoutGuideProtocol {}
extension UIView: LayoutGuideProtocol {
	public var owningView: UIView? { return superview }
}

public extension UIView {
	
	func removeOutsideConstraints() {
		if let superview = self.superview {
			let viewZIndex = superview.subviews.index( of: self )
			self.removeFromSuperview()
			superview.insertSubview( self, at: viewZIndex ?? superview.subviews.count )
		}
	}
	
	func removeAllConstraints() {
		// Removing all constraints for self even from superview
		removeOutsideConstraints()
		self.removeConstraints( constraints )
	}
	
	// MARK: - Calculating autolayout view size
	func systemLayoutSizeFittingSize( _ targetSize: CGSize, constrainedToWidth width: CGFloat ) -> CGSize {
		let constraint = constrainTo( width: width )
		let size = systemLayoutSizeFitting( targetSize )
		constraint.isActive = false
		return size
	}
}


public extension LayoutGuideProtocol {
	
	var parentViewController: UIViewController? {
		
		var parent: UIResponder? = ( self as? UIResponder ) ?? self.owningView
		repeat {
			if parent!.isKind( of: UIViewController.self ) { break }
			parent = parent?.next
		} while parent != nil
		
		return parent as? UIViewController;
	}


	@discardableResult
	func constrainHorizontallyToSuperview( inset: CGFloat = 0, constrainToMargins: Bool = false ) -> [ NSLayoutConstraint ] {
		
		let secondItem: LayoutGuideProtocol = constrainToMargins ? owningView!.layoutMarginsGuide : owningView!
		
		let constraints = [
			leadingAnchor.constraint( equalTo: secondItem.leadingAnchor, constant: inset ),
			secondItem.trailingAnchor.constraint( equalTo: trailingAnchor, constant: inset )
			]
		
		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	@discardableResult
	func constrainVerticallyToSuperview( inset: CGFloat = 0, constrainToMargins: Bool = false ) -> [ NSLayoutConstraint ] {

		let secondItem: LayoutGuideProtocol = constrainToMargins ? owningView!.layoutMarginsGuide : owningView!
		
		let constraints = [
			topAnchor.constraint( equalTo: secondItem.topAnchor, constant: inset ),
			secondItem.bottomAnchor.constraint( equalTo: bottomAnchor, constant: inset ),
			]
		
		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	@available ( iOS 11, tvOS 11, * )
	@discardableResult
	func constrainVerticallyToSuperviewSafeAreaGuides( inset: CGFloat = 0 ) -> [ NSLayoutConstraint ] {
		
		let constraints = [
			topAnchor.constraint( equalTo: owningView!.safeAreaLayoutGuide.topAnchor, constant: inset ),
			owningView!.safeAreaLayoutGuide.bottomAnchor.constraint( equalTo: bottomAnchor, constant: inset ),
			]
		
		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	@discardableResult
	func constrainToSuperview( insets: UIEdgeInsets = .zero, constrainToMargins: Bool = false ) -> [ NSLayoutConstraint ] {
		
		let secondItem: LayoutGuideProtocol = constrainToMargins ? owningView!.layoutMarginsGuide : owningView!
		
		let constraints = [
			topAnchor.constraint( equalTo: secondItem.topAnchor, constant: insets.top ),
			leadingAnchor.constraint( equalTo: secondItem.leadingAnchor, constant: insets.left ),
			secondItem.bottomAnchor.constraint( equalTo: bottomAnchor, constant: insets.bottom ),
			secondItem.trailingAnchor.constraint( equalTo: trailingAnchor, constant: insets.right ),
			]
		
		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	@available ( iOS 11, tvOS 11, * )
	@discardableResult
	func constrainToSuperviewSafeAreaGuides( insets: UIEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {
		
		let safeAreaGuide = owningView!.safeAreaLayoutGuide
		let constraints = [
			topAnchor.constraint( equalTo: safeAreaGuide.topAnchor, constant: insets.top ),
			leadingAnchor.constraint( equalTo: safeAreaGuide.leadingAnchor, constant: insets.left ),
			safeAreaGuide.bottomAnchor.constraint( equalTo: bottomAnchor, constant: insets.bottom ),
			safeAreaGuide.trailingAnchor.constraint( equalTo: trailingAnchor, constant: insets.right ),
			]
		
		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	/// Constrains views leading, trailing and bottom to corresponding superview sides
	/// and top of the view to either safe area top on `iOS 11+` or top layout guide.
	@discardableResult
	func constrainToSuperviewTopLayoutGuides( insets: UIEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {
		
		let constraints = [
			constrainToTopLayoutGuide( inset: insets.top ),
			leadingAnchor.constraint( equalTo: owningView!.leadingAnchor, constant: insets.left ),
			owningView!.bottomAnchor.constraint( equalTo: bottomAnchor, constant: insets.bottom ),
			owningView!.trailingAnchor.constraint( equalTo: trailingAnchor, constant: insets.right ),
			]
		
		NSLayoutConstraint.activate( constraints )
		return constraints
	}
	
	/// Constrains views top to either safe area top of superview on `iOS 11+`
	/// or its top layout guide.
	@discardableResult
	func constrainToTopLayoutGuide( inset: CGFloat = 0 ) -> NSLayoutConstraint {

		let constraint: NSLayoutConstraint
		if #available( iOS 11, tvOS 11, * ) {
			let topGuide = ( self as? UIView )?.safeAreaLayoutGuide ?? owningView!.safeAreaLayoutGuide
			constraint = topAnchor.constraint( equalTo: topGuide.topAnchor, constant: inset )
		} else {
			let topGuide = parentViewController!.topLayoutGuide
			constraint = topAnchor.constraint( equalTo: topGuide.bottomAnchor, constant: inset )
		}
		constraint.isActive = true
		return constraint
	}
	
	@discardableResult
	func constrainToBottomLayoutGuide( inset: CGFloat = 0 ) -> NSLayoutConstraint {
		
		let constraint: NSLayoutConstraint
		if #available( iOS 11, tvOS 11, * ) {
			let bottomGuide = ( self as? UIView )?.safeAreaLayoutGuide ?? owningView!.safeAreaLayoutGuide
			constraint = bottomGuide.bottomAnchor.constraint( equalTo: bottomAnchor, constant: inset )
		} else {
			let bottomGuide = parentViewController!.bottomLayoutGuide
			constraint = bottomGuide.topAnchor.constraint( equalTo: bottomAnchor, constant: inset )
		}
		constraint.isActive = true
		return constraint
	}

	
	
	// MARK: - Centering

	@discardableResult
	func centerInSuperview( priority: UILayoutPriority = .required ) -> [ NSLayoutConstraint ] {
		return [
			centerHorizontallyInSuperview( priority: priority ),
			centerVerticallyInSuperview( priority: priority )
		]
	}
	
	@discardableResult
	func centerWithView( _ view: LayoutGuideProtocol, priority: UILayoutPriority = .required ) -> [ NSLayoutConstraint ] {
		return [
			centerHorizontallyWithView( view, priority: priority ),
			centerVerticallyWithView( view, priority: priority )
		]
	}
	
		
	// MARK: - Horizontal center
		
		
	@discardableResult
	func centerHorizontallyInSuperview( _ constant: CGFloat = 0, priority: UILayoutPriority = .required ) -> NSLayoutConstraint {
		return centerHorizontallyWithView( owningView!, constant: constant, priority: priority )
	}

	@discardableResult
	func centerHorizontallyWithView( _ view: LayoutGuideProtocol, constant: CGFloat = 0, priority: UILayoutPriority = .required ) -> NSLayoutConstraint {
		
		let constraint = centerXAnchor.constraint( equalTo: view.centerXAnchor, constant: constant )
		constraint.priority = priority
		constraint.isActive = true
		return constraint
	}

	// MARK: - Vertical center
	
	@discardableResult func centerVerticallyInSuperview( _ constant: CGFloat = 0, priority: UILayoutPriority = .required ) -> NSLayoutConstraint	{
		return centerVerticallyWithView( owningView!, constant: constant, priority: priority )
	}
	
	@discardableResult func centerVerticallyWithView( _ view: LayoutGuideProtocol, constant: CGFloat = 0, priority: UILayoutPriority = .required ) -> NSLayoutConstraint	{

		let constraint = centerYAnchor.constraint( equalTo: view.centerYAnchor, constant: constant )
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
	@discardableResult func align( attribute: NSLayoutAttribute,
								   withView guide: LayoutGuideProtocol,
								   viewAttribute: NSLayoutAttribute? = nil,
								   relation: NSLayoutRelation = .equal,
								   constant: CGFloat = 0,
								   multiplier: CGFloat = 1,
								   priority: UILayoutPriority = .required ) -> NSLayoutConstraint {

		let constraint = NSLayoutConstraint( item: self, attribute: attribute, relatedBy: relation,
		                                     toItem: guide, attribute: viewAttribute ?? attribute, multiplier: multiplier, constant: constant )
		constraint.priority = priority
		constraint.isActive = true
		return constraint
	}
	
	@discardableResult
	func alignVertically( to guide: LayoutGuideProtocol, insets: UIEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {
		let constraints = [
			self.topAnchor.constraint( equalTo: guide.topAnchor, constant: insets.top ),
			guide.bottomAnchor.constraint( equalTo: self.bottomAnchor, constant: insets.bottom ),
			]
		
		NSLayoutConstraint.activate( constraints )
		return constraints
	}
	
	@discardableResult
	func alignHorizontally( to guide: LayoutGuideProtocol, insets: UIEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {
		let constraints = [
			self.leftAnchor.constraint( equalTo: guide.leftAnchor, constant: insets.left ),
			guide.rightAnchor.constraint( equalTo: self.rightAnchor, constant: insets.right ),
			]
		
		NSLayoutConstraint.activate( constraints )
		return constraints
	}
	
	@discardableResult
	func align( to guide: LayoutGuideProtocol, insets: UIEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {
		let constraints = [
			self.topAnchor.constraint( equalTo: guide.topAnchor, constant: insets.top ),
			self.leftAnchor.constraint( equalTo: guide.leftAnchor, constant: insets.left ),
			guide.bottomAnchor.constraint( equalTo: self.bottomAnchor, constant: insets.bottom ),
			guide.rightAnchor.constraint( equalTo: self.rightAnchor, constant: insets.right ),
			]
		
		NSLayoutConstraint.activate( constraints )
		return constraints
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
	@discardableResult
	func constrainWithFormat( _ format: String,
							  views: [ String: LayoutGuideProtocol ]? = nil,
							  metrics: [ String: CGFloat ]? = nil ) -> [ NSLayoutConstraint ] {

		var mutableViews = views ?? [:]
		mutableViews[ "self" ] = self
		
		let constraints = NSLayoutConstraint.constraints( withVisualFormat: format, options: [], metrics: metrics, views: mutableViews )
		constraints.forEach { $0.isActive = true }
		return constraints
	}
}



public protocol LayoutGuideProtocol {
	
	var owningView: UIView? { get }
	
	var leadingAnchor: NSLayoutXAxisAnchor { get }
	var trailingAnchor: NSLayoutXAxisAnchor { get }
	var leftAnchor: NSLayoutXAxisAnchor { get }
	var rightAnchor: NSLayoutXAxisAnchor { get }
	var topAnchor: NSLayoutYAxisAnchor { get }
	var bottomAnchor: NSLayoutYAxisAnchor { get }
	var widthAnchor: NSLayoutDimension { get }
	var heightAnchor: NSLayoutDimension { get }
	var centerXAnchor: NSLayoutXAxisAnchor { get }
	var centerYAnchor: NSLayoutYAxisAnchor { get }
}

