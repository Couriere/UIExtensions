//
//  NSData+Extensions.swift
//
//  Created by Vladimir Kazantsev on 09/12/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

public extension Data {

	/// Hexadecimal representation of NSData.
	var hexadecimalString: String {
		
		func itoh(_ value: UInt8) -> UInt8 {
			return (value > 9) ? (Data.charA + value - 10) : (Data.char0 + value)
		}
		
		return withUnsafeBytes { ( bytes: UnsafePointer<UInt8> ) -> String in
			
			let hexLen = count * 2
			let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: hexLen)
			
			for i in 0 ..< count {
				ptr[i*2] = itoh((bytes[i] >> 4) & 0xF)
				ptr[i*2+1] = itoh(bytes[i] & 0xF)
			}
			
			return String( bytesNoCopy: ptr, length: hexLen, encoding: .utf8, freeWhenDone: true ) ?? ""
		}
	}
	
	private static let charA = UInt8(UnicodeScalar("a").value)
	private static let char0 = UInt8(UnicodeScalar("0").value)
}
