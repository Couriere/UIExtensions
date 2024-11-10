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
	/// Creates a button that sets the given `flag` to `true` when tapped.
	/// - Parameters:
	///   - flag: A binding to a `Bool` that will be set to `true` when the button is pressed.
	///   - label: A view builder that defines the button's label.
	@MainActor
	public init(
		flag: Binding<Bool>,
		@ViewBuilder label: () -> Label
	) {
		self.init(
			action: { flag.wrappedValue = true },
			label: label
		)
	}
}

extension Button where Label == Text {

	/// Creates a button that generates its label from a string
	/// and sets the given `flag` to `true` when tapped.
	///
	/// This initializer creates a ``Text`` view on your behalf, and treats the
	/// title similar to ``Text/init(_:)-9d1g4``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// To initialize a button with a localized string key, use
	/// ``Button/init(_:action:)-1asy`` instead.
	///
	/// - Parameters:
	///   - title: A string that describes the purpose of the button's `action`.
	///   - flag: A binding to a `Bool` that will be set to `true` when the button is pressed.
	@MainActor
	public init(
		_ title: some StringProtocol,
		flag: Binding<Bool>
	) {
		self.init(
			title,
			action: { flag.wrappedValue = true }
		)
	}

	/// Creates a button with a text label and an action that passes
	/// a specific value.
	/// - Parameters:
	///   - title: The text to display as the button's label.
	///   - value: A value to be passed to the action when
	///    the button is tapped.
	///   - action: A closure executed when the button is pressed,
	///    receiving `value` as its argument.
	@MainActor
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

	/// Creates a button with an image as the label and an action
	/// to perform when the button is tapped.
	/// - Parameters:
	///   - image: The image to display as the button's label.
	///   - action: A closure executed when the button is pressed.
	@MainActor
	public init(
		_ image: Image,
		action: @escaping @MainActor() -> Void
	) {
		self.init(
			action: action,
			label: { image }
		)
	}

	/// Creates a button with an image as the label that sets the
	/// given flag to `true` when tapped.
	/// - Parameters:
	///   - image: The image to display as the button's label.
	///   - flag: A binding to a `Bool` that will be set to `true`
	///     when the button is pressed.
	@MainActor
	public init(
		_ image: Image,
		flag: Binding<Bool>
	) {
		self.init(
			action: { flag.wrappedValue = true },
			label: { image }
		)
	}
}

extension Button {

	/// Creates a button with a custom label and an action that
	/// receives a specific value.
	/// - Parameters:
	///   - value: A value passed to the action when the button is
	///     tapped.
	///   - action: A closure executed when the button is pressed,
	///     receiving `value` as its argument.
	///   - label: A closure that generates the button's label based
	///     on `value`.
	@MainActor
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

	/// Creates a button with a custom label and an action that does
	/// not depend on the value.
	/// - Parameters:
	///   - value: A value passed to the label closure for generating
	///     the button's label.
	///   - action: A closure executed when the button is pressed.
	///   - label: A closure that generates the button's label based
	///     on `value`.
	@MainActor
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

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Button where Label == SwiftUI.Label<Text, Image> {

	/// Creates a button with a text and image label, and performs the
	/// provided action when triggered.
	///
	/// This initializer generates a `Label` view with the given text and
	/// image.
	///
	/// - Parameters:
	///   - title: A string describing the button's purpose.
	///   - image: The image resource to display in the label.
	///   - action: The action to perform when the button is triggered.
	@MainActor
	init(
		_ title: some StringProtocol,
		image: Image,
		action: @escaping @MainActor () -> Void
	) {
		self.init( action: action ) {
			SwiftUI.Label(
				title: { Text( title ) },
				icon: { image }
			)
		}
	}

	/// Creates a button with a text and image label that sets the given
	/// flag to `true` when tapped.
	///
	/// This initializer generates a `Label` view with the given text and
	/// image. The button modifies the `flag` binding when triggered.
	///
	/// - Parameters:
	///   - title: A string describing the button's purpose.
	///   - image: The image resource to display in the label.
	///   - flag: A binding to a `Bool` set to `true` when the button is tapped.
	@MainActor
	init(
		_ title: some StringProtocol,
		image: Image,
		flag: Binding<Bool>
	) {
		self.init {
			flag.wrappedValue = true
		} label: {
			SwiftUI.Label(
				title: { Text( title ) },
				icon: { image }
			)
		}
	}
}
