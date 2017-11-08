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
///			let cell = CellClass.dequeueCellFromTableView( tableView )
///
///	Cells, created from code should work as is.
///	Cells, created from `xib` should have set `Identifier` field in its `xib` to cells class name.
///
///	By default reusable identifier is equal to the class name.
///	Reusable identifier can be changed by overriding `class var identifier: String`
///	In that case cells, created from `xib`, must change cell identifier in its `xib` accordingly.

public extension UITableViewCell {
	
	class var identifier: String { return NSStringFromClass( self ).components( separatedBy: "." ).last! }
	
	static func registerClass( in table: UITableView ) {
		table.register( self, forCellReuseIdentifier: identifier )
	}
	
	static func registerXib( in table: UITableView, xibName: String? = nil ) {
		let nib = UINib( nibName: xibName ?? identifier, bundle: nil )
		table.register( nib, forCellReuseIdentifier: identifier )
	}
	
	static func dequeueCellFromTableView( _ tableView: UITableView ) -> Self {
		return helperGetObjectWithId( tableView.dequeueReusableCell( withIdentifier: identifier )!, type: self )
	}
	private class func helperGetObjectWithId<T>( _ cell: UITableViewCell, type: T.Type ) -> T! {
		return cell as! T
	}
	
}
