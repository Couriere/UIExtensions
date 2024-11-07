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

import SwiftUI
import Testing
import UIExtensions

@Test( "Init with integers" )
func colorInitsWithIntegers() {

	#expect( Color( 0xFF0000 ) == Color( red: 1, green: 0, blue: 0, opacity: 1 ) )
	#expect( Color( 0xFF00 ) == Color( red: 0, green: 1, blue: 0, opacity: 1 ))
	#expect( Color( 0x0000FF ) == Color( red: 0, green: 0, blue: 1, opacity: 1 ))
	#expect( Color( 0xFFFF00 ) == Color( red: 1, green: 1, blue: 0, opacity: 1 ))
	#expect( Color( 0xFF00FF ) == Color( red: 1, green: 0, blue: 1, opacity: 1 ))
	#expect( Color( 0xFFFFFF ) == Color( intRed: 255, green: 255, blue: 255, opacity: 1 ))

	#expect( Color( 0xFF0000, opacity: 0.2 ) == Color( red: 1, green: 0, blue: 0, opacity: 0.2 ))

	#expect( Color( rgba: 0xFF000080 ) == Color( red: 1, green: 0, blue: 0, opacity: 128 / 255 ))
	#expect( Color( rgba: 0x00FF00FF ) == Color( red: 0, green: 1, blue: 0, opacity: 1 ))
	#expect( Color( rgba: 0x0000FF00 ) == Color( red: 0, green: 0, blue: 1, opacity: 0 ))
}

@Test( "Random colors" )
func colorRandomColors() {

#if canImport(UIKit)
	if #available(iOS 14.0, tvOS 14.0, *) {
		#expect( Color( randomWithOpacity: 1 ).opacity == 1 )
		#expect( Float( Color( randomWithOpacity: 0.3 ).opacity ) == 0.3 )
		#expect( Color( randomWithOpacity: 0 ).opacity == 0 )
	}
#endif

	let randomColors = (0..<100).reduce(
		into: Set<Color>()
	) { acc, _ in
		acc.insert( Color.init( randomWithOpacity: 1 ))
	}

	#expect( randomColors.count == 100 )
}

@Test( "Init from string" )
func colorInitFromString() {
	
	#expect( Color( hex: "0xFF0000" ) == Color( 0xFF0000 ))
	#expect( Color( hex: "00FF00" ) == Color( 0x00FF00 ))
	#expect( Color( hex: "0000FF" ) == Color( 0x0000FF ))
	#expect( Color( hex: "0xFF0000FF" ) == Color( 0xFF0000 ))
	#expect( Color( hex: "00FF0080" ) == Color( red: 0, green: 1, blue: 0, opacity: 128 / 255 ))
	#expect( Color( hex: "0x0000FF00" ) == Color( red: 0, green: 0, blue: 1, opacity: 0 ))

	#expect( Color( hex: "0x0000F" ) == nil )
	#expect( Color( hex: "0000FF0" ) == nil )
}

@Test( "Convert to hex" )
@available(iOS 14.0, tvOS 14, macOS 11, *)
func colorConvertToHex() {
	#expect( Color( intRed: 255, green: 0, blue: 0 ).hexRGB == "#FF0000" )
	#expect( Color( intRed: 255, green: 128, blue: 0 ).hexRGB == "#FF8000" )

	#expect( Color( intRed: 0, green: 0, blue: 128, opacity: 0.5 ).hexRGBA == "#0000807F" )
	#expect( Color( intRed: 0, green: 0, blue: 255, opacity: 0 ).hexRGBA == "#0000FF00" )
	#expect( Color( intRed: 255, green: 0, blue: 255, opacity: 1 ).hexRGBA == "#FF00FFFF" )
}
