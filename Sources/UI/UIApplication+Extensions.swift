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

public extension UIApplication {

	/// Returns the currently active `UIWindowScene`.
	static var activeScene: UIWindowScene? {
		UIApplication.shared
			.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.first { $0.activationState.isIn( .foregroundActive, .foregroundInactive ) }
	}

	/// Returns the key window of the currently active scene.
	@available(iOS 15.0, tvOS 15.0, *)
	static var keyWindow: UIWindow? {
		activeScene?.keyWindow
	}

	/// Ends editing and dismisses the keyboard for the application.
	func endEditing() {
		sendAction(
			#selector( UIResponder.resignFirstResponder ),
			to: nil,
			from: nil,
			for: nil
		)
	}
}

public extension UIApplication {

	var topPresentedViewController: UIViewController? {
		var controller = self.windows.first { $0.isKeyWindow }?.rootViewController
		while let presentedViewController = controller?.presentedViewController {
			controller = presentedViewController
		}
		return controller
	}

	/// Показывает контроллер из контроллера, находящегося на вершине стека.
	/// Если в данный момент этот контроллер показывается или скрывается, то показ
	/// откладывается до момента завершения перехода.
	/// Метод моментально возвращает контроль и проверяет возможность показа асинхронно.
	func safePresentFromTopViewController(
		controller: UIViewController,
		animated: Bool,
		completion: ( () -> Void )? = nil
	) {
		safeTopPresentedViewController {
			guard let topViewController = $0 else { completion?(); return }
			topViewController.present( controller, animated: animated, completion: completion )
		}
	}

	/// Вызывает блок завершения после того, как контроллер на вершине стека контроллеров
	/// будет готов к показу нового, то есть не будет в процессе появления или скрытия.
	func safeTopPresentedViewController(
		controllerReadyHandler: @escaping ( _ topPresentedViewController: UIViewController? ) -> Void
	) {
		func checkTopViewController() {

			if let topViewController = topPresentedViewController {

				if topViewController.isBeingPresented || topViewController.isBeingDismissed {

					// Верхний контроллер в стеке сейчас в процессе показа или скрытия.
					if let transitionCoordinator = topViewController.transitionCoordinator {
						// Сейчас у контроллера должен быть `transitionCoordinator`.
						// Используем его, чтобы определить момент завершения перехода.
						transitionCoordinator.animate( alongsideTransition: nil ) { _ in
							checkTopViewController()
						}
					}
					else {
						// Если по каким-то причинам координатор перехода отсутствует,
						// повторяем запрос через некоторое время.
						assertionFailure()
						DispatchQueue.main.asyncAfter( timeInterval: 0.1 ) { checkTopViewController() }
					}

					return
				}

				// Выполняем блок завершения.
				controllerReadyHandler( topViewController )
			}
			else {
				// Если верхний контроллер в стеке на может быть найден,
				// то ничего не делаем и вызываем обработчик завершения.
				controllerReadyHandler( nil )
			}
		}

		DispatchQueue.main.async {
			// Запускаем цикл.
			checkTopViewController()
		}
	}
}
#endif
