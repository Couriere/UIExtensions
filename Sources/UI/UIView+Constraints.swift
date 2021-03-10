// MIT License
//
// Copyright (c) 2015-present Vladimir Kazantsev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

extension XTLayoutGuide: LayoutGuideProtocol {}
extension XTView: LayoutGuideProtocol {
	public var owningView: XTView? { return superview }
}

public extension Int {

	/// Returns XTLayoutPriority value with the receiver's priority.
	var layoutPriority: XTLayoutPriority { return XTLayoutPriority( Float( self )) }
}

public extension XTView {

	func removeOutsideConstraints() {
		if let superview = self.superview {
			let viewZIndex = superview.subviews.firstIndex( of: self )
			removeFromSuperview()
			#if canImport(AppKit)
			superview.subviews.insert( self, at: viewZIndex ?? superview.subviews.count )
			#else
			superview.insertSubview( self, at: viewZIndex ?? superview.subviews.count )
			#endif
		}
	}

	func removeAllConstraints() {
		// Removing all constraints for self even from superview
		removeOutsideConstraints()
		removeConstraints( constraints )
	}
}


#if canImport(UIKit)
public extension CGSize {
	static let compressed = XTView.layoutFittingCompressedSize
	static let expanded = XTView.layoutFittingExpandedSize
}

public extension XTView {
	// MARK: - Calculating autolayout view size

	/// Returns the size of the view based on its constraints and the specified width.
	/// - note: Resulting width is always equal to `width` parameter.
	/// Resulting height is rouded up to closest whole number.
	func systemLayoutSizeFitting( width: CGFloat ) -> CGSize {

		
		let size = systemLayoutSizeFitting( CGSize( width: width, height: 0 ),
											withHorizontalFittingPriority: .required,
											verticalFittingPriority: .fittingSizeLevel )
		return CGSize( width: width, height: size.height.rounded( .up ))
	}
}

public extension LayoutGuideProtocol {

	var parentViewController: UIViewController? {

		var parent: UIResponder? = ( self as? UIResponder ) ?? owningView
		repeat {
			if parent!.isKind( of: UIViewController.self ) { break }
			parent = parent?.next
		}
		while parent != nil

		return parent as? UIViewController
	}
}
#endif

public extension LayoutGuideProtocol {

	private func getSecondItem( _ constrainToMargins: Bool ) -> LayoutGuideProtocol {
		#if canImport(AppKit)
		if #available( macOS 11, * ) { return constrainToMargins ? owningView!.layoutMarginsGuide : owningView! }
		else { return owningView! }
		#else
		return constrainToMargins ? owningView!.layoutMarginsGuide : owningView!
		#endif
	}

