////
////  Event.swift
////
////  Created by Vladimir Kazantsev on 10/11/15.
////  Copyright © 2015. All rights reserved.
////
//
// Idea from https://gist.github.com/ColinEberhardt/05fafaca143ac78dbe09
//


import Foundation

/// An object that has some tear-down logic
public protocol Disposable: class {
	func dispose()
}


/**
 An event provides a mechanism for raising notifications, together with some
 associated data. Multiple function handlers can be added, with each being invoked,
 with the event data, when the event is raised.

 ```
 func someFunction() {

 // create an event
 let event = Event<(String, String)>()

 // add a handler
 let handler = event.addHandler(self, ViewController.handleEvent)

 // raise the event
 event.raise("Colin", "Eberhardt")

 // remove the handler
 handler.dispose()
 }

 func handleEvent(data: (String, String)) {
 println("Hello \(data.0), \(data.1)")
 }
 ```
 */
open class Event<T> {

	public init() {}

	/// Количество обработчиков, подписанных на изменения события.
	open var handlersCount: Int { return handlers.count }

	/// Блок, вызываемый при добавлении/удалении обработчиков.
	open var watchersChangeHandler: (( Event, _ newHandlers: [ Invocable ] ) -> Void )?


	/// Сигналит событие.
	/// - parameter data: Данные, которые будут переданы обработчику.
	/// Будут вызваны все обработчики, назначенные данному событию.
	open func raise( _ data: T ) {
		raise( data, onHandlers: nil )
	}

	/// Сигналит событие.
	/// - parameter data: Данные, которые будут переданы обработчику.
	/// - parameter onHandlers: Обработчики, которым будут переданы данные. Если `nil`,
	/// то будут вызваны все обработчики, назначенные данному событию.
	open func raise( _ data: T, onHandlers: [ Invocable ]? ) {

		for handler in onHandlers ?? handlers {
			if let queue = handler.queue {
				queue.async { handler.invoke( data ) }
			}
			else {
				handler.invoke( data )
			}
		}
	}

	/// Регистрирует метод как обработчика события.
	/// Пример:
	/// - parameter target: Объект, чей метод будет вызван в качестве обработчика события.
	/// - parameter queue: Поток, в котором будет выполняться обработчик. Если `nil`, то обработчик вызовется в
	/// потоке, который вызвал `raise()`.
	/// - parameter handler: Адрес метода объекта `target`, который будет вызван как обработчик события
	/// - returns: Ссылка на зарегистрированный обработчик.
	@discardableResult
	open func addHandler<U: AnyObject>( _ target: U, queue: DispatchQueue? = nil, handler: @escaping (U) -> (T) -> Void ) -> Disposable {
		let wrapper = EventHandlerWrapper(target: target, queue: queue, handler: .method( handler ), event: self)
		handlers.append( wrapper )
		return wrapper
	}


	/// Регистрирует метод как обработчика события.
	/// Пример:
	/// - parameter target: Объект, являющийся владельцем блока `closure`.
	/// При уничтожении объекта, блок `closure` будет также со временем удалён из памяти.
	/// **Внимание!** Не стоит в блоке забывать указывать `self` как `unowned` или `weak`
	/// Однако можно всегда безопасно использовать `[unowned self]`, так как при нулевом `self`
	/// обработчик просто не вызовется.
	/// - parameter queue: Поток, в котором будет выполняться обработчик. Если `nil`, то обработчик вызовется в
	/// потоке, который вызвал `raise()`.
	/// - parameter closure: Блок, вызываемый при сигнале.
	/// - returns: Ссылка на зарегистрированный обработчик.
	@discardableResult
	open func addClosureHandler<U: AnyObject>( _ target: U, queue: DispatchQueue? = nil, closure: @escaping (T) -> Void ) -> Disposable {
		let wrapper = EventHandlerWrapper( target: target, queue: queue, handler: .closure( closure ), event: self )
		handlers.append( wrapper )
		return wrapper
	}

	fileprivate var handlers: [ Invocable ] = [] {
		didSet {
			/// Находим добавленных наблюдателей. Удалённые нам не нужны.
			let addedHandlers = handlers.filter { newHandler in
				!oldValue.contains { return $0 === newHandler }
			}
			watchersChangeHandler?( self, addedHandlers )
		}
	}
}

public extension Event where T == Void {
	func raise() {
		raise( () )
	}
}

// MARK: - Private

// A protocol for a type that can be invoked
public protocol Invocable: class {
	func invoke( _ data: Any )
	var queue: DispatchQueue? { get }
}

private class EventHandlerWrapper<T: AnyObject, U>: Invocable, Disposable {

	init( target: T?, queue: DispatchQueue?, handler: HandlerType<T, U>, event: Event<U> ) {
		self.target = target
		self.queue = queue
		handlerMethod = handler
		self.event = event
	}

	func invoke( _ data: Any ) {
		if let targetSelf = target {
			switch handlerMethod {
			case let .method( handler ):
				handler( targetSelf )( data as! U )
			case let .closure( handler ):
				handler( data as! U )
			}
		}
		else {
			dispose()
		}
	}

	func dispose() {
//		assert( event.handlers.filter { $0 === self }.first != nil )
		if let event = event {
			event.handlers = event.handlers.filter { $0 !== self }
		}
	}

	let queue: DispatchQueue?

	private weak var target: T?
	private let handlerMethod: HandlerType<T, U>
	private weak var event: Event<U>?
}

private enum HandlerType<T: AnyObject, U> {
	case method( (T) -> (U) -> Void )
	case closure( (U) -> Void )
}
