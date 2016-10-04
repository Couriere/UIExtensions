//
//  NSURL+Extensions.swift
//  MegafonTV
//
//  Created by Vladimir Kazantsev on 19/02/16.
//  Copyright © 2016 MC2Soft. All rights reserved.
//

import Foundation

extension URL {
	
	var URLByDeletingQuery: URL? {
		var components = URLComponents( url: self, resolvingAgainstBaseURL: false )
		components?.query = nil
		return components?.url
	}
	
	var freeSpace: Int64? {
		let systemAttributes = try? FileManager.default.attributesOfFileSystem( forPath: self.path )
		let freeSpace = ( systemAttributes?[ FileAttributeKey.systemFreeSize ] as? NSNumber )?.int64Value
		return freeSpace
	}
	
	// MARK: - System paths
	
	static var libraryPath: URL {
		let path = try! FileManager.default.url( for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false )
		return path
	}

	static var documentsPath: URL {
		let path = try! FileManager.default.url( for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false )
		return path
	}
	
}

