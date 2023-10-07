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




/// Constraint flexibility options.
public struct Edges: OptionSet, Hashable {

	public typealias RawValue = Int8

	public let rawValue: Int8

	public init( rawValue: Edges.RawValue ) {
		self.rawValue = rawValue
	}

	/// Leading edge.
	public static let leading = Edges( rawValue: 1 << 0 )
	/// Trailing edge.
	public static let trailing = Edges( rawValue: 1 << 1 )
	/// Leading and trailing edges.
	public static let horizontal: Edges = [ .leading, .trailing ]
	/// Leading and trailing edges.
	public static let horizontally = Edges.horizontal

	/// Top edge.
	public static let top = Edges( rawValue: 1 << 2 )
	/// Bottom edge.
	public static let bottom = Edges( rawValue: 1 << 3 )
	/// Top and bottom edges.
	public static let vertical: Edges = [ .top, .bottom ]
	/// Top and bottom edges.
	public static let vertically = Edges.vertical

	/// All edges.
	public static let all: Edges = [ .leading, .top, .trailing, .bottom ]
}


public extension LayoutGuideProtocol {

	/// Constrains all edges of the sender view
	/// to the specified view or parent view,
	/// with the specified insets.
	///
	/// - parameter inset: The amount of inset to be applied
	/// to the pinned edges.
	/// - parameter view: The view to which the sender view should be pinned.
	/// if `nil`, pins the sender view to its parent view.
	/// - returns: An array of the newly created and activated constraints.
	///
	@discardableResult
	func pin(
		_ inset: Double,
		to view: LayoutGuideProtocol? = nil
	) -> [ NSLayoutConstraint ] {
		pin( .all, inset, to: view )
	}

	/// Constrains edges of the sender view
	/// to the specified view or parent view,
	/// with the specified insets.
	///
	/// - parameter edges: The edges of the view to be pinned.
	///  Defaults to .all, which pins all edges of the view.
	/// - parameter inset: The amount of inset to be applied
	/// to the pinned edges. Defaults to 0.
	/// - parameter view: The view to which the sender view should be pinned.
	/// if `nil`, pins the sender view to its parent view.
	/// - returns: An array of the newly created and activated constraints.
	///
	@discardableResult
	func pin(
		_ edges: Edges = .all,
		_ inset: Double = 0,
		to view: LayoutGuideProtocol? = nil
	) -> [ NSLayoutConstraint ] {
		let secondItem = view ?? owningView!
		var constraints: [ NSLayoutConstraint ] = []

		if edges.contains( .top ) {
			constraints.append(
				topAnchor.constraint( equalTo: secondItem.topAnchor, constant: inset )
			)
		}
		if edges.contains( .leading ) {
			constraints.append(
				leadingAnchor.constraint( equalTo: secondItem.leadingAnchor, constant: inset )
			)
		}
		if edges.contains( .bottom ) {
			constraints.append(
				secondItem.bottomAnchor.constraint( equalTo: bottomAnchor, constant: inset )
			)
		}
		if edges.contains( .trailing ) {
			constraints.append(
				secondItem.trailingAnchor.constraint( equalTo: trailingAnchor, constant: inset )
			)
		}

		return constraints.activate()
	}