	@discardableResult
	func constrainHorizontallyToSuperview( inset: CGFloat = 0, constrainToMargins: Bool = false ) -> [ NSLayoutConstraint ] {

		let secondItem = getSecondItem( constrainToMargins )

		let constraints = [
			leadingAnchor.constraint( equalTo: secondItem.leadingAnchor, constant: inset ),
			secondItem.trailingAnchor.constraint( equalTo: trailingAnchor, constant: inset ),
		]

		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	@discardableResult
	func constrainVerticallyToSuperview( inset: CGFloat = 0, constrainToMargins: Bool = false ) -> [ NSLayoutConstraint ] {

		let secondItem = getSecondItem( constrainToMargins )

		let constraints = [
			topAnchor.constraint( equalTo: secondItem.topAnchor, constant: inset ),
			secondItem.bottomAnchor.constraint( equalTo: bottomAnchor, constant: inset ),
		]

		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	@available( iOS 11, tvOS 11, OSX 11, * )
	@discardableResult
	func constrainVerticallyToSuperviewSafeAreaGuides( inset: CGFloat = 0 ) -> [ NSLayoutConstraint ] {

		let constraints = [
			topAnchor.constraint( equalTo: owningView!.safeAreaLayoutGuide.topAnchor, constant: inset ),
			owningView!.safeAreaLayoutGuide.bottomAnchor.constraint( equalTo: bottomAnchor, constant: inset ),
		]

		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	@available( iOS 11, tvOS 11, OSX 11, * )
	@discardableResult
	func constrainToSuperview( insets: XTEdgeInsets = .zero, constrainToMargins: Bool = false ) -> [ NSLayoutConstraint ] {

		let secondItem = getSecondItem( constrainToMargins )

		let constraints = [
			topAnchor.constraint( equalTo: secondItem.topAnchor, constant: insets.top ),
			leadingAnchor.constraint( equalTo: secondItem.leadingAnchor, constant: insets.left ),
			secondItem.bottomAnchor.constraint( equalTo: bottomAnchor, constant: insets.bottom ),
			secondItem.trailingAnchor.constraint( equalTo: trailingAnchor, constant: insets.right ),
		]

		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	@available( iOS 11, tvOS 11, OSX 11, * )
	@discardableResult
	func constrainToSuperviewSafeAreaGuides( insets: XTEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {

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
	/// and top of the view to safe area top.
	@available( iOS 11, tvOS 11, OSX 11, * )
	@discardableResult
	func constrainToSuperviewTopLayoutGuides( insets: XTEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {

		let constraints = [
			topAnchor.constraint( equalTo: owningView!.safeAreaLayoutGuide.topAnchor, constant: insets.top ),
			leadingAnchor.constraint( equalTo: owningView!.leadingAnchor, constant: insets.left ),
			owningView!.bottomAnchor.constraint( equalTo: bottomAnchor, constant: insets.bottom ),
			owningView!.trailingAnchor.constraint( equalTo: trailingAnchor, constant: insets.right ),
		]

		NSLayoutConstraint.activate( constraints )
		return constraints
	}


	// MARK: - Centering

	@discardableResult
	func centerInSuperview( priority: XTLayoutPriority = .required ) -> [ NSLayoutConstraint ] {
		return [
			centerHorizontallyInSuperview( priority: priority ),
			centerVerticallyInSuperview( priority: priority ),
		]
	}

	@discardableResult
	func centerWithView( _ view: LayoutGuideProtocol, priority: XTLayoutPriority = .required ) -> [ NSLayoutConstraint ] {
		return [
			centerHorizontallyWithView( view, priority: priority ),
			centerVerticallyWithView( view, priority: priority ),
		]
	}


	// MARK: - Horizontal center


	@discardableResult
	func centerHorizontallyInSuperview( _ constant: CGFloat = 0, priority: XTLayoutPriority = .required ) -> NSLayoutConstraint {
		return centerHorizontallyWithView( owningView!, constant: constant, priority: priority )
	}

	@discardableResult
	func centerHorizontallyWithView( _ view: LayoutGuideProtocol, constant: CGFloat = 0, priority: XTLayoutPriority = .required ) -> NSLayoutConstraint {

		let constraint = centerXAnchor.constraint( equalTo: view.centerXAnchor, constant: constant )
		constraint.priority = priority
		constraint.isActive = true
		return constraint
	}

	// MARK: - Vertical center

	@discardableResult func centerVerticallyInSuperview( _ constant: CGFloat = 0, priority: XTLayoutPriority = .required ) -> NSLayoutConstraint {
		return centerVerticallyWithView( owningView!, constant: constant, priority: priority )
	}

	@discardableResult func centerVerticallyWithView( _ view: LayoutGuideProtocol, constant: CGFloat = 0, priority: XTLayoutPriority = .required ) -> NSLayoutConstraint {

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
	@discardableResult func align( attribute: NSLayoutConstraint.Attribute,
	                               withView guide: LayoutGuideProtocol,
	                               viewAttribute: NSLayoutConstraint.Attribute? = nil,
	                               relation: NSLayoutConstraint.Relation = .equal,
	                               constant: CGFloat = 0,
	                               multiplier: CGFloat = 1,
	                               priority: XTLayoutPriority = .required ) -> NSLayoutConstraint {

		let constraint = NSLayoutConstraint( item: self, attribute: attribute, relatedBy: relation,
		                                     toItem: guide, attribute: viewAttribute ?? attribute, multiplier: multiplier, constant: constant )
		constraint.priority = priority
		constraint.isActive = true
		return constraint
	}

	@discardableResult
	func alignVertically( to guide: LayoutGuideProtocol, insets: XTEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {
		let constraints = [
			self.topAnchor.constraint( equalTo: guide.topAnchor, constant: insets.top ),
			guide.bottomAnchor.constraint( equalTo: self.bottomAnchor, constant: insets.bottom ),
		]

		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	@discardableResult
	func alignHorizontally( to guide: LayoutGuideProtocol, insets: XTEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {
		let constraints = [
			self.leftAnchor.constraint( equalTo: guide.leftAnchor, constant: insets.left ),
			guide.rightAnchor.constraint( equalTo: self.rightAnchor, constant: insets.right ),
		]

		NSLayoutConstraint.activate( constraints )
		return constraints
	}

	@discardableResult
	func align( to guide: LayoutGuideProtocol, insets: XTEdgeInsets = .zero ) -> [ NSLayoutConstraint ] {
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

	@discardableResult func constrainTo( width: CGFloat, relatedBy: NSLayoutConstraint.Relation? = nil ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .width, relatedBy: relatedBy ?? .equal,
		                                     toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width )
		constraint.isActive = true
		return constraint
	}

	@discardableResult func constrainTo( height: CGFloat, relatedBy: NSLayoutConstraint.Relation? = nil ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .height, relatedBy: relatedBy ?? .equal,
		                                     toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height )
		constraint.isActive = true
		return constraint
	}

	@discardableResult func constrainTo( size: CGSize ) -> [ NSLayoutConstraint ] {
		return [ constrainTo( width: size.width ),
		         constrainTo( height: size.height ) ]
	}

	@discardableResult func equalSizeWithView( _ view: XTView, constant: CGFloat = 0, multiplier: CGFloat = 1 ) -> [ NSLayoutConstraint ] {
		return [ equalWidthWithView( view, constant: constant, multiplier: multiplier ),
		         equalHeightWithView( view, constant: constant, multiplier: multiplier ) ]
	}

	@discardableResult func equalHeightWithView( _ view: XTView, constant: CGFloat = 0, multiplier: CGFloat = 1 ) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint( item: self, attribute: .height, relatedBy: .equal,
		                                     toItem: view, attribute: .height, multiplier: multiplier, constant: constant )
		constraint.isActive = true
		return constraint
	}

	@discardableResult func equalWidthWithView( _ view: XTView, constant: CGFloat = 0, multiplier: CGFloat = 1 ) -> NSLayoutConstraint {
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


public extension LayoutGuideProtocol {

	/// Pins supplied attribute of the view to the same attribute of its superview or
	/// provided view.
	/// - parameter attribute: an attribute to use in constraint.
	/// - parameter view: View or XTLayoutGuide to constrain receiver. If `nil`, `superview` is used.
	/// - parameter relatedBy: The relationship between the left side of the constraint and the right side of the constraint.
	/// - parameter multiplier: The constraint multiplier.
	/// - parameter constant: The constant added to the multiplied attribute value.
	/// - parameter priority: The priority of the constraint.
	@discardableResult
	func pin( _ attribute: NSLayoutConstraint.Attribute,
			  to view: LayoutGuideProtocol? = nil,
			  relatedBy: NSLayoutConstraint.Relation = .equal,
			  multiplier: CGFloat = 1,
			  constant: CGFloat = 0,
			  priority: XTLayoutPriority = .required ) -> NSLayoutConstraint {

		let constraint = NSLayoutConstraint( item: self, attribute: attribute, relatedBy: relatedBy,
											 toItem: view ?? owningView!, attribute: attribute,
											 multiplier: multiplier, constant: constant )
		constraint.priority = priority
		constraint.isActive = true
		return constraint
	}


	@discardableResult
	func stack( after view: LayoutGuideProtocol,
				direction: XTOrientation,
				relatedBy: NSLayoutConstraint.Relation = .equal,
				multiplier: CGFloat = 1,
				constant: CGFloat = 0,
				priority: XTLayoutPriority = .required ) -> NSLayoutConstraint {

		let constraint = NSLayoutConstraint( item: self,
											 attribute: direction == .horizontal ? .leading : .top,
											 relatedBy: relatedBy,
											 toItem: view,
											 attribute: direction == .horizontal ? .trailing : .bottom,
											 multiplier: multiplier, constant: constant )
		constraint.priority = priority
		constraint.isActive = true
		return constraint
	}
}



public protocol LayoutGuideProtocol {

	var owningView: XTView? { get }

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

