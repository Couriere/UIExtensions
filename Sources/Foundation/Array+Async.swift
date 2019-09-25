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
