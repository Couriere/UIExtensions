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

	/// Pushes a view controller onto the receiver’s stack and updates the display.
	/// Calls `completion` handler after transition animation is over.
	/// - parameter viewController: The view controller to push onto the stack.
	/// This object cannot be a tab bar controller.
	/// If the view controller is already on the navigation stack, this method throws an exception.
	/// - parameter animated: Specify `true` to animate the transition or `false` if you do not want
	/// the transition to be animated. You might specify `false` if you are setting up
	/// the navigation controller at launch time.
	/// - parameter completion: Handler that will be called after transition animation is finished.
	func pushViewController( _ viewController: UIViewController,
							 animated: Bool = true,
							 completion: @escaping () -> Void ) {

		pushViewController( viewController, animated: animated )
		setCompletionHandler( completion, animated: animated )
	}

	/// Pops the top view controller from the navigation stack and updates the display.
	/// Calls `completion` handler after transition animation is over.
	/// - parameter animated: Set this value to true to animate the transition.
	/// Pass `false if you are setting up a navigation controller before its view is displayed.
	/// - parameter completion: Handler that will be called after transition animation is finished.
	/// - returns: The view controller that was popped from the stack.
	@discardableResult
	func popViewController( animated: Bool = true,
							completion: @escaping () -> Void ) -> UIViewController? {

		let controller = popViewController( animated: animated )
		setCompletionHandler( completion, animated: animated )
		return controller
	}

	/// Pops view controllers until the specified view controller is at the top of the navigation stack.
	/// Calls `completion` handler after transition animation is over.
	/// - parameter viewController: The view controller that you want to be at the top of the stack.
	/// This view controller must currently be on the navigation stack.
	/// - parameter animated: Set this value to true to animate the transition.
	/// Pass `false` if you are setting up a navigation controller before its view is displayed.
	/// - parameter completion: Handler that will be called after transition animation is finished.
	/// - returns: An array containing the view controllers that were popped from the stack.
	/// - note: Completion handler may be called right away if viewController is already at the top of the stack.
	@discardableResult
	func popToViewController( _ viewController: UIViewController,
							  animated: Bool = true,
							  completion: @escaping () -> Void ) -> [ UIViewController ]? {

		guard topViewController != viewController else {
			completion()
			return nil
		}

		let controllers = popToViewController( viewController, animated: animated )
		setCompletionHandler( completion, animated: animated )
		return controllers
	}

	/// Pops all the view controllers on the stack except the root view controller and updates the display.
	/// Calls `completion` handler after transition animation is over.
	/// - parameter animated: Set this value to true to animate the transition.
	/// Pass `false` if you are setting up a navigation controller before its view is displayed.
	/// - parameter completion: Handler that will be called after transition animation is finished.
	/// - returns: An array of view controllers representing the items that were popped from the stack.
	/// - note: Completion handler may be called instantly if navigation top controller is root controller.
	@discardableResult
	func popToRootViewController( animated: Bool = true,
								  completion: @escaping () -> Void ) -> [ UIViewController ]? {

		guard viewControllers.count > 1 else {
			completion()
			return nil
		}

		let controllers = popToRootViewController( animated: animated )
		setCompletionHandler( completion, animated: animated )
		return controllers
	}


	/// Replaces the view controllers currently managed by
	/// the navigation controller with the specified items.
	/// - parameter viewControllers: The view controllers to place in the stack.
	/// The front-to-back order of the controllers in this array represents the new
	/// bottom-to-top order of the controllers in the navigation stack.
	/// Thus, the last item added to the array becomes the top item of the navigation stack.
	/// - parameter animated: If `true`, animate the pushing or popping of the top view controller.
	/// If `false`, replace the view controllers without any animations.
	/// - parameter completion: Handler that will be called after transition animation is finished.
	func setViewControllers( _ viewControllers: [ UIViewController ],
							 animated: Bool,
							 completion: @escaping () -> Void ) {

		setViewControllers( viewControllers, animated: animated )
		setCompletionHandler( completion, animated: animated )
	}



	private func setCompletionHandler( _ completion: @escaping () -> Void, animated: Bool ) {

		guard animated else { completion(); return }

		if let coordinator = transitionCoordinator {
			coordinator.animate( alongsideTransition: nil ) { _ in completion() }
		}
	}
}


/// Pre iOS7 push/pop animation style
public extension UINavigationController {
	
	func pushViewControllerRetro( _ viewController: UIViewController ) {
		let transition = CATransition()
		transition.duration = 0.25
		transition.timingFunction = CAMediaTimingFunction( name: .easeInEaseOut )
		transition.type = .push
		transition.subtype = .fromRight
		view.layer.add( transition, forKey: "RetroPush" )
		
		pushViewController( viewController, animated: false )
	}
	
	func popViewControllerRetro() {
		let transition = CATransition()
		transition.duration = 0.25
		transition.timingFunction = CAMediaTimingFunction( name: .easeInEaseOut )
		transition.type = .push
		transition.subtype = .fromLeft
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


