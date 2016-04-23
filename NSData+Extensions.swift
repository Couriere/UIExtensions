//
//  NSData+Extensions.swift
//
//  Created by Vladimir Kazantsev on 09/12/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

extension NSData {

	/// Hexadecimal representation of NSData.
	var hexadecimalString: String {
	
		guard self.length > 0 else { return "" }
		
		let charBuffer = UnsafePointer<UInt8>( self.bytes )
		let dataBuffer = UnsafeBufferPointer<UInt8>( start: charBuffer, count: self.length )
	
		let hexString = dataBuffer.reduce( "" ) { result, value in
			return result.stringByAppendingFormat( "%02lx", value )
		}
		
		return hexString
	}

}
