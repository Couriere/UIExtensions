//
//  UITableViewCell+Register.swift
//  UI Extensions
//
//  Created by Vladimir Kazantsev on 14/05/16.
//

import UIKit

///	Helper extension for register/dequeue cells in `UITableView`
///
///	Usage:
///
///		... in `viewDidLoad()`:
///
///			ClassOfCellCreatedInCode.registerClass( in: tableView )
///			ClassOfCellCreatedFromXib.registerXib( in: tableView )
///
///
///		... in `tableView( _:, cellForItemAt: ) -> UICollectionViewCell`:
///
///			let cell = CellClass.dequeueCell( from: tableView )
///			or
///			let cell = CellClass.dequeueCell( for: indexPath, in: tableView )
///
///	Cells, created from code should work as is.
///	Cells, created from `xib` should have set `Identifier` field in its `xib` to cells class name.
///
///	By default reusable identifier is equal to the class name.
///	Reusable identifier can be changed by overriding `class var identifier: String`
///	In that case cells, created from `xib`, must change cell identifier in its `xib` accordingly.

public extension UITableViewCell {
	
	@objc class var identifier: String { return NSStringFromClass( self ).components( separatedBy: "." ).last! }
	
	static func registerClass( in tableView: UITableView ) {
		tableView.register( self, forCellReuseIdentifier: identifier )
	}
	
	static func registerXib( in tableView: UITableView, xibName: String? = nil ) {
		let nib = UINib( nibName: xibName ?? identifier, bundle: nil )
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
	private class func helperGetObjectWithId<T>( _ cell: UITableViewCell, type: T.Type ) -> T {
		return cell as! T
	}
}



///	Helper extension for register/dequeue Header/Footer in `UITableView`
///
///	Usage:
///
///		... in `viewDidLoad()`:
///
///			ClassOfHeaderFooterViewCreatedInCode.registerClass( in: tableView )
///			ClassOfHeaderFooterViewCreatedFromXib.registerXib( in: tableView )
///
///		... in `tableView( _:, viewForHeaderInSection: ) -> UITableViewHeaderFooterView?
///			or
///			`tableView( _:, viewForFooterInSection: ) -> UITableViewHeaderFooterView?
///
///			let reusableView = ReusableView.dequeue( in: tableView )
///
///	Reusable views, created from code should work as is.
///	Reusable views, created from `xib` must set `Identifier` field in its `xib` to reusable views class name.
///
///	By default reusable identifier is equal to the class name.
///	Reusable identifier can be changed by overriding `class var identifier: String`
///	In that case reusable views, created from `xib`, must change cell identifier in its `xib` accordingly.

public extension UITableViewHeaderFooterView {

	class var identifier: String { return NSStringFromClass( self ).components( separatedBy: "." ).last! }

	static func registerClass( in tableView: UITableView ) {
		tableView.register( self, forHeaderFooterViewReuseIdentifier: identifier )
	}

	static func registerXib( in tableView: UITableView, xibName: String? = nil ) {
		let nib = UINib( nibName: xibName ?? identifier, bundle: nil )
		tableView.register( nib, forHeaderFooterViewReuseIdentifier: identifier )
	}

	static func dequeue( in tableView: UITableView ) -> Self {
		return helperGetObjectWithId(
			tableView.dequeueReusableHeaderFooterView( withIdentifier: identifier )!,
			type: self
		)
	}
	private class func helperGetObjectWithId<T>( _ cell: UITableViewHeaderFooterView, type: T.Type ) -> T {
		return cell as! T
	}
}
