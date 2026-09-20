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

	/// Sets the view's maximum width to fill all available horizontal space,
	/// keeping its height unconstrained.
	///
	/// - Important: Unlike the standard SwiftUI `frame(maxWidth:alignment:)`,
	/// the `alignment` parameter defaults to **`.leading`**, not `.center`,
	/// because leading alignment is by far the most common case
	/// when expanding a view horizontally.
	/// Pass the alignment explicitly if you need a different one.
	///
	/// - Parameter alignment: The alignment of the view within
	/// its frame. Defaults to `.leading`.
	/// - Returns: A view that expands to the maximum available width.
	@inlinable
	public func maxWidth(
		alignment: Alignment = .leading,
	) -> some View {
		frame(
			maxWidth: .infinity,
			alignment: alignment,
		)
	}

	/// Sets the view's maximum height to fill all available vertical space,
	/// keeping its width unconstrained.
	///
	/// - Parameter alignment: The alignment of the view within
	/// its frame. Defaults to `.center`.
	/// - Returns: A view that expands to the maximum available height.
	@inlinable
	public func maxHeight(
		alignment: Alignment = .center,
	) -> some View {
		frame(
			maxHeight: .infinity,
			alignment: alignment,
		)
	}

	/// Fixes the view at its ideal width, while letting its height
	/// be flexible.
	///
	/// This is a shorthand for `fixedSize( horizontal: true, vertical: false )`.
	/// Use it, for example, to stop a `Text` from being compressed
	/// horizontally by its container.
	///
	/// - Returns: A view that keeps its ideal width.
	@inlinable
	public func fixedHorizontalSize() -> some View {
		fixedSize(
			horizontal: true,
			vertical: false
		)
	}

	/// Fixes the view at its ideal height, while letting its width
	/// be flexible.
	///
	/// This is a shorthand for `fixedSize( horizontal: false, vertical: true )`.
	/// Use it, for example, to let a multiline `Text` grow vertically
	/// instead of being truncated.
	///
	/// - Returns: A view that keeps its ideal height.
	@inlinable
	public func fixedVerticalSize() -> some View {
		fixedSize(
			horizontal: false,
			vertical: true
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

// MARK: - Change Observation

extension View {

	/// Writes the new value into a binding whenever the observed value changes.
	///
	/// Use this modifier to mirror a value that is not a binding itself,
	/// such as an environment value, into state owned by another view.
	///
	///     .onChange( of: scenePhase, update: $lastKnownPhase )
	///
	/// - Parameters:
	///   - value: The value to observe.
	///   - initial: Whether the binding is updated when the view first appears.
	///   - binding: The binding that receives the new value.
	/// - Returns: A view that keeps the binding in sync with the observed value.
	@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
	@inlinable
	public nonisolated func onChange<V>(
		of value: V,
		initial: Bool = false,
		update binding: Binding<V>,
	) -> some View where V: Equatable {
		onChange( of: value, initial: initial ) { _, newValue in
			binding.wrappedValue = newValue
		}
	}

	/// Adds an action to perform when either of two observed values changes.
	///
	/// The standard `onChange( of:_: )` tracks a single value. This modifier
	/// combines two values into one trigger, so the action runs once when
	/// either value changes, and once — not twice — when both change together.
	///
	///     .onChange( of: selectedTab, or: searchText ) { tab, text in
	///         reload( tab: tab, query: text )
	///     }
	///
	/// - Parameters:
	///   - first: The first value to observe.
	///   - second: The second value to observe.
	///   - action: The action to perform, receiving the current values of
	///     `first` and `second`.
	/// - Returns: A view that performs the action when either value changes.
	@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
	@inlinable
	public func onChange<T, V>(
		of first: T,
		or second: V,
		perform action: @escaping ( T, V ) -> Void,
	) -> some View where T: Equatable, V: Equatable {

		onChange( of: _Trigger( first: first, second: second )) { _, trigger in
			action( trigger.first, trigger.second )
		}
	}

	/// Adds an asynchronous action to perform when either of two observed
	/// values changes.
	///
	/// The asynchronous counterpart of ``onChange(of:or:perform:)``. Both
	/// values are combined into one trigger, so the action runs once even
	/// when `first` and `second` change together.
	///
	///     .onChange( of: selectedTab, or: searchText, initial: true ) { tab, text in
	///         await reload( tab: tab, query: text )
	///     }
	///
	/// - Parameters:
	///   - first: The first value to observe.
	///   - second: The second value to observe.
	///   - initial: Whether the action runs when the view first appears,
	///     before either value has changed.
	///   - action: The asynchronous action to perform, receiving the current
	///     values of `first` and `second`.
	/// - Returns: A view that performs the action when either value changes.
	@inlinable
	public func onChange<T, V>(
		of first: T,
		or second: V,
		initial: Bool = false,
		perform action: @escaping ( T, V ) async -> Void,
	) -> some View where T: Equatable & Sendable, V: Equatable & Sendable {

		onChange(
			of: _Trigger( first: first, second: second ),
			initial: initial
		) { _, trigger in
			await action( trigger.first, trigger.second )
		}
	}

	/// Adds a task to perform before this view appears, and restarts it
	/// whenever either of two identifiers changes.
	///
	/// The standard `task( id:priority:_: )` restarts on a single identifier.
	/// This modifier combines two of them into one trigger, so the task is
	/// cancelled and restarted once when either changes, and once — not
	/// twice — when both change together.
	///
	///     .task( id: selectedTab, or: searchText ) {
	///         await loadData()
	///     }
	///
	/// - Parameters:
	///   - first: The first identifier. The task restarts when it changes.
	///   - second: The second identifier. The task restarts when it changes.
	///   - priority: The priority of the task.
	///   - action: The asynchronous action to perform.
	/// - Returns: A view that runs the task for the lifetime of the given
	///   identifiers.
	// NOTE: The action stays `@escaping @Sendable` on purpose. Rewriting it as
	// `sending @escaping @isolated(any)` requires function type metadata that is
	// not back-deployed and crashes at runtime on systems older than iOS 18.
	// Revisit once the minimum deployment target reaches iOS 18.
	@inlinable
	public func task<T, V>(
		id first: T,
		or second: V,
		priority: TaskPriority = .userInitiated,
		_ action: @escaping @Sendable () async -> Void,
	) -> some View where T: Equatable, V: Equatable {

		task(
			id: _Trigger( first: first, second: second ),
			priority: priority,
			action
		)
	}

	/// Writes the new value into a binding whenever the given preference
	/// key changes.
	///
	/// - Parameters:
	///   - key: The preference key to observe.
	///   - binding: The binding that receives the new value.
	/// - Returns: A view that keeps the binding in sync with the preference.
	@available( iOS 18, macOS 15, tvOS 18, watchOS 11, * )
	@inlinable
	public func onPreferenceChange<Key>(
		_ key: Key.Type,
		update binding: Binding<Key.Value>,
	) -> some View where Key: PreferenceKey, Key.Value: Equatable & Sendable {
		onPreferenceChange( key ) {
			binding.wrappedValue = $0
		}
	}
}

/// A pair of values combined into a single equatable trigger.
@usableFromInline
struct _Trigger<First, Second>: Equatable where First: Equatable, Second: Equatable {

	@usableFromInline
	let first: First

	@usableFromInline
	let second: Second

	@usableFromInline
	init( first: First, second: Second ) {
		self.first = first
		self.second = second
	}
}

// MARK: Sendable

extension _Trigger: Sendable where First: Sendable, Second: Sendable {}

// MARK: - Styling

extension View {

	/// Removes the background style set for this view's hierarchy.
	///
	/// Views such as `Label` and `Slider` draw their background using
	/// the inherited background style. Clear it to let them fall back
	/// to their default appearance.
	@available( iOS 16, macOS 13, tvOS 16, watchOS 9, * )
	@inlinable
	public func clearBackgroundStyle() -> some View {
		environment( \.backgroundStyle, nil )
	}

	/// Applies the given transform if the given condition evaluates to `true`.
	///
	/// - Parameters:
	///   - condition: The condition to evaluate.
	///   - transform: The transform to apply to the source view.
	/// - Returns: Either the original view, or the modified view
	///   when the condition is `true`.
	@ViewBuilder
	public func `if`(
		_ condition: @autoclosure () -> Bool,
		transform: ( Self ) -> some View,
	) -> some View {
		if condition() {
			transform( self )
		} else {
			self
		}
	}
}
