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

	/// Performs an action when the specified value changes to the given target value.
	///
	/// Use this modifier to react to a transition into a particular state,
	/// for example when the scene phase becomes `.active`:
	///
	///     .onChange( of: scenePhase, to: .active ) {
	///         refresh()
	///     }
	///
	/// Changes to any other value are ignored.
	///
	/// If `initial` is `true`, the action is also performed when the view
	/// appears and the value already equals the target, the same way
	/// as the system `onChange(of:initial:_:)` does.
	///
	/// - Parameters:
	///   - value: The value to check against when determining whether
	///     to run the closure.
	///   - target: The value that triggers the action.
	///   - initial: Whether the action should be run when this view initially
	///     appears and `value` already equals `target`.
	///   - action: A closure to run when the value changes to `target`.
	/// - Returns: A view that fires an action when the specified value changes to `target`.
	@inlinable
	public func onChange<V>(
		of value: V,
		to target: V,
		initial: Bool = false,
		_ action: @escaping () -> Void,
	) -> some View where V: Equatable {

		onChange( of: value, initial: initial ) { _, newValue in
			if newValue == target { action() }
		}
	}

	/// Performs an action when the specified value changes to a value
	/// that satisfies the given predicate.
	///
	/// Use this modifier to react to a transition into any of several states,
	/// for example when the scene phase leaves `.background`:
	///
	///     .onChange( of: scenePhase, to: { $0 != .background } ) {
	///         refresh()
	///     }
	///
	/// Changes to values that don't satisfy the predicate are ignored.
	///
	/// If `initial` is `true`, the action is also performed when the view
	/// appears and the value already satisfies the predicate, the same way
	/// as the system `onChange(of:initial:_:)` does.
	///
	/// - Parameters:
	///   - value: The value to check against when determining whether
	///     to run the closure.
	///   - predicate: A closure that returns `true` for the new values
	///     that trigger the action.
	///   - initial: Whether the action should be run when this view initially
	///     appears and `value` already satisfies `predicate`.
	///   - action: A closure to run when the value changes to a value
	///     that satisfies `predicate`.
	/// - Returns: A view that fires an action when the specified value changes
	///   to a value that satisfies `predicate`.
	@inlinable
	public func onChange<V>(
		of value: V,
		to predicate: @escaping ( V ) -> Bool,
		initial: Bool = false,
		_ action: @escaping () -> Void,
	) -> some View where V: Equatable {

		onChange( of: value, initial: initial ) { _, newValue in
			if predicate( newValue ) { action() }
		}
	}
}
