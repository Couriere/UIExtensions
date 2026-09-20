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

extension Button {

	/// Creates a button that sets the given flag to `true`
	/// when the user triggers it.
	///
	/// - Parameters:
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	///   - label: A view that describes the purpose of the button's action.
	@inlinable
	public nonisolated init(
		flag: Binding<Bool>,
		@ViewBuilder label: () -> Label
	) {
		self.init(
			action: { flag.wrappedValue = true },
			label: label
		)
	}

	/// Creates a button with a custom label and an action that
	/// receives a specific value.
	///
	/// - Parameters:
	///   - value: A value passed to the action when the user triggers
	///     the button.
	///   - action: The action to perform when the user triggers the button.
	///     Receives `value` as its argument.
	///   - label: A view that describes the purpose of the button's action.
	///     Built from `value`.
	@MainActor @inlinable
	public init<Value>(
		_ value: Value,
		action: @escaping @MainActor ( Value ) -> Void,
		label: ( Value ) -> Label
	) {
		self.init {
			action( value )
		} label: {
			label( value )
		}
	}

	/// Creates a button with a custom label built from a value, and an
	/// action that does not depend on that value.
	///
	/// - Parameters:
	///   - value: A value passed to the label closure.
	///   - action: The action to perform when the user triggers the button.
	///   - label: A view that describes the purpose of the button's action.
	///     Built from `value`.
	@MainActor @inlinable
	public init<Value>(
		_ value: Value,
		action: @escaping @MainActor () -> Void,
		label: ( Value ) -> Label
	) {
		self.init( action: action ) {
			label( value )
		}
	}
}

extension Button where Label == Text {

	/// Creates a button that generates its label from a localized string key
	/// and sets the given flag to `true` when the user triggers it.
	///
	/// This initializer creates a ``Text`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable
	public nonisolated init(
		_ titleKey: LocalizedStringKey,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		flag: Binding<Bool>
	) {
		self.init(
			action: { flag.wrappedValue = true },
			label: { Text( titleKey, tableName: tableName, bundle: bundle ) }
		)
	}

	/// Creates a button that generates its label from a string
	/// and sets the given flag to `true` when the user triggers it.
	///
	/// This initializer creates a ``Text`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable @_disfavoredOverload
	public nonisolated init(
		_ title: some StringProtocol,
		flag: Binding<Bool>
	) {
		self.init(
			action: { flag.wrappedValue = true },
			label: { Text( title ) }
		)
	}

	/// Creates a button that generates its label from a localized string key,
	/// and performs an action that receives a specific value.
	///
	/// This initializer creates a ``Text`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button's `action`.
	///   - value: A value passed to the action when the user triggers
	///     the button.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - action: The action to perform when the user triggers the button.
	///     Receives `value` as its argument.
	@MainActor @inlinable
	public init<Value>(
		_ titleKey: LocalizedStringKey,
		_ value: Value,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		action: @escaping @MainActor ( Value ) -> Void
	) {
		self.init {
			action( value )
		} label: {
			Text( titleKey, tableName: tableName, bundle: bundle )
		}
	}

	/// Creates a button that generates its label from a string,
	/// and performs an action that receives a specific value.
	///
	/// This initializer creates a ``Text`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - value: A value passed to the action when the user triggers
	///     the button.
	///   - action: The action to perform when the user triggers the button.
	///     Receives `value` as its argument.
	@MainActor @inlinable @_disfavoredOverload
	public init<Value>(
		_ title: some StringProtocol,
		_ value: Value,
		action: @escaping @MainActor ( Value ) -> Void
	) {
		self.init {
			action( value )
		} label: {
			Text( title )
		}
	}
}

extension Button where Label == Image {

