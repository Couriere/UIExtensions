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

/// A button that performs an asynchronous action and reports its progress.
///
/// While the action runs, the button is disabled and sets
/// ``SwiftUI/EnvironmentValues/isAnimating`` to `true`, so that a button
/// style can show a progress indicator in place of the label. By default,
/// the running action is cancelled when the button disappears; pass `false`
/// as `cancelsOnDisappear` to let it finish instead.
///
/// The button behaves the same way while an enclosing view sets
/// ``SwiftUI/EnvironmentValues/isAnimating`` to `true`, for example
/// while the screen is still loading its data:
///
///     AsyncButton( "Pay", unwrapping: payment, action: pay )
///         .isAnimating( isLoading )
///
///     AsyncButton( "Save" ) {
///         await model.save()
///     }
///
/// Like ``UnwrappingButton``, the button can unwrap an optional value and
/// pass it to the action. The button is disabled while the value is `nil`.
///
///     AsyncButton( "Delete", unwrapping: selection, role: .destructive ) { item in
///         await model.delete( item )
///     }
///
/// Pass a binding as `isExecuting` to observe the progress from outside,
/// or to drive it: while the binding is `true`, the button behaves as if
/// its action were running.
nonisolated public struct AsyncButton<Label, Value> where Label: View, Value: Sendable {

	private let label: Label
	private let unwrapping: Value?
	private let role: ButtonRole?
	private let isExecuting: Binding<Bool>?
	private let cancelsOnDisappear: Bool
	private let action: ( Value ) async -> Void

	@State private var isActionInProgress: Bool = false
	@State private var taskHandler: Task<Void, Never>?

	@Environment( \.isAnimating ) private var isAnimating

	/// Creates a button that unwraps an optional value, passes it to the
	/// asynchronous action, and displays a custom label.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// - Parameters:
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button. Receives the unwrapped value as its argument.
	///   - label: A view that describes the purpose of the button's `action`.
	public init(
		unwrapping: Value?,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping ( Value ) async -> Void,
		@ViewBuilder label: () -> Label,
	) {
		self.label = label()
		self.unwrapping = unwrapping
		self.role = role
		self.isExecuting = isExecuting
		self.cancelsOnDisappear = cancelsOnDisappear
		self.action = action
	}
}

extension AsyncButton where Value == Void {

	/// Creates a button that performs an asynchronous action and displays
	/// a custom label.
	///
	/// - Parameters:
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button.
	///   - label: A view that describes the purpose of the button's `action`.
	@inlinable
	public init(
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping () async -> Void,
		@ViewBuilder label: () -> Label,
	) {
		self.init(
			unwrapping: (),
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: { _ in await action() },
			label: label,
		)
	}
}

extension AsyncButton where Label == Text {

	/// Creates a button that unwraps an optional value, passes it to the
	/// asynchronous action, and generates its label from a localized string key.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// This initializer creates a ``Text`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button's `action`.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button. Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping ( Value ) async -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: action,
			label: { Text( titleKey, tableName: tableName, bundle: bundle ) },
		)
	}

	/// Creates a button that performs an asynchronous action and
	/// generates its label from a localized string key.
	///
	/// This initializer creates a ``Text`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button's `action`.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping () async -> Void,
	) where Value == Void {
		self.init(
			unwrapping: (),
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: { _ in await action() },
			label: { Text( titleKey, tableName: tableName, bundle: bundle ) },
		)
	}

	/// Creates a button that unwraps an optional value, passes it to the
	/// asynchronous action, and generates its label from a string.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// This initializer creates a ``Text`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button. Receives the unwrapped value as its argument.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		unwrapping: Value?,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping ( Value ) async -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: action,
			label: { Text( title ) },
		)
	}

	/// Creates a button that performs an asynchronous action and
	/// generates its label from a string.
	///
	/// This initializer creates a ``Text`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping () async -> Void,
	) where Value == Void {
		self.init(
			unwrapping: (),
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: { _ in await action() },
			label: { Text( title ) },
		)
	}
}

extension AsyncButton where Label == Image {

	/// Creates a button that unwraps an optional value, passes it to the
	/// asynchronous action, and generates its label from an image.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// - Parameters:
	///   - image: The image to use as the button's label.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button. Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ image: Image,
		unwrapping: Value?,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping ( Value ) async -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: action,
			label: { image },
		)
	}

	/// Creates a button that performs an asynchronous action and
	/// generates its label from an image.
	///
	/// - Parameters:
	///   - image: The image to use as the button's label.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button.
	@inlinable
	public init(
		_ image: Image,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping () async -> Void,
	) where Value == Void {
		self.init(
			unwrapping: (),
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: { _ in await action() },
			label: { image },
		)
	}
}

@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
extension AsyncButton where Label == Image {

	/// Creates a button that unwraps an optional value, passes it to the
	/// asynchronous action, and generates its label from an image resource.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// - Parameters:
	///   - resource: The image resource to use as the button's label.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button. Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ resource: ImageResource,
		unwrapping: Value?,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping ( Value ) async -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: action,
			label: { Image( resource ) },
		)
	}

	/// Creates a button that performs an asynchronous action and
	/// generates its label from an image resource.
	///
	/// - Parameters:
	///   - resource: The image resource to use as the button's label.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button.
	@inlinable
	public init(
		_ resource: ImageResource,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping () async -> Void,
	) where Value == Void {
		self.init(
			unwrapping: (),
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: { _ in await action() },
			label: { Image( resource ) },
		)
	}
}

extension AsyncButton where Label == SwiftUI.Label<Text, Image> {

