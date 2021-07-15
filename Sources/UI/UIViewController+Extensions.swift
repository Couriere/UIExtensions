//
//  File.swift
//  File
//
//  Created by Vladimir Kazantsev on 15.07.2021.
//

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
