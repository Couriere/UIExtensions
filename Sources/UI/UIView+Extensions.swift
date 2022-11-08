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

public extension XTView {

	#if canImport(UIKit)
	/// Returns current first responder view that's contained in this view's subtree.
	/// Returns `nil` otherwise.
	var firstResponder: XTView? {

		if isFirstResponder { return self }

		for view in subviews {
			if let firstResponder = view.firstResponder { return firstResponder }
		}

		return nil
	}
	#endif

	/// Adds views to the end of the receiver’s list of subviews.
	func addSubviews( _ views: [ XTView ] ) {
		views.forEach { addSubview( $0 ) }
	}

	/// Adds views to the end of the receiver’s list of subviews.
	func addSubviews( _ views: XTView... ) {
		views.forEach { addSubview( $0 ) }
	}

	/// Removes all subviews from the receiver.
	func removeAllSubviews() {
		subviews.forEach { $0.removeFromSuperview() }
	}
}

public extension XTView {

	/**
	Load view from xib file.

	- parameter xibName:  	Name of the xib. Defaults to type name.
	- parameter bundle:		Bundle containing xib file.
	- returns: Instance of ofType class, loaded from xib
	*/
	class func makeFromXib( named xibName: String? = nil, bundle: Bundle? = nil ) -> Self? {

		let xibFileName = xibName ?? String( describing: self )
		var views: NSArray?
		#if canImport(AppKit)
		let nib = NSNib( nibNamed: xibFileName, bundle: bundle ?? Bundle( for: self ) )
		nib?.instantiate( withOwner: nil, topLevelObjects: &views )
		#else
		let nib = UINib( nibName: xibFileName, bundle: bundle ?? Bundle( for: self ) )
		views = nib.instantiate( withOwner: nil, options: nil ) as NSArray
		#endif
		return views?.compactMap( { $0 as? Self } ).first
	}
}

public extension XTView {

	func disableUserInteractions() -> Self {
		isUserInteractionEnabled = false
		return self
	}
}


public extension XTView {

	@objc func background(
		color: UIColor = .white
	) -> Self {

		backgroundColor = color
		return self
	}

	@objc func cornerRadius(
		_ cornerRadius: Double = 0
	) -> Self {

		layer.cornerRadius = cornerRadius
		return self
	}

	@objc func shadow(
		color: UIColor,
		radius: Double = 1,
		offset: CGSize = .zero
	) -> Self {

		layer.shadowColor = color.cgColor
		layer.shadowRadius = radius
		layer.shadowOffset = offset
		layer.shadowOpacity = 1

		return self
	}

	@objc func border(
		color: UIColor,
		width: Double = (1 / UIScreen.main.scale)
	) -> Self {
		layer.borderColor = color.cgColor
		layer.borderWidth = width

		return self
	}
}
