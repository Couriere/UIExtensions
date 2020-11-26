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

import UIKit

/// 	Helper extension for register/dequeue cells in `UITableView`
///
/// 	Usage:
///
/// 		... in `viewDidLoad()`:
///
/// 			ClassOfCellCreatedInCode.registerClass( in: tableView )
/// 			ClassOfCellCreatedFromXib.registerXib( in: tableView )
///
///
/// 		... in `tableView( _:, cellForItemAt: ) -> UICollectionViewCell`:
///
/// 			let cell = CellClass.dequeueCell( from: tableView )
/// 			or
/// 			let cell = CellClass.dequeueCell( for: indexPath, in: tableView )
///
/// 	Cells, created from code should work as is.
/// 	Cells, created from `xib` should have set `Identifier` field in its `xib` to cells class name.
///
/// 	By default reusable identifier is equal to the class name.
/// 	Reusable identifier can be changed by overriding `class var identifier: String`
/// 	In that case cells, created from `xib`, must change cell identifier in its `xib` accordingly.

public extension UITableViewCell {

	@objc class var identifier: String { String( describing: self ) }

	static func registerClass( in tableView: UITableView ) {
		tableView.register( self, forCellReuseIdentifier: identifier )
	}

	static func registerXib( in tableView: UITableView, xibName: String? = nil, bundle: Bundle? = nil ) {
		let nib = UINib( nibName: xibName ?? identifier, bundle: bundle ?? Bundle( for: self ) )
		tableView.register( nib, forCellReuseIdentifier: identifier )
	}

	static func dequeue( from tableView: UITableView ) -> Self {
		return helperGetObjectWithId( tableView.dequeueReusableCell( withIdentifier: identifier )!, type: self )
	}

	static func dequeue( for indexPath: IndexPath, in tableView: UITableView ) -> Self {
		return helperGetObjectWithId(
			tableView.dequeueReusableCell( withIdentifier: identifier, for: indexPath ),
			type: self
		)
	}

	private class func helperGetObjectWithId<T>( _ cell: UITableViewCell, type _: T.Type ) -> T {
		return cell as! T
	}
}



/// 	Helper extension for register/dequeue Header/Footer in `UITableView`
///
/// 	Usage:
///
/// 		... in `viewDidLoad()`:
///
/// 			ClassOfHeaderFooterViewCreatedInCode.registerClass( in: tableView )
/// 			ClassOfHeaderFooterViewCreatedFromXib.registerXib( in: tableView )
///
/// 		... in `tableView( _:, viewForHeaderInSection: ) -> UITableViewHeaderFooterView?
/// 			or
/// 			`tableView( _:, viewForFooterInSection: ) -> UITableViewHeaderFooterView?
///
/// 			let reusableView = ReusableView.dequeue( in: tableView )
///
/// 	Reusable views, created from code should work as is.
/// 	Reusable views, created from `xib` must set `Identifier` field in its `xib` to reusable views class name.
///
/// 	By default reusable identifier is equal to the class name.
/// 	Reusable identifier can be changed by overriding `class var identifier: String`
/// 	In that case reusable views, created from `xib`, must change cell identifier in its `xib` accordingly.

public extension UITableViewHeaderFooterView {

	@objc class var identifier: String { String( describing: self ) }

	static func registerClass( in tableView: UITableView ) {
		tableView.register( self, forHeaderFooterViewReuseIdentifier: identifier )
	}

	static func registerXib( in tableView: UITableView, xibName: String? = nil, bundle: Bundle? = nil ) {
		let nib = UINib( nibName: xibName ?? identifier, bundle: bundle ?? Bundle( for: self ) )
		tableView.register( nib, forHeaderFooterViewReuseIdentifier: identifier )
	}

	static func dequeue( in tableView: UITableView ) -> Self {
		return helperGetObjectWithId(
			tableView.dequeueReusableHeaderFooterView( withIdentifier: identifier )!,
			type: self
		)
	}

	private class func helperGetObjectWithId<T>( _ cell: UITableViewHeaderFooterView, type _: T.Type ) -> T {
		return cell as! T
	}
}