	/// Creates a button that unwraps an optional value, passes it to the
	/// asynchronous action, and generates its label from a localized string key and an image.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button's `action`.
	///   - image: The image to use as the label's icon.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button. Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		image: Image,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping ( Value ) async -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: action,
			label: { SwiftUI.Label { Text( titleKey, tableName: tableName, bundle: bundle ) } icon: { image } },
		)
	}

	/// Creates a button that performs an asynchronous action and
	/// generates its label from a localized string key and an image.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button's `action`.
	///   - image: The image to use as the label's icon.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		image: Image,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping () async -> Void,
	) where Value == Void {
		self.init(
			unwrapping: (),
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: { _ in await action() },
			label: { SwiftUI.Label { Text( titleKey, tableName: tableName, bundle: bundle ) } icon: { image } },
		)
	}

	/// Creates a button that unwraps an optional value, passes it to the
	/// asynchronous action, and generates its label from a string and an image.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - image: The image to use as the label's icon.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button. Receives the unwrapped value as its argument.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		image: Image,
		unwrapping: Value?,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping ( Value ) async -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: action,
			label: { SwiftUI.Label { Text( title ) } icon: { image } },
		)
	}

	/// Creates a button that performs an asynchronous action and
	/// generates its label from a string and an image.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - image: The image to use as the label's icon.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		image: Image,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping () async -> Void,
	) where Value == Void {
		self.init(
			unwrapping: (),
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: { _ in await action() },
			label: { SwiftUI.Label { Text( title ) } icon: { image } },
		)
	}
}

@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
extension AsyncButton where Label == SwiftUI.Label<Text, Image> {

	/// Creates a button that unwraps an optional value, passes it to the
	/// asynchronous action, and generates its label from a localized string key and an image resource.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button's `action`.
	///   - resource: The image resource to use as the label's icon.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button. Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		image resource: ImageResource,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping ( Value ) async -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: action,
			label: { SwiftUI.Label { Text( titleKey, tableName: tableName, bundle: bundle ) } icon: { Image( resource ) } },
		)
	}

	/// Creates a button that performs an asynchronous action and
	/// generates its label from a localized string key and an image resource.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button's `action`.
	///   - resource: The image resource to use as the label's icon.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		image resource: ImageResource,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping () async -> Void,
	) where Value == Void {
		self.init(
			unwrapping: (),
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: { _ in await action() },
			label: { SwiftUI.Label { Text( titleKey, tableName: tableName, bundle: bundle ) } icon: { Image( resource ) } },
		)
	}

	/// Creates a button that unwraps an optional value, passes it to the
	/// asynchronous action, and generates its label from a string and an image resource.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - resource: The image resource to use as the label's icon.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button. Receives the unwrapped value as its argument.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		image resource: ImageResource,
		unwrapping: Value?,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping ( Value ) async -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: action,
			label: { SwiftUI.Label { Text( title ) } icon: { Image( resource ) } },
		)
	}

	/// Creates a button that performs an asynchronous action and
	/// generates its label from a string and an image resource.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - resource: The image resource to use as the label's icon.
	///   - role: An optional semantic role that describes the button.
	///     A value of `nil` means that the button has no assigned role.
	///   - isExecuting: A binding that reflects whether the action is in progress.
	///     While it is `true`, the button behaves as if the action were
	///     running. Pass `nil` to let the button track the progress itself.
	///   - cancelsOnDisappear: A Boolean value that indicates whether the
	///     running action is cancelled when the button disappears.
	///     Cancellation is cooperative: the action stops only at the points
	///     that check for it, such as `Task.sleep` or `URLSession` requests.
	///   - action: The asynchronous action to perform when the user triggers
	///     the button.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		image resource: ImageResource,
		role: ButtonRole? = nil,
		isExecuting: Binding<Bool>? = nil,
		cancelsOnDisappear: Bool = true,
		action: @escaping () async -> Void,
	) where Value == Void {
		self.init(
			unwrapping: (),
			role: role,
			isExecuting: isExecuting,
			cancelsOnDisappear: cancelsOnDisappear,
			action: { _ in await action() },
			label: { SwiftUI.Label { Text( title ) } icon: { Image( resource ) } },
		)
	}
}

// MARK: View

extension AsyncButton: View {

	@MainActor
	public var body: some View {

		let isLoading = isExecuting ?? $isActionInProgress
		let isBusy = isLoading.wrappedValue || isAnimating

		Button( role: role ) {
			guard let unwrapping, !isLoading.wrappedValue else { return }
			withAnimation { isLoading.wrappedValue = true }
			taskHandler = Task {
				await action( unwrapping )
				withAnimation { isLoading.wrappedValue = false }
				taskHandler = nil
			}
		} label: {
			label
		}
		.isAnimating( isBusy )
		.disabled( unwrapping == nil || isBusy )

		.onDisappear {
			guard cancelsOnDisappear else { return }
			taskHandler?.cancel()
		}
	}
}

#Preview {

	struct PreviewContainer: View {

		@State private var text: String = ""

		var body: some View {

			VStack( spacing: 32 ) {

				AsyncButton( "Button" ) {
					try? await Task.sleep( seconds: 2 )
				}

				AsyncButton( "Button", isExecuting: .constant( true )) {
					try? await Task.sleep( seconds: 2 )
				}

				AsyncButton( "Delete", role: .destructive ) {
					try? await Task.sleep( seconds: 2 )
				}

				VStack( spacing: 4 ) {

					TextField( "Enter text", text: $text )

					AsyncButton( unwrapping: text.isNotEmpty ? text : nil ) { _ in
						try? await Task.sleep( seconds: 2 )
						text = ""
					} label: {
						Label( "Unwrapping value", systemImage: "trash" )
					}
				}
			}
			.buttonStyle( .bordered )
			.padding()
		}
	}

	return PreviewContainer()
}
