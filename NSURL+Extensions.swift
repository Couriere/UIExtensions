//
//  NSURL+Extensions.swift
//  MegafonTV
//
//  Created by Vladimir Kazantsev on 19/02/16.
//  Copyright © 2016 MC2Soft. All rights reserved.
//

import Foundation

extension NSURL {
	
	var URLByDeletingQuery: NSURL? {
		let components = NSURLComponents( URL: self, resolvingAgainstBaseURL: false )
		components?.query = nil
		return components?.URL
	}
	
	var freeSpace: Int64? {
		let systemAttributes = try? NSFileManager.defaultManager().attributesOfFileSystemForPath( self.path ?? "" )
		let freeSpace = ( systemAttributes?[ NSFileSystemFreeSize ] as? NSNumber )?.longLongValue
		return freeSpace
	}
	
	// MARK: - System paths
	
	static var libraryPath: NSURL {
		let path = try! NSFileManager.defaultManager().URLForDirectory( .LibraryDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false )
		return path
	}

	static var documentsPath: NSURL {
		let path = try! NSFileManager.defaultManager().URLForDirectory( .DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false )
		return path
	}
	
}

