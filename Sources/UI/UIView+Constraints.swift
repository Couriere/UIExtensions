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

	/// Constrains sender to the `view` with specified inset.
	/// If `view` is `nil`, superview of the sender is used.
	@discardableResult
	func pin(
		_ inset: Double,
		to view: LayoutGuideProtocol? = nil
	) -> [ NSLayoutConstraint ] {
		pin( .all, inset, to: view )
	}

	/// Constrains sender to the specified sides of `view` with specified inset.
	/// If `view` is `nil`, superview of the sender is used.
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

	/// Constrains sender to the `view` with specified inset.
	/// If `view` is `nil`, superview of the sender is used.
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

// MARK: - Embeding and pinning views
public extension XTView {

	/// Embeds one or more views inside the current view,
	/// either as a single view or as a stack view with the provided insets.
	///
	/// - parameter inset: The amount of constant inset to apply to the embedded views.
	/// - parameter content: The block of code that generates the views
	/// to be embedded. The block should return an array of UIView objects.
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
	func embed(
		_ inset: Double,
		@UIViewBuilder _ content: () -> [ XTView ]
	) {
		embed( insets: XTEdgeInsets( constantInset: inset ), content )
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
	func embed(
		horizontalInset: Double = 0,
		verticalInset: Double = 0,
		@UIViewBuilder _ content: () -> [ XTView ]
	) {
		let insets = XTEdgeInsets(
			horizontal: horizontalInset,
			vertical: verticalInset
		)
		embed( insets: insets, content )
	}

	/// Embeds one or more views inside the current view,
	/// either as a single view or as a stack view with the provided insets.
	///
	/// - parameter insets: The insets to use for pinning the views
	/// to the edges of the current view.
	/// - parameter content: The block of code that generates the views
	/// to be embedded. The block should return an array of UIView objects.
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
	func embed(
		insets: XTEdgeInsets = .zero,
		@UIViewBuilder _ content: () -> [ XTView ]
	) {
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
