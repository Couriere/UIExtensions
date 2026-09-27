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

import SwiftUI

struct LoaderOnChangeHelperModifier<V: Equatable & Sendable> {

	let value: V
	let reloadTrigger: Bool
	let initial: Bool
	let action: @MainActor ( _ value: V, _ onAppear: Bool ) async -> Void

	@State private var task: Task<Void, Never>?
}

// MARK: ViewModifier

extension LoaderOnChangeHelperModifier: ViewModifier {

	func body( content: Content ) -> some View {

		content
			.onChange( of: value, or: reloadTrigger ) {
				load( value, onAppear: false )
			}
			.onAppear {
				if initial {
					load( value, onAppear: true )
				}
			}
			.onDisappear {
				task?.cancel()
				task = nil
			}
			.environment( \.loaderTask, TaskWrapper { _ = await task?.result } )
	}

	private func load( _ value: V, onAppear: Bool ) {
		task?.cancel()
		task = Task { await action( value, onAppear ) }
	}
}
