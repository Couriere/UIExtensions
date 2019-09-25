//
//  Array+Async.swift
//
//  Created by Vladimir on 21.11.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

public extension Array {

	typealias IterationResult = ( Bool ) -> Void
	typealias AsyncIteration = ( Element, _ result: @escaping IterationResult ) -> Void

	/// Аналог фильтра для массива, но каждый вызов итератора может быть асинхронным.
	/// В результате после отработки всех итераторов вызывается обработчик завершения.
	/// Каждому блоку итератор передаёт элемент массива и блок завершения `IterationResult` для передачи результата,
	/// который ОБЯЗАТЕЛЬНО должен быть вызван. Только после вызова `IterationResult` для всех элементов
	/// вызывается блок завершения самого метода `asyncFilter`.
	func asyncFilter( asyncIsIncluded: @escaping AsyncIteration, completion: @escaping ( [ Element ] ) -> Void ) {

		DispatchQueue.global().async {

			var result = self

			let group = DispatchGroup()
			let semaphore = DispatchSemaphore( value: 0 )

			var filteredIndexes: Set<Int> = []

			self.enumerated().forEach { index, element in

				group.enter()

				asyncIsIncluded( element ) { isIncluded in

					if !isIncluded {
						semaphore.wait()
						filteredIndexes.insert( index )
						semaphore.signal()
					}
					group.leave()
				}
			}

			group.wait()

			let sortedFilteredIndexes = filteredIndexes.sorted( by: > )
			sortedFilteredIndexes.forEach { result.remove( at: $0 ) }
			completion( result )
		}
	}
}
