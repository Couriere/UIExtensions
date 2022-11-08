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

public struct Axes: OptionSet, Hashable {

	public let rawValue: Int

	public init( rawValue: Int ) {
		self.rawValue = rawValue
	}

	public static let horizontal = Axes( rawValue: 1 << 0 )
	public static let vertical = Axes( rawValue: 1 << 1 )

	public static let both: Axes = [ .horizontal, .vertical ]
}



public struct SideInsets: Hashable {
	// Specify amount to inset of outset for each of the edges.
	// Positive values for `inset`,
	// negative values for `outset`.
	public var top: Double?
	public var leading: Double?
	public var bottom: Double?
	public var trailing: Double?

	public init(
		top: Double? = nil, leading: Double? = nil,
		bottom: Double? = nil, trailing: Double? = nil
	) {
		self.top = top
		self.leading = leading
		self.bottom = bottom
		self.trailing = trailing
	}

	public static let top = SideInsets( top: 0 )
	public static func top( _ inset: Double ) -> SideInsets {
		SideInsets( top: inset )
	}

	public static let leading = SideInsets( leading: 0 )
	public static func leading( _ inset: Double ) -> SideInsets {
		SideInsets( leading: inset )
	}

	public static let bottom = SideInsets( bottom: 0 )
	public static func bottom( _ inset: Double ) -> SideInsets {
		SideInsets( bottom: inset )
	}

	public static let trailing = SideInsets( trailing: 0 )
	public static func trailing( _ inset: Double ) -> SideInsets {
		SideInsets( trailing: inset )
	}

	public static let horizontally = SideInsets( leading: 0, trailing: 0 )
	public static func horizontally( _ inset: Double ) -> SideInsets {
		SideInsets( leading: inset, trailing: inset )
	}
	public static func horizontally( _ leading: Double, _ trailing: Double ) -> SideInsets {
		SideInsets( leading: leading, trailing: trailing )
	}

	public static let vertically = SideInsets( top: 0, bottom: 0 )
	public static func vertically( _ inset: Double ) -> SideInsets {
		SideInsets( top: inset, bottom: inset )
	}
	public static func vertically( _ top: Double, _ bottom: Double ) -> SideInsets {
		SideInsets( top: top, bottom: bottom )
	}

	public static let all = SideInsets( top: 0, leading: 0, bottom: 0, trailing: 0 )
	public static func all( _ inset: Double ) -> SideInsets {
		SideInsets( top: inset, leading: inset, bottom: inset, trailing: inset )
	}
	public static func all( _ horizontal: Double, _ vertical: Double ) -> SideInsets {
		SideInsets(
			top: vertical,
			leading: horizontal,
			bottom: vertical,
			trailing: horizontal
		)
	}
}

public extension LayoutGuideProtocol {

	/// Constrains sender to specified sides of `view`.
	/// If `view` is `nil`, superview of the sender is used.
	@discardableResult
	func pin(
		_ sides: SideInsets = .all,
		to view: LayoutGuideProtocol? = nil
	) -> [ NSLayoutConstraint ] {
		let secondItem = view ?? owningView!
		var constraints: [ NSLayoutConstraint ] = []

		if let top = sides.top {
			constraints.append(
				topAnchor.constraint( equalTo: secondItem.topAnchor, constant: top )
			)
		}
		if let leading = sides.leading {
			constraints.append(
				leadingAnchor.constraint( equalTo: secondItem.leadingAnchor, constant: leading )
			)
		}
		if let bottom = sides.bottom {
			constraints.append(
				secondItem.bottomAnchor.constraint( equalTo: bottomAnchor, constant: bottom )
			)
		}
		if let trailing = sides.trailing {
			constraints.append(
				secondItem.trailingAnchor.constraint( equalTo: trailingAnchor, constant: trailing )
			)
		}

		return constraints.activate()
	}


	// MARK: - View centers.

	@discardableResult
	func alignCenters(
		_ axes: Axes = .both,
		with layoutGuide: LayoutGuideProtocol? = nil,
		offset: CGPoint = .zero,
		priority: XTLayoutPriority = .required
	) -> [ NSLayoutConstraint ] {
		let view = layoutGuide ?? owningView!
		var constraints: [ NSLayoutConstraint ] = []
		
		if axes.contains( .horizontal ) {
			constraints.append(
				centerXAnchor
					.constraint( equalTo: view.centerXAnchor, constant: offset.x )
			)
		}

		if axes.contains( .vertical ) {
			constraints.append(
				centerYAnchor
					.constraint( equalTo: view.centerYAnchor, constant: offset.y )
			)
		}

		return constraints
			.setPriority( priority )
			.activate()
	}

	// MARK: - Size constraints

	@discardableResult
	func constrain(
		width: Double,
		relatedBy: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		NSLayoutConstraint(
			item: self, attribute: .width, relatedBy: relatedBy,
			toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width
		)
		.activate()
	}

	@discardableResult
	func constrain(
		height: Double,
		relatedBy: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		NSLayoutConstraint(
			item: self, attribute: .height, relatedBy: relatedBy,
			toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height
		)
		.activate()
	}

