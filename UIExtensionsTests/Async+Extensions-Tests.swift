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
import Testing
import UIExtensions

/// Collects the values passed to debounced actions on the main actor.
@MainActor
private final class Log {
	var values: [Int] = []
}

@MainActor
@Test
func `Debounce runs the action after the delay`() async {
	let log = Log()
	let clock = ContinuousClock()
	let start = clock.now

	await Task.debounce( for: 0.05 ) {
		log.values.append( 1 )
	}

	#expect( log.values == [ 1 ] )
	#expect( clock.now - start >= .milliseconds( 50 ))
}

@MainActor
@Test
func `Debounce skips the action when cancelled during the delay`() async {
	let log = Log()

	let task = Task {
		await Task.debounce( for: 5 ) {
			log.values.append( 1 )
		}
	}
	task.cancel()
	await task.value

	#expect( log.values.isEmpty )
}

@MainActor
@Test
func `Debounce runs only the last of rapidly restarted tasks`() async {
	let log = Log()
	var tasks: [Task<Void, Never>] = []

	// Mimics `task( id: )`: every new value cancels the previous task.
	func restart( with value: Int ) {
		tasks.last?.cancel()
		tasks.append( Task {
			await Task.debounce( for: 0.05 ) {
				log.values.append( value )
			}
		})
	}

	restart( with: 1 )
	await tasks.last?.value

	restart( with: 2 )
	restart( with: 3 )
	restart( with: 4 )
	for task in tasks {
		await task.value
	}

	#expect( log.values == [ 1, 4 ] )
}

@MainActor
@Test
func `Debounce action inherits the main actor`() async {
	let log = Log()

	// Synchronous access to main actor state compiles only
	// when the action inherits the caller's isolation.
	await Task.debounce( for: 0.01 ) {
		MainActor.assertIsolated()
		log.values.append( 1 )
	}

	#expect( log.values == [ 1 ] )
}

private actor Counter {

	var value = 0

	func increment() async {
		await Task.debounce( for: 0.01 ) {
			self.assertIsolated()
			self.value += 1
		}
	}
}

@Test
func `Debounce action runs on the calling actor`() async {
	let counter = Counter()

	await counter.increment()

	#expect( await counter.value == 1 )
}
