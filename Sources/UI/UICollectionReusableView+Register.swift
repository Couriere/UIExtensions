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

#if canImport(UIKit)
import UIKit

/// 	Helper extension for register/dequeue reusable views in `UICollectionView`
///
/// 	Usage:
///
/// 		... in `viewDidLoad()`:
///
/// 			ClassOfReusableViewCreatedInCode.registerSupplementaryClass( in: collection, forKind: UICollectionElementKindSectionFooter )
/// 			ClassOfReusableViewCreatedFromXib.registerSupplementaryXib( in: collection, forKind: UICollectionElementKindSectionFooter )
///
/// 		... in `collectionView( _:, viewForSupplementaryElementOfKind:, at: ) -> UICollectionReusableView`:
///
/// 			let cell = ReusableView.dequeueSupplementaryViewOfKind( kind, for: indexPath, in: collectionView )
///
/// 	Reusable views, created from code should work as is.
/// 	Reusable views, created from `xib` must set `Identifier` field in its `xib` to reusable views class name.
///
/// 	By default reusable identifier is equal to the class name.
/// 	Reusable identifier can be changed by overriding `class var identifier: String`
/// 	In that case reusable views, created from `xib`, must change cell identifier in its `xib` accordingly.

public extension UICollectionReusableView {

	@objc class var identifier: String { String( describing: self ) }

	static func registerSupplementaryClass( in collection: UICollectionView, forKind: String ) {
		collection.register( self, forSupplementaryViewOfKind: forKind, withReuseIdentifier: identifier )
	}

	static func registerSupplementaryXib(
		in collection: UICollectionView,
		forKind: String,
		xibName: String? = nil,
		bundle: Bundle? = nil
	) {
		let nib = UINib( nibName: xibName ?? identifier, bundle: bundle ?? Bundle( for: self ) )
		collection.register( nib, forSupplementaryViewOfKind: forKind, withReuseIdentifier: identifier )
	}

	static func dequeueSupplementaryView(
		ofKind elementKind: String,
		for indexPath: IndexPath,
		in collectionView: UICollectionView ) -> Self {

		return helperGetObjectWithId( collectionView.dequeueReusableSupplementaryView( ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath ), type: self )
	}

	fileprivate class func helperGetObjectWithId<T>( _ cell: UICollectionReusableView, type _: T.Type ) -> T {
		return cell as! T
	}
}


/// 	Helper extension for register/dequeue cells in `UICollectionView`
///
/// 	Usage:
///
/// 		... in `viewDidLoad()`:
///
/// 			ClassOfCellCreatedInCode.registerClass( in: collection )
/// 			ClassOfCellCreatedFromXib.registerXib( in: collection )
///
///
/// 		... in `collectionView( _:, cellForItemAt: ) -> UICollectionViewCell`:
///
/// 			let cell = CellClass.dequeueCell( for: indexPath, in: collectionView )
///
/// 	Cells, created from code should work as is.
/// 	Cells, created from `xib` must set `Identifier` field in its `xib` to cells class name.
///
/// 	By default reusable identifier is equal to the class name.
/// 	Reusable identifier can be changed by overriding `class var identifier: String`
/// 	In that case cells, created from `xib`, must change cell identifier in its `xib` accordingly.

public extension UICollectionViewCell {

	static func registerClass( in collection: UICollectionView ) {
		collection.register( self, forCellWithReuseIdentifier: identifier )
	}

	static func registerXib( in collection: UICollectionView, xibName: String? = nil, bundle: Bundle? = nil ) {
		let nib = UINib( nibName: xibName ?? identifier, bundle: bundle ?? Bundle( for: self ) )
		collection.register( nib, forCellWithReuseIdentifier: identifier )
	}

	static func dequeueCell( for indexPath: IndexPath, in collection: UICollectionView ) -> Self {
		return helperGetObjectWithId( collection.dequeueReusableCell( withReuseIdentifier: identifier, for: indexPath ), type: self )
	}
}
#endif
