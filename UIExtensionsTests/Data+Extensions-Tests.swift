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

import Testing
import Foundation
import UIExtensions

@Test( "Data to hex" )
func dataToHex() {
	let fixedCases: [( [ UInt8 ], String )] = [
		( [ 0, 1, 10, 11, 15, 16, 20, 31, 32, 127, 128, 200, 255 ], "00010a0b0f10141f207f80c8ff" ),
		( [], "" ),
	]
	for ( bytes, expected ) in fixedCases {
		#expect( Data( bytes ).hexadecimalString == expected )
	}

	for _ in 0..<100 {
		let length = Int.random( in: 0...1024 )
		let bytes = ( 0..<length ).map { _ in UInt8.random( in: 0...255 ) }
		let data = Data( bytes )
		let reference = bytes.map { String( format: "%02x", $0 ) }.joined()
		#expect( data.hexadecimalString == reference )
	}
}
