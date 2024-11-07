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
import UIExtensions
//import UIKit

@Test( "Init with integers" )
func uiColorInitsWithIntegers() {

	#expect( NativeColor( 0xFF0000 ) == NativeColor.red )
	#expect( NativeColor( 0xFF00 ) == NativeColor.green )
	#expect( NativeColor( 0x0000FF ) == NativeColor.blue )
	#expect( NativeColor( 0xFFFF00 ) == NativeColor.yellow )
	#expect( NativeColor( 0xFF00FF ) == NativeColor.magenta )
	#expect( NativeColor( 0xFFFFFF ) == NativeColor( intRed: 255, green: 255, blue: 255, alpha: 1 ))

	#expect( NativeColor( 0xFF0000, alpha: 0.2 ) == NativeColor.red.withAlphaComponent( 0.2 ))

	#expect( NativeColor( rgba: 0xFF000080 ) == NativeColor.red.withAlphaComponent( 128 / 255 ))
	#expect( NativeColor( rgba: 0x00FF00FF ) == NativeColor.green )
	#expect( NativeColor( rgba: 0x0000FF00 ) == NativeColor.blue.withAlphaComponent( 0 ))
}

@Test( "Random colors" )
func uiColorRandomColors() {

	#expect( NativeColor( randomWithAlpha: 1 ).alpha == 1 )
	#expect( NativeColor( randomWithAlpha: 0.3 ).alpha == 0.3 )
	#expect( NativeColor( randomWithAlpha: 0 ).alpha == 0 )

	let randomColors = (0..<100).reduce(
		into: Set<NativeColor>()
	) { acc, _ in
		acc.insert( NativeColor.init( randomWithAlpha: 1 ))
	}

	#expect( randomColors.count == 100 )
}

@Test( "Init from string" )
func uiColorInitFromString() {
	
	#expect( NativeColor( hex: "0xFF0000" ) == NativeColor.red )
	#expect( NativeColor( hex: "00FF00" ) == NativeColor.green )
	#expect( NativeColor( hex: "0000FF" ) == NativeColor.blue )
	#expect( NativeColor( hex: "0xFF0000FF" ) == NativeColor.red )
	#expect( NativeColor( hex: "00FF0080" ) == NativeColor.green.withAlphaComponent( 128 / 255 ))
	#expect( NativeColor( hex: "0x0000FF00" ) == NativeColor.blue.withAlphaComponent( 0 ))

	#expect( NativeColor( hex: "0x0000F" ) == nil )
	#expect( NativeColor( hex: "0000FF0" ) == nil )
}

@Test( "Convert to hex" )
func uiColorConvertToHex() {
	#expect( NativeColor( intRed: 255, green: 0, blue: 0 ).hexRGB == "#FF0000" )
	#expect( NativeColor( intRed: 255, green: 128, blue: 0 ).hexRGB == "#FF8000" )

	#expect( NativeColor( intRed: 0, green: 0, blue: 128, alpha: 0.5 ).hexRGBA == "#0000807F" )
	#expect( NativeColor( intRed: 0, green: 0, blue: 255, alpha: 0 ).hexRGBA == "#0000FF00" )
	#expect( NativeColor( intRed: 255, green: 0, blue: 255, alpha: 1 ).hexRGBA == "#FF00FFFF" )
}
