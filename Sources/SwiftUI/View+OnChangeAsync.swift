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
public extension View {

	/// Adds a modifier for this view that fires an asynchronous action when a specific
	/// value changes.
	///
	/// You can use `onChange` to trigger a side effect as the result of a
	/// value changing, such as an `Environment` key or a `Binding`.
	///
	/// If the task doesn't finish before SwiftUI removes the view
	/// or the view changes identity, SwiftUI cancels the task.
	///
	/// If `initial` parameter is true, this modifier perform an asynchronous
	/// task with a lifetime that matches that of the modified view.
	///
	/// The old and new observed values are passed into the closure.
	///
	/// - Parameters:
	///   - value: The value to check against when determining whether
	///     to run the closure.
	///   - initial: Whether the action should be run when this view initially
	///     appears.
	///   - priority: The priority of the asynchronous task.
	///   - action: An asynchronous closure to run when the value changes.
	///
	/// - Note: If the value changes while a previous asynchronous task is still running,
	///   the previous task will be cancelled, and the new task
	///   will be executed with the most recent value.
	///
	/// - Returns: A view that fires an asynchronous action when the specified value changes.
	func onChange<V>(
		of value: V,
		initial: Bool = false,
		priority: TaskPriority = .userInitiated,
		_ action: @escaping (_ oldValue: V, _ newValue: V) async -> Void
	) -> some View where V : Equatable {

		return self
			.modifier(
				OnChangeAsyncModifier(
					value: value,
					initial: initial,
					priority: priority,
					action: action
				)
			)
	}

	/// Adds a modifier for this view that fires an asynchronous action when a specific
	/// value changes.
	///
	/// You can use `onChange` to trigger a side effect as the result of a
	/// value changing, such as an `Environment` key or a `Binding`.
	///
	/// If the task doesn't finish before SwiftUI removes the view
	/// or the view changes identity, SwiftUI cancels the task.
	///
	/// If `initial` parameter is true, this modifier perform an asynchronous
	/// task with a lifetime that matches that of the modified view.
	///
	/// - Parameters:
	///   - value: The value to check against when determining whether
	///     to run the closure.
	///   - initial: Whether the action should be run when this view initially
	///     appears.
	///   - priority: The priority of the asynchronous task.
	///   - action: An asynchronous closure to run when the value changes.
	///
	/// - Note: If the value changes while a previous asynchronous task is still running,
	///   the previous task will be cancelled, and the new task
	///   will be executed with the most recent value.
	///
	/// - Returns: A view that fires an asynchronous action when the specified value changes.
	func onChange<V>(
		of value: V,
		initial: Bool = false,
		priority: TaskPriority = .userInitiated,
		_ action: @escaping () async -> Void
	) -> some View where V : Equatable {

		return self
			.modifier(
				OnChangeAsyncModifier(
					value: value,
					initial: initial,
					priority: priority,
					action: { _, _ in await action() }
				)
			)
	}
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension View {

	/// Adds a modifier for this view that fires an asynchronous action when a specific
	/// value changes.
	///
	/// You can use `onChange` to trigger a side effect as the result of a
	/// value changing, such as an `Environment` key or a `Binding`.
	///
	/// If the task doesn't finish before SwiftUI removes the view
	/// or the view changes identity, SwiftUI cancels the task.
	///
	/// If `initial` parameter is true, this modifier perform an asynchronous
	/// task with a lifetime that matches that of the modified view.
	///
	/// SwiftUI passes the new value into the closure.
	///
	/// - Parameters:
	///   - value: The value to check against when determining whether
	///     to run the closure.
	///   - initial: Whether the action should be run when this view initially
	///     appears.
	///   - priority: The priority of the asynchronous task.
	///   - action: An asynchronous closure to run when the value changes.
	///
	/// - Note: If the value changes while a previous asynchronous task is still running,
	///   the previous task will be cancelled, and the new task
	///   will be executed with the most recent value.
	///
	/// - Returns: A view that fires an asynchronous action when the specified value changes.
	@available(iOS, deprecated: 17.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
	@available(macOS, deprecated: 14.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
	@available(tvOS, deprecated: 17.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
	@available(watchOS, deprecated: 10.0, message: "Use `onChange` with a two or zero parameter action closure instead.")
	func onChange<V>(
		of value: V,
		initial: Bool = false,
		priority: TaskPriority = .userInitiated,
		perform action: @escaping  (_ newValue: V) async -> Void
	) -> some View where V : Equatable {

		return self
			.modifier(
				OnChangeAsyncModifier(
					value: value,
					initial: initial,
					priority: priority,
					action: { _, newValue in await action( newValue ) }
				)
			)
	}
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct OnChangeAsyncModifier<V>: ViewModifier where V: Equatable {

	public let value: V
	public let initial: Bool
	public let priority: TaskPriority
	public let action: ( _ oldValue: sending V, _ newValue: sending V ) async -> Void

	@State private var task: Task<Void, Never>?

	public func body( content: Content ) -> some View {

		if #available( iOS 17, tvOS 17, macOS 14, watchOS 10, * ) {
			content
				.onChange( of: value, initial: initial ) { oldValue, newValue in
					task?.cancel()
					task = Task( priority: priority ) {
						await action( oldValue, newValue )
					}
				}
				.onDisappear {
					task?.cancel()
					task = nil
				}
		}
		else {

			content
				.onChange( of: value ) { [oldValue=value] newValue in
					task?.cancel()
					task = Task( priority: priority ) {
						await action( oldValue, newValue )
					}
				}
				.onAppear {
					guard initial else { return }

					task?.cancel()
					task = Task( priority: priority ) { [action, value] in
						await action( value, value )
					}
				}
				.onDisappear {
					task?.cancel()
					task = nil
				}
		}
	}
}
