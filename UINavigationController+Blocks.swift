//
//  UINavigationController+Blocks.swift
//
//  Created by Vladimir Kazantsev on 14.04.15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

public extension UIViewController {
	
	static var topPresentedViewController: UIViewController? {
		var controller = UIApplication.shared.keyWindow?.rootViewController
		while controller?.presentedViewController != nil {
			controller = controller?.presentedViewController
		}
		return controller
	}
	
	/// Показывает контроллер из контроллера, находящегося на вершине стека.
	/// Если в данный момент этот контроллер показывается или скрывается, то показ
	/// откладывается до момента завершения перехода.
	/// Метод моментально возвращает контроль и проверяет возможность показа асинхронно.
	static func safePresentFromTopViewController( controller: UIViewController, animated: Bool, completion: ( () -> Void )? = nil ) {
		
		safeTopPresentedViewController {
			guard let topViewController = $0 else { completion?(); return }
				
			// Показываем наш контроллер.
			topViewController.present( controller, animated: animated, completion: completion )
		}
	}
	
	/// Вызывает блок завершения после того, как контроллер на вершине стека контроллеров
	/// будет готов к показу нового, то есть не будет в процессе появления или скрытия.
	static func safeTopPresentedViewController( controllerReadyHandler: @escaping ( _ topPresentedViewController: UIViewController? ) -> Void ) {
	
		DispatchQueue.main.async {
			
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

						} else {
							// Если по каким-то причинам координатор перехода отсутствует,
							// повторяем запрос через некоторое время.
							assertionFailure()
							DispatchQueue.main.asyncAfter( timeInterval: 0.1 ) { checkTopViewController() }
						}
						
						return
					}
					
					// Выполняем блок завершения.
					controllerReadyHandler( topViewController )
				
				} else {
					// Если верхний контроллер в стеке на может быть найден,
					// то ничего не делаем и вызываем обработчик завершения.
					controllerReadyHandler( nil )
				}
			}
			
			// Запускаем цикл.
			checkTopViewController()
		}
	}
}

public extension UINavigationController {
	
	func pushViewController( _ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void ) {
			
		pushViewController( viewController, animated: animated )
		setCompletionHandler( completion )
	}

	func popViewControllerAnimated( _ animated: Bool, completion: @escaping () -> Void ) {
		
		popViewController( animated: animated )
		setCompletionHandler( completion )
	}

	func popToViewController( _ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void ) {

		popToViewController( viewController, animated: animated )
		setCompletionHandler( completion )
	}
	
	func popToRootViewControllerAnimated( _ animated: Bool, completion: @escaping () -> Void ) {
		
		popToRootViewController( animated: animated )
		setCompletionHandler( completion )
	}
	
	fileprivate func setCompletionHandler( _ completion: @escaping () -> Void ) {
		if let coordinator = transitionCoordinator {
			coordinator.animate( alongsideTransition: nil ) { _ in
				completion()
			}
		}
	}
}


/// Pre iOS7 push/pop animation style
public extension UINavigationController {
	func pushViewControllerRetro( _ viewController: UIViewController ) {
		let transition = CATransition()
		transition.duration = 0.25
		transition.timingFunction = CAMediaTimingFunction( name: kCAMediaTimingFunctionEaseInEaseOut )
		transition.type = kCATransitionPush;
		transition.subtype = kCATransitionFromRight;
		view.layer.add( transition, forKey: "RetroPush" )
		
		pushViewController( viewController, animated: false )
	}
	
	func popViewControllerRetro() {
		let transition = CATransition()
		transition.duration = 0.25
		transition.timingFunction = CAMediaTimingFunction( name: kCAMediaTimingFunctionEaseInEaseOut )
		transition.type = kCATransitionPush
		transition.subtype = kCATransitionFromLeft
		view.layer.add( transition, forKey: "RetroPop" )
		
		popViewController( animated: false )
	}
}

/// Custom segues for retro Push/Pop
public class RetroPushSegue: UIStoryboardSegue {
	public override func perform() {
		
		guard let navigationController = self.source.navigationController else {
			assertionFailure( "Must be called within UINavigationController" )
			return
		}
		navigationController.pushViewControllerRetro( self.destination )
	}
}

public class RetroPushSegueUnwind: UIStoryboardSegue {
	public override func perform() {
		
		guard let navigationController = self.source.navigationController else {
			assertionFailure( "Must be called within UINavigationController" )
			return
		}
		navigationController.popViewControllerRetro()
	}
}