	/// Creates a button that displays an image.
	///
	/// - Parameters:
	///   - image: The image to use as the button's label.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public nonisolated init(
		_ image: Image,
		action: @escaping @MainActor () -> Void
	) {
		self.init(
			action: action,
			label: { image }
		)
	}

	/// Creates a button that displays an image and sets the given flag
	/// to `true` when the user triggers it.
	///
	/// - Parameters:
	///   - image: The image to use as the button's label.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable
	public nonisolated init(
		_ image: Image,
		flag: Binding<Bool>
	) {
		self.init(
			action: { flag.wrappedValue = true },
			label: { image }
		)
	}

	/// Creates a button that displays a system image.
	///
	/// - Parameters:
	///   - systemName: The name of the system symbol image. Use the SF
	///     Symbols app to look up the names of system symbol images.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public nonisolated init(
		systemName: String,
		action: @escaping @MainActor () -> Void
	) {
		self.init(
			action: action,
			label: { Image( systemName: systemName ) }
		)
	}

	/// Creates a button that displays a system image and sets the given
	/// flag to `true` when the user triggers it.
	///
	/// - Parameters:
	///   - systemName: The name of the system symbol image. Use the SF
	///     Symbols app to look up the names of system symbol images.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable
	public nonisolated init(
		systemName: String,
		flag: Binding<Bool>
	) {
		self.init(
			Image( systemName: systemName ),
			flag: flag
		)
	}
}

@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
extension Button where Label == Image {

	/// Creates a button that displays an image resource.
	///
	/// - Parameters:
	///   - resource: The image resource to use as the button's label.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public nonisolated init(
		_ resource: ImageResource,
		action: @escaping @MainActor () -> Void
	) {
		self.init(
			action: action,
			label: { Image( resource ) }
		)
	}

	/// Creates a button that displays an image resource and sets the given
	/// flag to `true` when the user triggers it.
	///
	/// - Parameters:
	///   - resource: The image resource to use as the button's label.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable
	public nonisolated init(
		_ resource: ImageResource,
		flag: Binding<Bool>
	) {
		self.init(
			Image( resource ),
			flag: flag
		)
	}
}

extension Button where Label == ModifiedContent<Image, _PaddingLayout> {

	/// Creates a button that displays an image surrounded by padding.
	///
	/// - Parameters:
	///   - image: The image to use as the button's label.
	///   - padding: The insets to apply around the image.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public nonisolated init(
		_ image: Image,
		padding: EdgeInsets,
		action: @escaping @MainActor () -> Void
	) {
		self.init(
			action: action,
			label: {
				image
					.modifier( _PaddingLayout( insets: padding ))
			}
		)
	}

	/// Creates a button that displays an image surrounded by padding
	/// of equal length on all edges.
	///
	/// - Parameters:
	///   - image: The image to use as the button's label.
	///   - padding: The amount, given in points, to pad the image
	///     on all edges.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public nonisolated init(
		_ image: Image,
		padding: Double,
		action: @escaping @MainActor () -> Void
	) {
		self.init(
			image,
			padding: EdgeInsets( padding ),
			action: action
		)
	}
}

@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
extension Button where Label == ModifiedContent<Image, _PaddingLayout> {

	/// Creates a button that displays an image resource surrounded
	/// by padding.
	///
	/// - Parameters:
	///   - resource: The image resource to use as the button's label.
	///   - padding: The insets to apply around the image.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public nonisolated init(
		_ resource: ImageResource,
		padding: EdgeInsets,
		action: @escaping @MainActor () -> Void
	) {
		self.init(
			Image( resource ),
			padding: padding,
			action: action
		)
	}

	/// Creates a button that displays an image resource surrounded
	/// by padding of equal length on all edges.
	///
	/// - Parameters:
	///   - resource: The image resource to use as the button's label.
	///   - padding: The amount, given in points, to pad the image
	///     on all edges.
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public nonisolated init(
		_ resource: ImageResource,
		padding: Double,
		action: @escaping @MainActor () -> Void
	) {
		self.init(
			Image( resource ),
			padding: padding,
			action: action
		)
	}
}

extension Button where Label == SwiftUI.Label<Text, Image> {

	/// Creates a button that generates its label from a localized string key
	/// and an image.
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
	///   - action: The action to perform when the user triggers the button.
	@inlinable
	public nonisolated init(
		_ titleKey: LocalizedStringKey,
		image: Image,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		action: @escaping @MainActor () -> Void
	) {
		self.init( action: action ) {
			SwiftUI.Label(
				titleKey,
				image: image,
				tableName: tableName,
				bundle: bundle
			)
		}
	}

