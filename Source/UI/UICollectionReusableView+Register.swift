//
//  UICollectionViewCell+Register.swift
//  UI Extensions
//
//  Created by Vladimir Kazantsev on 14/05/16.
//

import UIKit

///	Helper extension for register/dequeue reusable views in `UICollectionView`
///
///	Usage:
///
///		... in `viewDidLoad()`:
///
///			ClassOfReusableViewCreatedInCode.registerSupplementaryClass( in: collection, forKind: UICollectionElementKindSectionFooter )
///			ClassOfReusableViewCreatedFromXib.registerSupplementaryXib( in: collection, forKind: UICollectionElementKindSectionFooter )
///
///		... in `collectionView( _:, viewForSupplementaryElementOfKind:, at: ) -> UICollectionReusableView`:
///
///			let cell = ReusableView.dequeueSupplementaryViewOfKind( kind, for: indexPath, in: collectionView )
///
///	Reusable views, created from code should work as is.
///	Reusable views, created from `xib` must set `Identifier` field in its `xib` to reusable views class name.
///
///	By default reusable identifier is equal to the class name.
///	Reusable identifier can be changed by overriding `class var identifier: String`
///	In that case reusable views, created from `xib`, must change cell identifier in its `xib` accordingly.

public extension UICollectionReusableView {
	
	class var identifier: String { return NSStringFromClass( self ).components( separatedBy: "." ).last! }
	
	static func registerSupplementaryClass( in collection: UICollectionView, forKind: String ) {
		collection.register( self, forSupplementaryViewOfKind: forKind, withReuseIdentifier: identifier )
	}
	
	static func registerSupplementaryXib( in collection: UICollectionView, forKind: String, xibName: String? = nil ) {
		let nib = UINib( nibName: xibName ?? identifier, bundle: nil )
		collection.register( nib, forSupplementaryViewOfKind: forKind, withReuseIdentifier: identifier )
	}
	
	static func dequeueSupplementaryView(
		ofKind elementKind: String,
		for indexPath: IndexPath,
		in collectionView: UICollectionView ) -> Self {
		
		return helperGetObjectWithId( collectionView.dequeueReusableSupplementaryView( ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath ), type: self )
	}
	fileprivate class func helperGetObjectWithId<T>( _ cell: UICollectionReusableView, type: T.Type ) -> T {
		return cell as! T
	}
}


///	Helper extension for register/dequeue cells in `UICollectionView`
///
///	Usage:
///
///		... in `viewDidLoad()`:
///
///			ClassOfCellCreatedInCode.registerClass( in: collection )
///			ClassOfCellCreatedFromXib.registerXib( in: collection )
///
///
///		... in `collectionView( _:, cellForItemAt: ) -> UICollectionViewCell`:
///
///			let cell = CellClass.dequeueCell( for: indexPath, in: collectionView )
///
///	Cells, created from code should work as is.
///	Cells, created from `xib` must set `Identifier` field in its `xib` to cells class name.
///
///	By default reusable identifier is equal to the class name.
///	Reusable identifier can be changed by overriding `class var identifier: String`
///	In that case cells, created from `xib`, must change cell identifier in its `xib` accordingly.

public extension UICollectionViewCell {
	
	static func registerClass( in collection: UICollectionView ) {
		collection.register( self, forCellWithReuseIdentifier: identifier )
	}
	
	static func registerXib( in collection: UICollectionView, xibName: String? = nil ) {
		let nib = UINib( nibName: xibName ?? identifier, bundle: nil )
		collection.register( nib, forCellWithReuseIdentifier: identifier )
	}
	
	static func dequeueCell( for indexPath: IndexPath, in collection: UICollectionView ) -> Self {
		return helperGetObjectWithId( collection.dequeueReusableCell( withReuseIdentifier: identifier, for: indexPath ), type: self )
	}
}

