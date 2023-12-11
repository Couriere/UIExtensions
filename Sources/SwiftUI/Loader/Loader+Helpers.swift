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

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
internal extension View {

	func onChangeHelper<V>(
		of value: V,
		reloadTrigger: Bool,
		initial: Bool = false,
		perform action: @escaping ( _ newValue: V, _ onAppear: Bool ) async -> Void
	) -> some View where V : Equatable {

		return self
			.modifier(
				LoaderOnChangeHelperModifier(
					value: value,
					reloadTrigger: reloadTrigger,
					initial: initial,
					action: action
				)
			)
	}
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private struct LoaderOnChangeHelperModifier<V: Equatable>: ViewModifier {

	public let value: V
	public let reloadTrigger: Bool
	public let initial: Bool
	public let action: ( _ value: V, _ onAppear: Bool ) async -> Void

	@State private var task: Task<Void, Never>?

	private struct ValueProxy: Equatable {
		let value: V
		let reloadTrigger: Bool
	}
	private var valueProxy: ValueProxy {
		ValueProxy( value: value, reloadTrigger: reloadTrigger )
	}

	public func body( content: Content ) -> some View {

		content
			.onChange( of: valueProxy ) { proxy in
				task?.cancel()
				task = Task {
					await action( proxy.value, false )
				}
			}
			.onAppear {
				guard initial else { return }

				task?.cancel()
				task = Task {
					await action( value, true )
				}
			}
			.onDisappear {
				task?.cancel()
				task = nil
			}
	}
}
