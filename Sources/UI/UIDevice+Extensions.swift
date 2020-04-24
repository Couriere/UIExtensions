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

public extension UIDevice {

#if os( iOS )
	@available( iOS 11.0, * )
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

	var modelName: String {

		let identifier = modelString

		switch identifier {

		case "iPod5,1": return "iPod Touch 5"
		case "iPod7,1": return "iPod Touch 6"
		case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
		case "iPhone4,1": return "iPhone 4s"
		case "iPhone5,1", "iPhone5,2": return "iPhone 5"
		case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
		case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
		case "iPhone7,2": return "iPhone 6"
		case "iPhone7,1": return "iPhone 6 Plus"
		case "iPhone8,1": return "iPhone 6s"
		case "iPhone8,2": return "iPhone 6s Plus"
		case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
		case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
		case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
		case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
		case "iPad5,3", "iPad5,4": return "iPad Air 2"
		case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
		case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
		case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
		case "iPad5,1", "iPad5,2": return "iPad Mini 4"
		case "iPad6,7", "iPad6,8": return "iPad Pro"
		case "AppleTV5,3": return "Apple TV"
		case "i386", "x86_64": return "Simulator"
		default: return identifier
		}
	}


	var deviceTypeString: String {

		if UIDevice.current.userInterfaceIdiom == .pad {
			return "iphonehd"
		}

		if UIScreen.main.scale > 1 {
			return "ipadhd"
		}

		return "ipad"
	}
}
