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

	/// Executes the provided closure on every appearance of the view
	/// except for the very first one.
	///
	/// Use this modifier to defer work until the view reappears,
	/// for example after navigating back, while explicitly skipping
	/// the initial presentation. It is the counterpart of
	/// ``SwiftUI/View/onFirstAppear(_:)``.
	///
	/// - Parameter action: A closure to execute on each subsequent appearance.
	/// - Returns: A view that performs the action on all appearances after the first.
	public func onReappear( _ action: @escaping () -> Void ) -> some View {

		modifier(
			_OnReappearModifier( action: action )
		)
	}

	/// Runs the given asynchronous action on every appearance of the view
	/// except for the very first one.
	///
	/// Use this modifier to perform asynchronous work when the view
	/// re-enters the screen, for example after navigating back, while
	/// explicitly skipping the initial presentation.
	///
	/// The action is launched from the view's appearance lifecycle, so if
	/// the view disappears while the action is running, the task is
	/// cancelled, and cooperative cancellation applies to any awaited work.
	///
	/// - Parameters:
	///   - priority: The priority of the asynchronous task.
	///   - action: An asynchronous closure to execute on each subsequent appearance.
	/// - Returns: A view that triggers the asynchronous action on all
	///   appearances after the first.
	// NOTE: The action stays `@escaping @Sendable` on purpose. Rewriting it as
	// `sending @escaping @isolated(any)` requires function type metadata that is
	// not back-deployed and crashes at runtime on systems older than iOS 18.
	// Revisit once the minimum deployment target reaches iOS 18.
	public func onReappear(
		priority: TaskPriority = .userInitiated,
		@_inheritActorContext _ action: @escaping @Sendable () async -> Void,
	) -> some View {

		modifier(
			_OnReappearAsyncModifier(
				priority: priority,
				action: action
			)
		)
	}
}

struct _OnReappearModifier {

	let action: () -> Void
	@State private var hasAppeared = false

	init( action: @escaping () -> Void ) {
		self.action = action
	}
}

// MARK: ViewModifier

extension _OnReappearModifier: ViewModifier {

	func body( content: Content ) -> some View {

		content.onAppear {

			if hasAppeared {
				action()
			} else {
				hasAppeared = true
			}
		}
	}
}

struct _OnReappearAsyncModifier {

	let priority: TaskPriority
	let action: @Sendable () async -> Void
	@State private var hasAppeared = false

	init(
		priority: TaskPriority,
		action: @escaping @Sendable () async -> Void,
	) {
		self.priority = priority
		self.action = action
	}
}

// MARK: ViewModifier

extension _OnReappearAsyncModifier: ViewModifier {

	func body( content: Content ) -> some View {

		content.task( priority: priority ) {

			if hasAppeared {
				await action()
			} else {
				hasAppeared = true
			}
		}
	}
}
