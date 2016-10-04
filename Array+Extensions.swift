//
//  Array+Extensions.swift
//
//  Created by Vladimir Kazantsev on 02.02.15.
//  Copyright (c) 2015. All rights reserved.
//
import Foundation

extension Collection {
	/// Returns the first element where `predicate` returns `true` for the
	/// corresponding value, or `nil` if such value is not found.
	///
	/// - Complexity: O(`self.count`).
	
	public func element( where predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Self.Iterator.Element? {
		guard let index = try index( where: predicate ) else { return nil }
		return self[ index ]
	}
}

extension Array {
	subscript ( safe index: Int ) -> Element? {
		return indices ~= index ? self[ index ] : nil
	}
	
	func chunk( _ chunkSize: Int ) -> [[Element]] {
		return stride( from: 0, to: self.count, by: chunkSize ).map { startIndex -> [Element] in
			let endIndex = ( startIndex.advanced( by: chunkSize ) > self.count ) ? self.count - startIndex : chunkSize
			return Array( self[ startIndex..<startIndex.advanced( by: endIndex )] )
		}
	}
}

extension Array where Element: Equatable {
	
	mutating func remove( _ element: Element ) {
		if let index = self.index( of: element ) {
			self.remove( at: index )
		}
	}
	
	mutating func appendIfNotExist( _ newElement: Element ) {
		if index( of: newElement ) == nil {
			append( newElement )
		}
	}
}
