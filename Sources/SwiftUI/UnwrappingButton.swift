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

nonisolated public struct UnwrappingButton<Label, Value> where Label: View, Value: Sendable {

	let unwrapping: Value?
	let action: @MainActor ( Value ) -> Void
	let label: Label

	/// Creates a button that unwraps an optional value, passes it to the
	/// action, and displays a custom label.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// - Parameters:
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	///   - label: A view that describes the purpose of the button's `action`.
	public init(
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
		@ViewBuilder label: () -> Label,
	) {
		self.label = label()
		self.unwrapping = unwrapping
		self.action = action
	}
}

extension UnwrappingButton where Label == Text {

	/// Creates a button that unwraps an optional value and generates its
	/// label from a localized string key.
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
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: action,
			label: { Text( titleKey, tableName: tableName, bundle: bundle ) },
		)
	}

	/// Creates a button that unwraps an optional value and generates its
	/// label from a string.
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
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: action,
			label: { Text( title ) },
		)
	}

	/// Creates a button that unwraps an optional value and generates its
	/// label from a localized string key.
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
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		action: @escaping @MainActor () -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: { _ in action() },
			label: { Text( titleKey, tableName: tableName, bundle: bundle ) },
		)
	}

	/// Creates a button that unwraps an optional value and generates its
	/// label from a string.
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
	///   - action: The action to perform when the user triggers the button.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		unwrapping: Value?,
		action: @escaping @MainActor () -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: { _ in action() },
			label: { Text( title ) },
		)
	}
}

extension UnwrappingButton where Label == Image {

	/// Creates a button that unwraps an optional value and displays
	/// an image.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// - Parameters:
	///   - image: The image to use as the button's label.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ image: Image,
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: action,
			label: { image },
		)
	}


	/// Creates a button that unwraps an optional value and displays
	/// an image.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// - Parameters:
	///   - image: The image to use as the button's label.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public init(
		_ image: Image,
		unwrapping: Value?,
		action: @escaping @MainActor () -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: { _ in action() },
			label: { image },
		)
	}
}

extension UnwrappingButton where Label == SwiftUI.Label<Text, Image> {

	/// Creates a button that unwraps an optional value and generates its
	/// label from a localized string key and an image.
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
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		image: Image,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: action,
			label: { Label( titleKey, image: image, tableName: tableName, bundle: bundle ) },
		)
	}


	/// Creates a button that unwraps an optional value and generates its
	/// label from a string and an image.
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
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		image: Image,
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: action,
			label: { Label( title, image: image ) },
		)
	}


	/// Creates a button that unwraps an optional value and generates its
	/// label from a localized string key and an image.
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
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		image: Image,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		action: @escaping @MainActor () -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: { _ in action() },
			label: { Label( titleKey, image: image, tableName: tableName, bundle: bundle ) },
		)
	}


	/// Creates a button that unwraps an optional value and generates its
	/// label from a string and an image.
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
	///   - action: The action to perform when the user triggers the button.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		image: Image,
		unwrapping: Value?,
		action: @escaping @MainActor () -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: { _ in action() },
			label: { Label( title, image: image ) },
		)
	}


	/// Creates a button that unwraps an optional value and generates its
	/// label from a localized string key and a system image name.
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
	///   - systemImage: The name of the image resource to lookup.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		systemImage: String,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: action,
			label: { Label( title: { Text( titleKey, tableName: tableName, bundle: bundle ) }, icon: { Image( systemName: systemImage ) } ) },
		)
	}


	/// Creates a button that unwraps an optional value and generates its
	/// label from a string and a system image name.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - systemImage: The name of the image resource to lookup.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		systemImage: String,
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: action,
			label: { Label( title, systemImage: systemImage ) },
		)
	}


	/// Creates a button that unwraps an optional value and generates its
	/// label from a localized string key and a system image name.
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
	///   - systemImage: The name of the image resource to lookup.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		systemImage: String,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		action: @escaping @MainActor () -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: { _ in action() },
			label: { Label( title: { Text( titleKey, tableName: tableName, bundle: bundle ) }, icon: { Image( systemName: systemImage ) } ) },
		)
	}


	/// Creates a button that unwraps an optional value and generates its
	/// label from a string and a system image name.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - systemImage: The name of the image resource to lookup.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		systemImage: String,
		unwrapping: Value?,
		action: @escaping @MainActor () -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: { _ in action() },
			label: { Label( title, systemImage: systemImage ) },
		)
	}
}

@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
extension UnwrappingButton where Label == Image {

	/// Creates a button that unwraps an optional value and displays
	/// an image resource.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// - Parameters:
	///   - resource: The image resource to use as the button's label.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ resource: ImageResource,
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
	) {
		self.init(
			Image( resource ),
			unwrapping: unwrapping,
			action: action,
		)
	}


	/// Creates a button that unwraps an optional value and displays
	/// an image resource.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// - Parameters:
	///   - resource: The image resource to use as the button's label.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public init(
		_ resource: ImageResource,
		unwrapping: Value?,
		action: @escaping @MainActor () -> Void,
	) {
		self.init(
			Image( resource ),
			unwrapping: unwrapping,
			action: action,
		)
	}
}

@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
extension UnwrappingButton where Label == SwiftUI.Label<Text, Image> {

	/// Creates a button that unwraps an optional value and generates its
	/// label from a localized string key and an image resource.
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
	///   - resource: The image resource to lookup.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		image resource: ImageResource,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: action,
			label: { Label( titleKey, image: Image( resource ), tableName: tableName, bundle: bundle ) },
		)
	}


	/// Creates a button that unwraps an optional value and generates its
	/// label from a string and an image resource.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - resource: The image resource to lookup.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	///     Receives the unwrapped value as its argument.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		image resource: ImageResource,
		unwrapping: Value?,
		action: @escaping @MainActor ( Value ) -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: action,
			label: { Label( title, image: Image( resource )) },
		)
	}


	/// Creates a button that unwraps an optional value and generates its
	/// label from a localized string key and an image resource.
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
	///   - resource: The image resource to lookup.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public init(
		_ titleKey: LocalizedStringKey,
		image resource: ImageResource,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		unwrapping: Value?,
		action: @escaping @MainActor () -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: { _ in action() },
			label: { Label( titleKey, image: Image( resource ), tableName: tableName, bundle: bundle ) },
		)
	}


	/// Creates a button that unwraps an optional value and generates its
	/// label from a string and an image resource.
	///
	/// The button is disabled while `unwrapping` is `nil`.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - resource: The image resource to lookup.
	///   - unwrapping: An optional value that the button passes to
	///     the action. The button is disabled while the value is `nil`.
	///   - action: The action to perform when the user triggers the button.
	@inlinable @_disfavoredOverload
	public init(
		_ title: some StringProtocol,
		image resource: ImageResource,
		unwrapping: Value?,
		action: @escaping @MainActor () -> Void,
	) {
		self.init(
			unwrapping: unwrapping,
			action: { _ in action() },
			label: { Label( title, image: Image( resource )) },
		)
	}
}

// MARK: View

extension UnwrappingButton: View {

	public var body: some View {

		let unwrapping = unwrapping
		let action = action

		Button {
			guard let unwrapping else { return }
			action( unwrapping )
		} label: {
			label
		}
		.disabled( unwrapping == nil )
	}
}
