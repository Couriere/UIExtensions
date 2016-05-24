//
//  Array+Extensions.swift
//
//  Created by Vladimir Kazantsev on 02.02.15.
//  Copyright (c) 2015. All rights reserved.
//
import Foundation

extension Array {
	subscript ( safe index: Int ) -> Element? {
		return indices ~= index ? self[ index ] : nil
	}
	
	func chunk( subSize: Index.Distance ) -> [[ Element ]] {
		return 0.stride( to: self.count, by: subSize ).map { startIndex in
			let endIndex = startIndex.advancedBy( subSize, limit: self.count )
			return Array( self[ startIndex ..< endIndex ] )
		}
	}
}

extension Array where Element: Equatable {
	
	mutating func remove( element: Element ) {
		if let index = self.indexOf( element ) {
			removeAtIndex( index )
		}
	}
	
	mutating func appendIfNotExist( newElement: Element ) {
		if indexOf( newElement ) == nil {
			append( newElement )
		}
	}
}
