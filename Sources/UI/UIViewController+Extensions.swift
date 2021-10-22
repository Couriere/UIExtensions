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

@available( iOSApplicationExtension, unavailable )
public extension UIViewController {

	static var topPresentedViewController: UIViewController? {
		return UIApplication.shared.topPresentedViewController
	}

	/// Показывает контроллер из контроллера, находящегося на вершине стека.
	/// Если в данный момент этот контроллер показывается или скрывается, то показ
	/// откладывается до момента завершения перехода.
	/// Метод моментально возвращает контроль и проверяет возможность показа асинхронно.
	static func safePresentFromTopViewController(
		controller: UIViewController,
		animated: Bool,
		completion: ( () -> Void )? = nil )
	{
		UIApplication.shared.safePresentFromTopViewController(
			controller: controller,
			animated: animated,
			completion: completion
		)
	}

	/// Вызывает блок завершения после того, как контроллер на вершине стека контроллеров
	/// будет готов к показу нового, то есть не будет в процессе появления или скрытия.
	static func safeTopPresentedViewController(
		controllerReadyHandler: @escaping ( _ topPresentedViewController: UIViewController? ) -> Void
	) {
		UIApplication.shared.safeTopPresentedViewController( controllerReadyHandler: controllerReadyHandler )
	}
}
#endif
