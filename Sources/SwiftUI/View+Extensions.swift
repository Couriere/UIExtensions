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

	/// Positions this view within an invisible frame with the specified size.
	///
	/// - Parameters:
	///   - size: A fixed size for the resulting view.
	///   - alignment: The alignment of this view inside the resulting frame.
	///     Note that most alignment values have no apparent effect when the
	///     size of the frame happens to match that of this view.
	///
	/// - Returns: A view with fixed dimensions of `size`.
	///
	@inlinable
	public func frame(
		_ size: CGSize,
		alignment: Alignment = .center
	) -> some View {

		self.frame(
			width: size.width,
			height: size.height,
			alignment: alignment
		)
	}

	/// Sets the frame of the view to a square with the specified side length and
	/// alignment.
	/// - Parameters:
	///   - sideLength: The length of each side of the square frame.
	///   - alignment: The alignment of the view within its frame. Defaults to `.center`.
	/// - Returns: A modified view with the specified square frame.
	@inlinable
	public func frame(
		_ sideLength: Double,
		alignment: Alignment = .center
	) -> some View {
		self
			.frame(
				width: sideLength,
				height: sideLength,
				alignment: alignment
			)
	}

	/// Sets the view's maximum width and/or height
	/// to fill available space along the specified axes.
	///
	/// Use this method to make a view expand
	/// to the maximum size along the provided axes
	/// while keeping the other dimension unconstrained.
	/// For example, passing `[.horizontal, .vertical]`
	/// makes the view fill all available space both
	/// horizontally and vertically.
	///
	/// - Parameters:
	///   - axis: The axes along which the view should
	///   expand to the maximum size.
	///   Defaults to both horizontal and vertical.
	///   - alignment: The alignment of the view within
	///   its frame. Defaults to `.center`.
	/// - Returns: A view that expands to the maximum
	/// size along the specified axes.
	@inlinable
	public func maxFrame(
		_ axis: Axis.Set = [ .horizontal, .vertical ],
		alignment: Alignment = .center,
	) -> some View {
		frame(
			maxWidth: axis.contains( .horizontal ) ? .infinity : nil,
			maxHeight: axis.contains( .vertical ) ? .infinity : nil,
			alignment: alignment,
		)
	}

	/// Applies padding to the view with separate values for horizontal and
	/// vertical insets.
	/// - Parameters:
	///   - horizontal: The horizontal padding value.
	///   - vertical: The vertical padding value.
	/// - Returns: A view with the specified padding applied.
	@inlinable
	public func padding(
		horizontal: Double,
		vertical: Double
	) -> some View {
		padding(
			.init(
				horizontal: horizontal,
				vertical: vertical
			)
		)
	}
}

public extension View {

	/// Conditionally hides the view based on a Boolean flag.
	///
	/// - Parameter isHidden: A Boolean flag to determine whether the view is hidden.
	///
	/// - Returns: A hidden or visible view based on the `isHidden` flag.
	///
	@ViewBuilder
	func hidden( _ isHidden: Bool ) -> some View {
		if isHidden {
			self.hidden()
		} else {
			self
		}
	}

	/// Wraps the view in an `AnyView`, erasing its type.
	var erasedToAnyView: AnyView {
		AnyView( self )
	}
}

public extension View {

	/// Sets a background view that covers the entire screen, optionally ignoring safe area edges.
	///
	/// - Parameters:
	///   - style: Shape style to fill background.
	///   - safeAreaEdges: The safe area edges to be ignored by the background.
	///
	/// - Returns: A view with the specified background view covering the screen.
	///
	func wholeViewBackground<S: ShapeStyle>(
		_ style: S,
		ignoreSafeAreaEdges safeAreaEdges: Edge.Set = .all
	) -> some View {
		ZStack {
			Rectangle()
				.fill( style )
				.edgesIgnoringSafeArea( safeAreaEdges )
			self
		}
	}

	/// Sets a background view that covers the entire screen, optionally ignoring safe area edges.
	///
	/// - Parameters:
	///   - safeAreaEdges: The safe area edges to be ignored by the background.
	///   - background: The background view to set.
	///
	/// - Returns: A view with the specified background view covering the screen.
	///
	func wholeViewBackground<Background: View>(
		ignoreSafeAreaEdges safeAreaEdges: Edge.Set = .all,
		@ViewBuilder _ background: () -> Background
	) -> some View {
		ZStack {
			background()
				.edgesIgnoringSafeArea( safeAreaEdges )
			self
		}
	}

