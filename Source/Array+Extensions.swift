//
//  Array+Extensions.swift
//
//  Created by Vladimir Kazantsev on 02.02.15.
//  Copyright (c) 2015. All rights reserved.
//
import Foundation

public extension Array {
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

public extension Array where Element: Equatable {
	
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


public extension Set {
	mutating func toggle( _ member: Element ) {
		if contains( member ) { remove(member) } else { insert(member) }
	}
}
