//
//  NSData+Extensions.swift
//
//  Created by Vladimir Kazantsev on 09/12/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

extension Data {

	/// Hexadecimal representation of NSData.
	var hexadecimalString: String {
	
		guard self.count > 0 else { return "" }
		
		let charBuffer = (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count)
		let dataBuffer = UnsafeBufferPointer<UInt8>( start: charBuffer, count: self.count )
	
		let hexString = dataBuffer.reduce( "" ) { result, value in
			return result.appendingFormat( "%02lx", value )
		}
		
		return hexString
	}

}
