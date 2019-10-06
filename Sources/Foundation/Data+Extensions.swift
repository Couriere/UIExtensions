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

import UIKit

public extension Data {

	/// Hexadecimal representation of Data.
	var hexadecimalString: String {

		func itoh( _ value: UInt8 ) -> UInt8 {
			return ( value > 9 ) ? ( Data.charA + value - 10 ) : ( Data.char0 + value )
		}

		return withUnsafeBytes { ( bytes: UnsafeRawBufferPointer ) -> String in

			let hexLen = count * 2
			let hexData = UnsafeMutablePointer<UInt8>.allocate( capacity: hexLen )

			for i in 0 ..< count {
				hexData[ i * 2 ] = itoh( ( bytes[ i ] >> 4 ) & 0xF )
				hexData[ i * 2 + 1 ] = itoh( bytes[ i ] & 0xF )
			}

			return String( bytesNoCopy: hexData, length: hexLen, encoding: .utf8, freeWhenDone: true ) ?? ""
		}
	}

	private static let charA = UInt8( UnicodeScalar( "a" ).value )
	private static let char0 = UInt8( UnicodeScalar( "0" ).value )
}
