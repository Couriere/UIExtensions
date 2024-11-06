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

public extension UIViewController {

	class func instantiate( from storyboard: UIStoryboard, storyboardId: String? = nil ) -> Self {

		let id = storyboardId ?? String( describing: self )
		return storyboard.instantiateViewController( identifier: id )
	}

	class func instantiateAsInitialViewController( in storyboard: UIStoryboard ) -> Self {
		storyboard.instantiateInitialViewController()!
	}

	class func instantiate( from storyboard: UIStoryboard, storyboardId: String? = nil, creator: @escaping (NSCoder) -> Self? ) -> Self {
		let id = storyboardId ?? String( describing: self )
		return storyboard.instantiateViewController( identifier: id, creator: creator )
	}

	class func instantiateAsInitialViewController( from storyboard: UIStoryboard, creator: @escaping (NSCoder) -> Self? ) -> Self {
		storyboard.instantiateInitialViewController( creator: creator )!
	}
}
#endif
