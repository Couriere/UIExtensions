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

@Suite("Sequences+ExtensionsTests")
struct SequencesExtensionsTests {

    private struct Item {
        let id: Int
        let value: Int
        let isActive: Bool
    }

    @Test
    func containsKeyPathEqualValueProperties() {
        for _ in 0..<1_000 {
            let count = Int.random(in: 10...100)
            let items = (0..<count).map { index in
                Item(
                    id: index,
                    value: Int.random(in: -1_000...1_000),
                    isActive: Bool.random()
                )
            }

            let targetId: Int
            if let randomItem = items.randomElement() {
                targetId = randomItem.id
            } else {
                targetId = Int.random(in: 0...100)
            }

            let expectedContains = items.contains { $0.id == targetId }
            #expect(items.contains(\.id, equal: targetId) == expectedContains)

            let expectedActive = items.contains { $0.isActive }
            #expect(items.contains(\.isActive) == expectedActive)
        }
    }

    @Test
    func sortedKeyPathProperties() {
        for _ in 0..<1_000 {
            let count = Int.random(in: 10...100)
            let items = (0..<count).map { index in
                Item(
                    id: index,
                    value: Int.random(in: -1_000...1_000),
                    isActive: Bool.random()
                )
            }

            let forward = items.sorted(\.value, order: .forward)
            for index in 1..<forward.count {
                #expect(forward[index - 1].value <= forward[index].value)
            }

            let reverse = items.sorted(\.value, order: .reverse)
            for index in 1..<reverse.count {
                #expect(reverse[index - 1].value >= reverse[index].value)
            }

            let originalIds = items.map(\.id).sorted()
            #expect(forward.map(\.id).sorted() == originalIds)
            #expect(reverse.map(\.id).sorted() == originalIds)
        }
    }

    @Test
    func sortKeyPathProperties() {
        for _ in 0..<1_000 {
            let count = Int.random(in: 10...100)
            var items = (0..<count).map { index in
                Item(
                    id: index,
                    value: Int.random(in: -1_000...1_000),
                    isActive: Bool.random()
                )
            }

            let originalIds = items.map(\.id).sorted()

            items.sort(\.value, order: .forward)
            for index in 1..<items.count {
                #expect(items[index - 1].value <= items[index].value)
            }
            #expect(items.map(\.id).sorted() == originalIds)

            items.sort(\.value, order: .reverse)
            for index in 1..<items.count {
                #expect(items[index - 1].value >= items[index].value)
            }
            #expect(items.map(\.id).sorted() == originalIds)
        }
    }
}