	/// Sets a background view that covers the entire screen, optionally ignoring safe area edges.
	///
	/// - Parameters:
	///   - background: The background view to set.
	///   - safeAreaEdges: The safe area edges to be ignored by the background.
	///
	/// - Returns: A view with the specified background view covering the screen.
	///
	@available( *, deprecated, message: "Use `wholeViewBackground(ignoreSafeAreaEdges:background:)`.")
	func wholeViewBackground<Background: View>(
		view background: Background,
		ignoreSafeAreaEdges safeAreaEdges: Edge.Set = .all
	) -> some View {
		ZStack {
			background
				.edgesIgnoringSafeArea( safeAreaEdges )
			self
		}
	}
}

public extension View {

	/// Attaches an asynchronous task to the view, triggered when the optional
	/// value changes or becomes non-`nil`. The task runs with the specified
	/// priority and performs the provided action.
	/// - Parameters:
	///   - value: An optional value to monitor. When non-`nil` and changed, the action is executed.
	///   - priority: The priority of the asynchronous task. Defaults to `.userInitiated`.
	///   - action: A closure to execute with the unwrapped value when it changes.
	/// - Returns: A view with the task attached.
	@inlinable
	func task<T>(
		unwrapping value: T?,
		priority: TaskPriority = .userInitiated,
		_ action: sending @escaping @isolated(any) ( T ) async -> Void
	) -> some View where T : Equatable & Sendable {

		self
			.task( id: value, priority: priority ) {
				guard let value else { return }
				await action( value )
			}
	}

	/// Attaches an asynchronous task to the view that runs only when the given
	/// condition is `true`. The task is triggered on initial appearance and when
	/// the condition changes.
	/// - Parameters:
	///   - condition: A Boolean value. When `true`, the action is executed; when
	///     `false`, the action is skipped.
	///   - priority: The priority of the asynchronous task. Defaults to `.userInitiated`.
	///   - action: A closure to execute when the condition is `true`.
	/// - Returns: A view with the task attached.
	@inlinable
	func task(
		if condition: Bool,
		priority: TaskPriority = .userInitiated,
		_ action: sending @escaping @isolated(any) () async -> Void
	) -> some View {
		self
			.task(id: condition, priority: priority) {
				guard condition else { return }
				await action()
			}
	}

	/// Attaches an asynchronous task to the view, triggered when the specified
	/// value changes. The task runs with the specified priority and performs
	/// the provided action.
	/// - Parameters:
	///   - value: A value to monitor for changes. The task is triggered when the value changes.
	///   - priority: The priority of the asynchronous task. Defaults to `.userInitiated`.
	///   - action: A closure to execute with the new value when it changes.
	/// - Returns: A view with the task attached.
	@inlinable
	func task<T>(
		id value: T,
		priority: TaskPriority = .userInitiated,
		_ action: sending @escaping @isolated(any) ( T ) async -> Void
	) -> some View where T : Equatable & Sendable {
		self
			.task( id: value, priority: priority ) {
				await action( value )
			}
	}
}

public extension View {

	/// Applies a modifier to a view based on the presence of a value,
	/// returning a new view only if the value is not `nil`.
	///
	/// Use this method to conditionally apply a ``ViewModifier``
	/// to a ``View`` when the `unwrapped` variable contains a value.
	/// If `unwrapped` is `nil`, the original view is returned unmodified.
	///
	/// For example, you might create a view modifier
	/// that applies a custom style:
	///
	///     struct BorderedCaption: ViewModifier {
	///
	///			let color: Color
	///
	///         func body(content: Content) -> some View {
	///             content
	///                 .font(.caption2)
	///                 .padding(10)
	///                 .overlay(
	///                     RoundedRectangle(cornerRadius: 15)
	///                         .stroke(lineWidth: 1)
	///                 )
	///                 .foregroundColor(Color.blue)
	///         }
	///     }
	///
	/// You can then extend ``View`` to apply the modifier conditionally:
	///
	///     extension View {
	///         func borderedCaption( color: Color? ) -> some View {
	///             self.modifier(unwrapping: unwrapped) {
	///                 BorderedCaption( color: $0 )
	///             }
	///         }
	///     }
	///
	/// If `unwrapped` is not `nil`, the `BorderedCaption` modifier is applied:
	///
	///     Image(systemName: "bus")
	///         .resizable()
	///         .frame(width: 50, height: 50)
	///     Text("Downtown Bus")
	///         .borderedCaption(if: borderColor) // Modifier applied
	///
	/// If `unwrapped` is `nil`, the modifier is not applied,
	/// and the original view is returned as-is:
	///
	/// - parameter unwrapping: The optional value that determines
	///  whether to apply the modifier.
	/// - parameter modifier: The modifier to apply to the view
	///  if `unwrapping` is non-nil.
	@ViewBuilder
	@inlinable nonisolated
	func modifier<Input>(
		unwrapping: Input?,
		modifier: @escaping ( Input ) -> some ViewModifier
	) -> some View {

		if let unwrapping {
			self
				.modifier( modifier( unwrapping ))
		} else {
			self
		}
	}
}