	@discardableResult
	func constrain(
		size: CGSize,
		relatedBy: NSLayoutConstraint.Relation = .equal
	) -> [ NSLayoutConstraint ] {
		return [
			constrain( width: size.width, relatedBy: relatedBy ),
			constrain( height: size.height, relatedBy: relatedBy )
		]
	}


	// MARK: - Aspect ratio

	@discardableResult
	func constrain(
		aspectRatio multiplier: Double,
		constant: Double = 0
	) -> NSLayoutConstraint {
		NSLayoutConstraint(
			item: self, attribute: .width, relatedBy: .equal, toItem: self,
			attribute: .height, multiplier: multiplier, constant: constant
		)
		.activate()
	}


	// MARK: - Sizes

	@discardableResult
	func equalSizeWithView(
		_ view: XTView,
		constant: CGFloat = 0,
		multiplier: CGFloat = 1
	) -> [ NSLayoutConstraint ] {
		return [
			equalWidthWithView( view, constant: constant, multiplier: multiplier ),
			equalHeightWithView( view, constant: constant, multiplier: multiplier )
		]
	}

	@discardableResult
	func equalHeightWithView(
		_ view: XTView,
		constant: CGFloat = 0,
		multiplier: CGFloat = 1,
		relation: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		NSLayoutConstraint(
			item: self,	attribute: .height, relatedBy: relation,
			toItem: view, attribute: .height, multiplier: multiplier, constant: constant
		)
		.activate()
	}

	@discardableResult
	func equalWidthWithView(
		_ view: XTView,
		constant: CGFloat = 0,
		multiplier: CGFloat = 1,
		relation: NSLayoutConstraint.Relation = .equal
	) -> NSLayoutConstraint {
		NSLayoutConstraint(
			item: self, attribute: .width, relatedBy: relation,
			toItem: view, attribute: .width, multiplier: multiplier, constant: constant
		)
		.activate()
	}


	// MARK: - Arbitrary format constraints

	@discardableResult
	func constrainWithFormat(
		_ format: String,
		views: [ String: LayoutGuideProtocol ]? = nil,
		metrics: [ String: CGFloat ]? = nil
	) -> [ NSLayoutConstraint ] {

		var mutableViews = views ?? [:]
		mutableViews[ "self" ] = self

		return NSLayoutConstraint.constraints(
			withVisualFormat: format,
			options: [],
			metrics: metrics,
			views: mutableViews
		)
		.activate()
	}
}


public extension LayoutGuideProtocol {

	// MARK: - Alignment constraints.

	/**
	 Constrain receiver to another view.
	 - parameter attribute: Receiver attribute to constrain to.
	 - parameter view: View to constrain receiver to.
	 - parameter attribute: Attribute of another view to constrain receiver to. If `nil` it become equal to `attribute`.
	 - parameter constant: Constant of a newly created constraint. Defaults to zero.
	 - parameter priority: Priority of a newly created constraint. Defaults to `Required`
	 */
	@discardableResult
	func align(
		attribute: NSLayoutConstraint.Attribute,
		withView guide: LayoutGuideProtocol,
		viewAttribute: NSLayoutConstraint.Attribute? = nil,
		relation: NSLayoutConstraint.Relation = .equal,
		constant: CGFloat = 0,
		multiplier: CGFloat = 1,
		priority: XTLayoutPriority = .required
	) -> NSLayoutConstraint {

		let constraint = NSLayoutConstraint( item: self, attribute: attribute, relatedBy: relation,
											 toItem: guide, attribute: viewAttribute ?? attribute, multiplier: multiplier, constant: constant )
		constraint.priority = priority
		constraint.isActive = true
		return constraint
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
	func pinAttribute(
		_ attribute: NSLayoutConstraint.Attribute,
		to view: LayoutGuideProtocol? = nil,
		relatedBy: NSLayoutConstraint.Relation = .equal,
		multiplier: CGFloat = 1,
		constant: CGFloat = 0,
		priority: XTLayoutPriority = .required
	) -> NSLayoutConstraint {

		NSLayoutConstraint(
			item: self, attribute: attribute, relatedBy: relatedBy,
			toItem: view ?? owningView!, attribute: attribute,
			multiplier: multiplier, constant: constant
		)
		.setPriority( priority )
		.activate()
	}


	@discardableResult
	func stack(
		after view: LayoutGuideProtocol,
		direction: XTOrientation,
		relatedBy: NSLayoutConstraint.Relation = .equal,
		multiplier: CGFloat = 1,
		constant: CGFloat = 0,
		priority: XTLayoutPriority = .required
	) -> NSLayoutConstraint {

		NSLayoutConstraint(
			item: self,
			attribute: direction == .horizontal ? .leading : .top,
			relatedBy: relatedBy,
			toItem: view,
			attribute: direction == .horizontal ? .trailing : .bottom,
			multiplier: multiplier, constant: constant
		)
		.setPriority( priority )
		.activate()
	}
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

		let size = systemLayoutSizeFitting(
			CGSize( width: width, height: 0 ),
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel
		)
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

public extension XTEdgeInsets {
	init( _ sides: SideInsets ) {
		self.init(
			top: sides.top ?? 0, left: sides.leading ?? 0,
			bottom: sides.bottom ?? 0, right: sides.trailing ?? 0
		)
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
