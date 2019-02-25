//
//  Collections+Conversions.swift
//  UIExtensions iOS
//
//  Created by Vladimir on 25/02/2019.
//  Copyright © 2019 Vladimir Kazantsev. All rights reserved.
//

import Foundation

public extension Collection {

	/// A Boolean value indicating whether the collection is not empty.
	///
	/// Convenience method, returning `!isEmpty`.
	public var isNotEmpty: Bool { return !isEmpty }
}



public extension Collection {
	var array: Array<Element> { return Array( self ) }
}

public extension Collection where Element: Hashable {
	var set: Set<Element> { return Set( self ) }
}

public extension Collection where Element == Character {
	var string: String { return String( self ) }
}
