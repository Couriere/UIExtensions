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

@Suite("Array+ExtensionsTests")
struct ArrayTests {

	// MARK: - Array Optional Init

	@Test
	func optionalInit() {
		let optionalIntVar: Int? = 50
		let optionalEmptyIntVar: Int? = nil

		#expect(Array(optionalIntVar) == [50])
		#expect(Array(optionalEmptyIntVar).isEmpty)
	}

	// MARK: - Plus Operator

	@Test
	func plusOperator() {
		let array: [Int] = [10, 20, 30]

		let intVar = 40
		let optionalIntVar: Int? = 50
		let optionalEmptyIntVar: Int? = nil

		#expect(array + intVar == [10, 20, 30, 40])
		#expect(array + optionalIntVar == [10, 20, 30, 50])
		#expect(array + optionalEmptyIntVar == [10, 20, 30])

		let emptyArray: [Int] = []

		#expect(emptyArray + intVar == [40])
		#expect(emptyArray + optionalIntVar == [50])
		#expect((emptyArray + optionalEmptyIntVar).isEmpty)
	}

	// MARK: - Appending

	@Test
	func appending() {
		let array: [Int] = [10, 20, 30]
		let intVar = 40

		#expect(array.appending(intVar) == [10, 20, 30, 40])

		let emptyArray: [Int] = []
		#expect(emptyArray.appending(intVar) == [40])
	}

	// MARK: - Plus Equal Operator

	@Test
	func plusEqualOperator() {
		var array: [Int] = [10, 20, 30]

		let intVar = 40
		let optionalIntVar: Int? = 50
		let optionalEmptyIntVar: Int? = nil

		array += intVar
		#expect(array == [10, 20, 30, 40])

		array += optionalIntVar
		#expect(array == [10, 20, 30, 40, 50])

		array += optionalEmptyIntVar
		#expect(array == [10, 20, 30, 40, 50])

		var emptyArray: [Int] = []

		emptyArray += intVar
		#expect(emptyArray == [40])

		emptyArray = []
		emptyArray += optionalIntVar
		#expect(emptyArray == [50])

		emptyArray = []
		emptyArray += optionalEmptyIntVar
		#expect(emptyArray.isEmpty)
	}

	// MARK: - Safe Index

	@Test
	func safeIndexProperties() {
		for _ in 0..<1_000 {
			let count = Int.random(in: 0...50)
			let array = (0..<count).map { Int.random(in: -1_000...1_000) }

			// Valid indices
			for index in 0..<count {
				#expect(array[safe: index] == array[index])
			}

			// Invalid indices
			#expect(array[safe: -1] == nil)
			#expect(array[safe: count] == nil)
			#expect(array[safe: count + Int.random(in: 1...10)] == nil)
		}
	}

	// MARK: - Chunk

	@Test
	func chunkProperties() {

		for _ in 0..<1_000 {

			let array = (0..<Int.random(in: 0...100))
				.map { Int.random(in: 0...1_000) }
			let chunkSize = Int.random(in: 1...10)

			let chunks = array.chunk(chunkSize)

			// Property 1: Flatten preserves elements
			let flattened = chunks.flatMap { $0 }
			#expect(flattened == array)

			// Property 2: Chunk sizes are valid
			for chunk in chunks.dropLast() {
				#expect(chunk.count == chunkSize)
			}

			// Property 3: Last chunk size is valid
			if let last = chunks.last {
				#expect(last.count <= chunkSize)
				#expect(!last.isEmpty)
			}
		}
	}

	// MARK: - First IndexPath

	@Test
	func firstIndexPath() {
		let array = [[10, 20], [30, 40, 45], [], [50, 60, 10, 70]]

		#expect(array.firstIndexPath(of: 20) == IndexPath(item: 1, section: 0))
		#expect(array.firstIndexPath(of: 30) == IndexPath(item: 0, section: 1))
		#expect(array.firstIndexPath(of: 10) == IndexPath(item: 0, section: 0))
		#expect(array.firstIndexPath(of: 70) == IndexPath(item: 3, section: 3))
		#expect(array.firstIndexPath(of: 0) == nil)

		#expect(array.firstIndexPath(where: { $0 == 20 }) == IndexPath(item: 1, section: 0))
		#expect(array.firstIndexPath(where: { $0 == 30 }) == IndexPath(item: 0, section: 1))
		#expect(array.firstIndexPath(where: { $0 == 10 }) == IndexPath(item: 0, section: 0))
		#expect(array.firstIndexPath(where: { $0 == 70 }) == IndexPath(item: 3, section: 3))
		#expect(array.firstIndexPath(where: { $0 == 0 }) == nil)
	}

	// MARK: - First Identifiable IndexPath

	@Test
	func firstIdentifiableIndexPath() {
		struct I: Identifiable, ExpressibleByStringLiteral {
			let id: String

			init(stringLiteral: String) {
				self.id = stringLiteral
			}
		}

		let array: [[I]] = [
			["10", "20"],
			["30", "40", "45"],
			[],
			["50", "60", "10", "70"]
		]

		#expect(array.firstIndexPath(of: "20") == IndexPath(item: 1, section: 0))
		#expect(array.firstIndexPath(of: "30") == IndexPath(item: 0, section: 1))
		#expect(array.firstIndexPath(of: "10") == IndexPath(item: 0, section: 0))
		#expect(array.firstIndexPath(of: "70") == IndexPath(item: 3, section: 3))
		#expect(array.firstIndexPath(of: "0") == nil)
	}

	// MARK: - Windows

	@Test
	func windowsProperties() {

		for _ in 0..<1_000 {
			
			let arrayCount = Int.random(in: 0...50)
			let array = (0..<arrayCount).map { Int.random(in: 0...1_000) }
			let windowSize = Int.random(in: 1...10)

			let windows = array.windows(ofCount: windowSize)

			// Property 1: Window size
			#expect(windows.allSatisfy { $0.count == windowSize })

			// Property 2: Window count formula
			let expectedCount = max(0, array.count - windowSize + 1)
			#expect(windows.count == expectedCount)

			// Property 3: Order preservation
			for (index, window) in windows.enumerated() {
				let expected = Array(array[index..<index + windowSize])
				#expect(window == expected)
			}
		}
	}
}
