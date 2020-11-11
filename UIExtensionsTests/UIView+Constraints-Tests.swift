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

import XCTest

class UIView_Constraints_Tests: XCTestCase {

	var parent: UIView!
	var child: UIView!
	var siblingToChild: UIView!

	override func setUp() {
		super.setUp()

		parent = UIView( frame: .zero )
		child = UIView( frame: .zero )
		siblingToChild = UIView( frame: .zero )

		parent.translatesAutoresizingMaskIntoConstraints = false
		child.translatesAutoresizingMaskIntoConstraints = false
		siblingToChild.translatesAutoresizingMaskIntoConstraints = false

		parent.addSubview( child )
		parent.addSubview( siblingToChild )
	}

	override func tearDown() {
		parent = nil
		child = nil
		siblingToChild = nil

		super.tearDown()
	}

	private func assertConstraint( _ constraint: NSLayoutConstraint,
	                               _ firstAnchor: AnyObject,
	                               _ secondAnchor: AnyObject,
	                               _ constant: CGFloat,
	                               _ multiplier: CGFloat,
	                               _ priority: UILayoutPriority ) {

		XCTAssert( constraint.firstAnchor === firstAnchor )
		XCTAssert( constraint.secondAnchor === secondAnchor )
		XCTAssert( constraint.constant == constant )
		XCTAssert( constraint.multiplier == multiplier )
		XCTAssert( constraint.priority == priority )
	}


	// MARK: - constrainHorizontallyToSuperview()

	func testConstrainHorizontallyToSuperview() {
		child.constrainHorizontallyToSuperview()

		XCTAssert( parent.constraints.count == 2 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.leadingAnchor, parent.leadingAnchor, 0, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  parent.trailingAnchor, child.trailingAnchor, 0, 1, .required )
	}

	func testConstrainHorizontallyToSuperviewWithInset() {

		child.constrainHorizontallyToSuperview( inset: 10, constrainToMargins: false )

		XCTAssert( parent.constraints.count == 2 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.leadingAnchor, parent.leadingAnchor, 10, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  parent.trailingAnchor, child.trailingAnchor, 10, 1, .required )
	}

	func testConstrainHorizontallyToSuperviewMargins() {

		child.constrainHorizontallyToSuperview( inset: 1, constrainToMargins: true )

		XCTAssert( parent.constraints.count > 2 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.leadingAnchor, parent.layoutMarginsGuide.leadingAnchor, 1, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  parent.layoutMarginsGuide.trailingAnchor, child.trailingAnchor, 1, 1, .required )
	}


	// MARK: - constrainVerticallyToSuperview()

	func testConstrainVerticallyToSuperview() {

		child.constrainVerticallyToSuperview()

		XCTAssert( parent.constraints.count == 2 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.topAnchor, parent.topAnchor, 0, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  parent.bottomAnchor, child.bottomAnchor, 0, 1, .required )
	}

	func testConstrainVerticallyToSuperviewWithInset() {

		child.constrainVerticallyToSuperview( inset: 10, constrainToMargins: false )

		XCTAssert( parent.constraints.count == 2 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.topAnchor, parent.topAnchor, 10, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  parent.bottomAnchor, child.bottomAnchor, 10, 1, .required )
	}

	func testConstrainVerticallyToSuperviewMargins() {

		child.constrainVerticallyToSuperview( inset: 1, constrainToMargins: true )

		XCTAssert( parent.constraints.count > 2 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.topAnchor, parent.layoutMarginsGuide.topAnchor, 1, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  parent.layoutMarginsGuide.bottomAnchor, child.bottomAnchor, 1, 1, .required )
	}

	func testConstrainVerticallyToSuperviewSafeArea() {

		child.constrainVerticallyToSuperviewSafeAreaGuides()

		XCTAssert( parent.constraints.count > 2 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.topAnchor, parent.safeAreaLayoutGuide.topAnchor, 0, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  parent.safeAreaLayoutGuide.bottomAnchor, child.bottomAnchor, 0, 1, .required )
	}


	// MARK: - constrainToSuperview

