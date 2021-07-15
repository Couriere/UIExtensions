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

public typealias UIAlertControllerHandler = ( _ alertController: UIAlertController, _ selectedIndex: Int ) -> Void

public extension UIAlertController {

	convenience init(
		title: String?,
		message: String?,
		buttonTitles: [ String ]?,
		handler: UIAlertControllerHandler?
	) {
		let cancelButtonTitle = buttonTitles != nil ? buttonTitles![ 0 ] : "OK"

		self.init( title: title, message: message, preferredStyle: .alert )

		let actionHandler = { ( action: UIAlertAction ) -> Void in
			handler?( self, self.actions.firstIndex( of: action ) ?? -1 )
		}

		self.addAction( UIAlertAction( title: cancelButtonTitle, style: .cancel, handler: actionHandler ))

		if let buttons = buttonTitles {
			for buttonTitle in buttons[ 1 ..< buttons.count ] {
				self.addAction( UIAlertAction( title: buttonTitle, style: .default, handler: actionHandler ) )
			}
		}
	}
}


public extension UIViewController {

	func showUIAlertControllerWithTitle(
		_ title: String?,
		message: String?,
		buttonTitles: [ String ]? = nil,
		handler: UIAlertControllerHandler? = nil
	) {
		dispatch_main_thread_sync {
			let alert = UIAlertController(
				title: title,
				message: message,
				buttonTitles: buttonTitles,
				handler: handler
			)
			self.present( alert, animated: true, completion: nil )
		}
	}
}
#endif