	/// Creates a button that generates its label from a string and
	/// an image.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - image: The image to use as the label's icon.
	///   - action: The action to perform when the user triggers the button.
	@inlinable @_disfavoredOverload
	public nonisolated init(
		_ title: some StringProtocol,
		image: Image,
		action: @escaping @MainActor () -> Void
	) {
		self.init( action: action ) {
			SwiftUI.Label( title, image: image )
		}
	}

	/// Creates a button that generates its label from a localized string key
	/// and an image, and sets the given flag to `true` when the user
	/// triggers it.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button.
	///   - image: The image to use as the label's icon.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable
	public nonisolated init(
		_ titleKey: LocalizedStringKey,
		image: Image,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		flag: Binding<Bool>
	) {
		self.init(
			titleKey,
			image: image,
			tableName: tableName,
			bundle: bundle
		) {
			flag.wrappedValue = true
		}
	}

	/// Creates a button that generates its label from a string and
	/// an image, and sets the given flag to `true` when the user
	/// triggers it.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button.
	///   - image: The image to use as the label's icon.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable @_disfavoredOverload
	public nonisolated init(
		_ title: some StringProtocol,
		image: Image,
		flag: Binding<Bool>
	) {
		self.init( title, image: image ) {
			flag.wrappedValue = true
		}
	}

	/// Creates a button that generates its label from a localized string key
	/// and a system image name, and sets the given flag to `true` when
	/// the user triggers it.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button.
	///   - systemImage: The name of the image resource to lookup.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable
	public nonisolated init(
		_ titleKey: LocalizedStringKey,
		systemImage: String,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		flag: Binding<Bool>
	) {
		self.init(
			titleKey,
			image: Image( systemName: systemImage ),
			tableName: tableName,
			bundle: bundle,
			flag: flag
		)
	}

	/// Creates a button that generates its label from a string and
	/// a system image name, and sets the given flag to `true` when
	/// the user triggers it.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button.
	///   - systemImage: The name of the image resource to lookup.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable @_disfavoredOverload
	public nonisolated init(
		_ title: some StringProtocol,
		systemImage: String,
		flag: Binding<Bool>
	) {
		self.init(
			title,
			image: Image( systemName: systemImage ),
			flag: flag
		)
	}
}

@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
extension Button where Label == SwiftUI.Label<Text, Image> {

	/// Creates a button that generates its label from a localized string key
	/// and an image resource, and sets the given flag to `true` when the
	/// user triggers it.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
	/// ``Text`` for more information about localizing strings.
	///
	/// - Parameters:
	///   - titleKey: The key for the button's localized title, that describes
	///     the purpose of the button.
	///   - resource: The image resource to lookup.
	///   - tableName: The name of the string table to search. If `nil`,
	///     use the table in the `Localizable.strings` file.
	///   - bundle: The bundle containing the strings file. If `nil`,
	///     use the main bundle.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable
	public nonisolated init(
		_ titleKey: LocalizedStringKey,
		image resource: ImageResource,
		tableName: String? = nil,
		bundle: Bundle? = nil,
		flag: Binding<Bool>
	) {
		self.init(
			titleKey,
			image: Image( resource ),
			tableName: tableName,
			bundle: bundle,
			flag: flag
		)
	}

	/// Creates a button that generates its label from a string and
	/// an image resource, and sets the given flag to `true` when the
	/// user triggers it.
	///
	/// This initializer creates a ``Label`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button.
	///   - resource: The image resource to lookup.
	///   - flag: A binding to a Boolean value that the button sets
	///     to `true` when the user triggers it.
	@inlinable @_disfavoredOverload
	public nonisolated init(
		_ title: some StringProtocol,
		image resource: ImageResource,
		flag: Binding<Bool>
	) {
		self.init(
			title,
			image: Image( resource ),
			flag: flag
		)
	}
}