	func testConstrainToSuperview() {

		child.constrainToSuperview()

		XCTAssert( parent.constraints.count == 4 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.topAnchor, parent.topAnchor, 0, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  child.leadingAnchor, parent.leadingAnchor, 0, 1, .required )
		assertConstraint( parent.constraints[ 2 ],
		                  parent.bottomAnchor, child.bottomAnchor, 0, 1, .required )
		assertConstraint( parent.constraints[ 3 ],
		                  parent.trailingAnchor, child.trailingAnchor, 0, 1, .required )
	}

	func testConstrainToSuperviewWithInsets() {

		child.constrainToSuperview( insets: UIEdgeInsets( top: 1, left: 2, bottom: 3, right: 4 ))

		XCTAssert( parent.constraints.count == 4 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.topAnchor, parent.topAnchor, 1, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  child.leadingAnchor, parent.leadingAnchor, 2, 1, .required )
		assertConstraint( parent.constraints[ 2 ],
		                  parent.bottomAnchor, child.bottomAnchor, 3, 1, .required )
		assertConstraint( parent.constraints[ 3 ],
		                  parent.trailingAnchor, child.trailingAnchor, 4, 1, .required )
	}

	func testConstrainToSuperviewMargins() {

		child.constrainToSuperview( insets: UIEdgeInsets( top: 40, left: 30, bottom: 20, right: 10 ), constrainToMargins: true )

		XCTAssert( parent.constraints.count > 4 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.topAnchor, parent.layoutMarginsGuide.topAnchor, 40, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  child.leadingAnchor, parent.layoutMarginsGuide.leadingAnchor, 30, 1, .required )
		assertConstraint( parent.constraints[ 2 ],
		                  parent.layoutMarginsGuide.bottomAnchor, child.bottomAnchor, 20, 1, .required )
		assertConstraint( parent.constraints[ 3 ],
		                  parent.layoutMarginsGuide.trailingAnchor, child.trailingAnchor, 10, 1, .required )
	}

	func testConstrainToSuperviewSafeArea() {

		child.constrainToSuperviewSafeAreaGuides( insets: UIEdgeInsets( top: 40, left: 30, bottom: 20, right: 10 ))

		XCTAssert( parent.constraints.count > 4 )
		assertConstraint( parent.constraints[ 0 ],
		                  child.topAnchor, parent.safeAreaLayoutGuide.topAnchor, 40, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  child.leadingAnchor, parent.safeAreaLayoutGuide.leadingAnchor, 30, 1, .required )
		assertConstraint( parent.constraints[ 2 ],
		                  parent.safeAreaLayoutGuide.bottomAnchor, child.bottomAnchor, 20, 1, .required )
		assertConstraint( parent.constraints[ 3 ],
		                  parent.safeAreaLayoutGuide.trailingAnchor, child.trailingAnchor, 10, 1, .required )
	}

	// MARK: - Arbitrary format constraints

	func testConstrainWithFormat() {

		let views = [ "sibling": siblingToChild! ]
		let metrics: [ String: CGFloat ] = [ "inset": 10, "width": 20 ]
		child.constrainWithFormat( "H:|[self]-(inset)-[sibling(==width)]-(1)-|", views: views, metrics: metrics )

		XCTAssert( parent.constraints.count == 3 )

		assertConstraint( parent.constraints[ 0 ],
		                  child.leadingAnchor, parent.leadingAnchor, 0, 1, .required )
		assertConstraint( parent.constraints[ 1 ],
		                  siblingToChild.leadingAnchor, child.trailingAnchor, 10, 1, .required )
		assertConstraint( parent.constraints[ 2 ],
		                  parent.trailingAnchor, siblingToChild.trailingAnchor, 1, 1, .required )

		XCTAssert( siblingToChild.constraints.count == 1 )
		let widthConstraint = siblingToChild.constraints[ 0 ]
		XCTAssert( widthConstraint.firstAnchor === siblingToChild.widthAnchor )
		XCTAssert( widthConstraint.constant == 20 )
		XCTAssertNil( widthConstraint.secondAnchor )
		XCTAssert( widthConstraint.multiplier == 1 )
		XCTAssert( widthConstraint.priority == .required )
	}
}

