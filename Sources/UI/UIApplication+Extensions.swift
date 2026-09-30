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

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIApplication {

	/// Returns the currently active `UIWindowScene`.
	static var activeScene: UIWindowScene? {
		UIApplication.shared
			.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.first { $0.activationState.isIn( .foregroundActive, .foregroundInactive ) }
	}

	static var keyWindow: UIWindow? {
		activeScene?.keyWindow
	}

	/// Ends editing and dismisses the keyboard for the application.
	func endEditing() {
		sendAction(
			#selector( UIResponder.resignFirstResponder ),
			to: nil,
			from: nil,
			for: nil,
		)
	}
}

public extension UIApplication {

	var topPresentedViewController: UIViewController? {
		var controller = UIApplication.keyWindow?.rootViewController
		while let presentedViewController = controller?.presentedViewController {
			controller = presentedViewController
		}
		return controller
	}

	/// Presents a view controller from the controller currently at the top of the presentation stack.
	/// If that controller is currently presenting or dismissing, presentation is deferred
	/// until the transition finishes. This method returns immediately and checks
	/// asynchronously when presentation is possible.
	func safePresentFromTopViewController(
		controller: UIViewController,
		animated: Bool,
		completion: ( () -> Void )? = nil,
	) {
		safeTopPresentedViewController {
			guard let topViewController = $0 else { completion?(); return }
			topViewController.present( controller, animated: animated, completion: completion )
		}
	}

	/// Calls the completion handler when the topmost controller is ready to present
	/// another controller, meaning it is not currently presenting or dismissing.
	func safeTopPresentedViewController(
		controllerReadyHandler: @escaping ( _ topPresentedViewController: UIViewController? ) -> Void,
	) {
		func checkTopViewController() {

			if let topViewController = topPresentedViewController {

				if topViewController.isBeingPresented || topViewController.isBeingDismissed {

					// The topmost controller is currently presenting or dismissing.
					if let transitionCoordinator = topViewController.transitionCoordinator {
						// Use the transition coordinator to detect when the transition finishes.
						transitionCoordinator.animate( alongsideTransition: nil ) { _ in
							checkTopViewController()
						}
					}
					else {
						// If the transition coordinator is unavailable, retry after a short delay.
						assertionFailure()
						DispatchQueue.main.asyncAfter( timeInterval: 0.1 ) { checkTopViewController() }
					}

					return
				}

				// Run the completion handler.
				controllerReadyHandler( topViewController )
			}
			else {
				// If the topmost controller cannot be found, call the completion handler with nil.
				controllerReadyHandler( nil )
			}
		}

		DispatchQueue.main.async {
			// Start checking the topmost controller.
			checkTopViewController()
		}
	}
}
#endif
