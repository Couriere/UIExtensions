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

extension View {

	/// Executes the provided closure exactly once
	/// when the view appears for the first time.
	///
	/// Use this modifier to perform initial setup,
	/// data loading, or analytics on the first
	/// presentation of the `View`.
	/// Subsequent appearances of the same `View`
	/// (for example, when navigating back and forth)
	/// will not trigger the action again.
	///
	/// - Parameter action: A closure to execute once on the first appearance.
	/// - Returns: A modified view that performs the action on its first appearance.
	@inlinable
	public func onFirstAppear( _ action: @escaping () -> Void ) -> some View {

		modifier(
			_OnFirstAppearModifier( action: action )
		)
	}
}

@usableFromInline
struct _OnFirstAppearModifier {

	let action: () -> Void
	@State private var hasAppeared = false

	@usableFromInline
	init( action: @escaping () -> Void ) {
		self.action = action
	}
}

extension _OnFirstAppearModifier: ViewModifier {

	@usableFromInline
	func body( content: Content ) -> some View {

		content.onAppear {

			if !hasAppeared {
				hasAppeared = true
				action()
			}
		}
	}
}

