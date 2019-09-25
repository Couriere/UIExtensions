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

public extension UIViewController {

	// If something fails here, it almost certanly a fatal error for application.
	// So we will return actual value or fail instead of returning optional.

	class func instantiate( from storyboard: UIStoryboard, storyboardId: String? = nil ) -> Self {

		let id = storyboardId ?? NSStringFromClass( self ).components( separatedBy: "." ).last!

		let result = storyboard.instantiateViewController( withIdentifier: id )
		return helperConvertObject( result, type: self )
	}

	class func instantiateAsInitialViewController( in storyboard: UIStoryboard ) -> Self {
		let result = storyboard.instantiateInitialViewController()!
		return helperConvertObject( result, type: self )
	}

	private class func helperConvertObject<T>( _ object: AnyObject, type _: T.Type ) -> T {
		return object as! T
	}
}