	/// Constrains the edges of the sender view to the corresponding edges
	/// of the specified view or its owning view, with the specified edge insets.
	///
	/// - parameter insets: The edge insets to be applied to the pinned edges
	/// of the sender view.
	/// - parameter view: The view to which the current view should be pinned.
	/// If `nil`, constrains the view to its parent view.
	/// - returns: An array of the newly created and activated constraints.
	///
	@discardableResult
	func pin(
		_ insets: XTEdgeInsets,
		to view: LayoutGuideProtocol? = nil
	) -> [ NSLayoutConstraint ] {
		let view = view ?? owningView!

		return [
			topAnchor.constraint( equalTo: view.topAnchor, constant: insets.top ),
			leadingAnchor.constraint( equalTo: view.leadingAnchor, constant: insets.left ),
			view.bottomAnchor.constraint( equalTo: bottomAnchor, constant: insets.bottom ),
			view.trailingAnchor.constraint( equalTo: trailingAnchor, constant: insets.right ),
		]
			.activate()
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

	/// Constrains the width of the current view
	/// to the specified value.
	///
	/// - parameter width: The value to be applied
	/// to width constraints of the current view.
	/// - parameter relatedBy: The relationship between the width
	/// of the view and the specified width. Defaults to .equal.
	/// - returns: The newly created width constraint.
	///
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

	/// Constrains the height of the current view
	/// to the specified value.
	///
	/// - parameter height: The value to be applied
	/// to height constraints of the current view.
	/// - parameter relatedBy: The relationship between the height
	/// of the view and the specified height. Defaults to .equal.
	/// - returns: The newly created height constraint.
	///
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

	/// Constrains the size of the current view
	/// to the specified width and height values.
	///
	/// - parameter size: The `CGSize` value to be applied
	/// to the width and height constraints of the current view.
	/// - parameter relatedBy: The relationship between the size
	/// of the view and the specified size. Defaults to .equal.
	/// - returns: An array of the newly created size constraints.
	///
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

	/// Constrains the aspect ratio of the current view
	/// to the specified multiplier and constant value.
	///
	/// - parameter multiplier: The aspect ratio multiplier value
	/// to be applied to the current view. This value represents
	/// the ratio of the width to the height of the view.
	/// - parameter constant: The constant value to be added
	/// to the aspect ratio constraint.
	/// - returns: The newly created aspect ratio constraint object.
	///
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


	/// Adds a constraint to stack this view after another view,
	/// either horizontally or vertically.
	///
	/// - parameters:
	///     - view: The view that this view should stack after.
	///     - direction: The axis along which the views should be stacked.
	///     Defaults to `.vertical`.
	///     - relatedBy: The relation between the layout attributes. Defaults to `.equal`.
	///     - multiplier: The multiplier for the layout constraint. Defaults to `1`.
	///     - constant: The constant for the layout constraint. Defaults to `0`.
	///     - priority: The priority of the layout constraint. Defaults to `.required`.
	///
	/// - returns: The newly created and activated constraint.
	///
	/// Creates and activates a new constraint that positions
	/// the sender view adjacent to the specified view,
	/// either to the right of it (if the direction is horizontal)
	/// or below it (if the direction is vertical),
	/// with the specified multiplier, constant, and priority.
	///
	@discardableResult
	func stack(
		after view: LayoutGuideProtocol,
		direction: XTOrientation,
		relatedBy: NSLayoutConstraint.Relation = .equal,
		multiplier: Double = 1,
		constant: Double = 0,
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

// MARK: - Embeding and pinning views
public extension XTView {

	/// Embeds one or more views inside the current view,
	/// either as a single view or as a stack view with the provided insets.
	///
	/// - parameter inset: The amount of constant inset to apply to the embedded views.
	/// - parameter content: The block of code that generates the views
	/// to be embedded. The block should return an array of UIView objects.
	/// - returns: Receiver.
	///
	/// This method either embeds a single view or a stack view
	/// with the provided insets.
	/// - If a single view is provided, it is pinned to the edges
	/// of the current view using the provided insets.
	/// - If multiple views are provided, they are added to a vertical stack view,
	/// which is then pinned to the edges of the current view
	/// using the provided insets.
	///
	/// - precondition: content should return at least one view.
	///
	@discardableResult
	func embed(
		_ inset: Double,
		@UIViewBuilder _ content: () -> [ XTView ]
	) -> XTView {
		embed( insets: XTEdgeInsets( constantInset: inset ), content )
	}

	/// Embeds one view inside the current view with the provided insets.
	///
	/// - parameter inset: The amount of constant inset to apply to the embedded view.
	/// - parameter view: The view to be embedded.
	/// - returns: Receiver.
	///
	/// This method either embeds a single view
	/// with the provided insets.
	/// The view is pinned to the edges of the current view
	/// using the provided insets.
	///
	@discardableResult
	func embed(
		inset: Double,
		view: XTView
	) -> XTView {
		embed( inset ) { view }
	}

	/// Embeds one or more views inside the current view,
	/// either as a single view or as a stack view with the provided insets.
	///
	/// - parameter horizontalInset: The amount of horizontal inset
	/// to apply to the embedded views.
	/// - parameter verticalInset: The amount of vertical inset
	/// to apply to the embedded views.
	/// - parameter content: The block of code that generates the views
	/// to be embedded. The block should return an array of UIView objects.
	/// - returns: Receiver.
	///
	/// This method either embeds a single view or a stack view
	/// with the provided insets.
	/// - If a single view is provided, it is pinned to the edges
	/// of the current view using the provided insets.
	/// - If multiple views are provided, they are added to a vertical stack view,
	/// which is then pinned to the edges of the current view
	/// using the provided insets.
	///
	/// - precondition: content should return at least one view.
	///
	@discardableResult
	func embed(
		horizontalInset: Double = 0,
		verticalInset: Double = 0,
		@UIViewBuilder _ content: () -> [ XTView ]
	) -> XTView {
		let insets = XTEdgeInsets(
			horizontal: horizontalInset,
			vertical: verticalInset
		)
		return embed( insets: insets, content )
	}

	/// Embeds one or more views inside the current view,
	/// either as a single view or as a stack view with the provided insets.
	///
	/// - parameter insets: The insets to use for pinning the views
	/// to the edges of the current view.
	/// - parameter content: The block of code that generates the views
	/// to be embedded. The block should return an array of UIView objects.
	/// - returns: Receiver.
	///
	/// This method either embeds a single view or a stack view
	/// with the provided insets.
	/// - If a single view is provided, it is pinned to the edges
	/// of the current view using the provided insets.
	/// - If multiple views are provided, they are added to a vertical stack view,
	/// which is then pinned to the edges of the current view
	/// using the provided insets.
	///
	/// - precondition: content should return at least one view.
	///
	@discardableResult
	func embed(
		insets: XTEdgeInsets = .zero,
		@UIViewBuilder _ content: () -> [ XTView ]
	) -> XTView {
		let views = content()
		precondition( views.isNotEmpty )

		if views.count == 1 {
			let singleView = views[ 0 ]
			singleView.translatesAutoresizingMaskIntoConstraints = false
			addSubview( singleView )
			singleView.pin( insets )
		} else {
			let implicitStackView = XTStackView { views }
			addSubview( implicitStackView )
			implicitStackView.pin( insets )
		}
		
		return self
	}
	
	/// Embeds one view inside the current view with the provided insets.
	///
	/// - parameter insets: The insets to use for pinning the views
	/// to the edges of the current view.
	/// - parameter view: The view to be embedded.
	/// - returns: Receiver.
	///
	/// This method either embeds a single view
	/// with the provided insets.
	/// The view is pinned to the edges of the current view
	/// using the provided insets.
	///
	@discardableResult
	func embed(
		insets: XTEdgeInsets = .zero,
		view: XTView
	) -> XTView {
		embed( insets: insets ) { view }
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

// MARK: - Calculating autolayout view size
public extension UIView {

	/// Calculates the system layout size fitting for the view with a given width.
	///
	/// - parameter width: The desired width of the view.
	/// - returns: The size that fits the view's contents within the given width.
	///
	/// - note: Resulting width is always equal to `width` parameter.
	/// Resulting height is rouded up to closest whole number.
	///
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
