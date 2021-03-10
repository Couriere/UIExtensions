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

#if canImport(UIKit)
import UIKit

public extension UIDevice {

#if os( iOS )
	var freeSpace: Int64 {
		let url = URL( fileURLWithPath: NSHomeDirectory() )
		let spaceValues = try? url.resourceValues( forKeys: [ .volumeAvailableCapacityForImportantUsageKey] )
		return spaceValues?.volumeAvailableCapacityForImportantUsage ?? 0
	}
#endif

	var modelString: String {
		var systemInfo = utsname()
		uname(&systemInfo )

		let machineMirror = Mirror( reflecting: systemInfo.machine )
		var identifier = ""

		for child in machineMirror.children {
			if let value = child.value as? Int8, value != 0 {
				identifier.append( String(UnicodeScalar( UInt8( value ))))
			}
		}
		return identifier
	}
}
#endif
