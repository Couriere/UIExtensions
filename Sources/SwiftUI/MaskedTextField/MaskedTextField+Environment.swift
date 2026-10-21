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
#if os(macOS)
import AppKit
#endif

#if os(iOS) || os(macOS)

extension EnvironmentValues {

	@Entry var maskedTextFieldMaskFillSymbol: Character? = " "
	@Entry var maskedTextFieldTrailingText: String? = nil
	@Entry var maskedTextFieldHidesMaskWhenEmpty: Bool = false
	@Entry var maskedTextFieldInputDisabled: Bool = false
	// An explicit key avoids @Entry's closure-comparison warning
	// without hiding handler changes.
	var maskedTextFieldOnInputChange: ( ( String, Range<String.Index>, String ) -> MaskedTextField.InputChange )? {
		get { self[MaskedTextFieldInputChangeKey.self] }
		set { self[MaskedTextFieldInputChangeKey.self] = newValue }
	}

	// The placeholder and unfilled mask color inherited by masked
	// text fields.
	#if os(iOS)
	@Entry var maskedTextFieldPlaceholderColor: Color = .init( uiColor: .placeholderText )
	#else
	@Entry var maskedTextFieldPlaceholderColor: Color = .init( nsColor: .placeholderTextColor )
	#endif
}

private struct MaskedTextFieldInputChangeKey: EnvironmentKey {
	static var defaultValue: ( ( String, Range<String.Index>, String ) -> MaskedTextField.InputChange )? { nil }
}

extension View {

	/// Lets an application accept, transform, or reject user edits
	/// before normal input processing.
	///
	/// The handler receives the previous displayed text without the
	/// fixed mask prefix, a replacement range in that string, and the
	/// inserted fragment (empty for deletion). The range uses
	/// `String.Index`, not UTF-16 offsets. Typing, paste, and
	/// autofill call the handler; programmatic binding updates do
	/// not. Disabled input does not call it either.
	///
	/// Return `.accept` to keep the edit, `.accept(replacement:)` to
	/// transform the inserted fragment, `.reject` to cancel, or
	/// `.replaceAll` to replace the entire value. Accepted edits
	/// still pass through the mode's character filtering and length
	/// limits.
	///
	/// ```swift
	/// MaskedTextField(
	///     text: $code,
	///     mode: .masked( "@@ ####" )
	/// )
	///     .maskedTextFieldOnInputChange {
	///         _, _, replacement in
	///         .accept(
	///             replacement: replacement.uppercased()
	///         )
	///     }
	/// ```
	///
	/// Applies to every descendant masked text field. The nearest
	/// handler replaces an inherited handler; handlers are not
	/// combined. Pass nil to clear one.
	///
	/// The original edit is inferred from matching text prefixes and
	/// suffixes. Repeated characters can make its range ambiguous;
	/// the handler cannot identify whether an edit came from typing,
	/// paste, or autofill.
	public func maskedTextFieldOnInputChange(
		_ action: ( ( String, Range<String.Index>, String ) -> MaskedTextField.InputChange )?,
	) -> some View {
		environment(
			\.maskedTextFieldOnInputChange,
			action,
		)
	}

	/// Sets the character displayed in unfilled mask positions.
	///
	/// Defaults to a space. Pass nil to hide the unfilled remainder;
	/// the fixed prefix remains visible. This changes the hint only,
	/// not accepted input or the binding. Applies to descendant
	/// masked text fields; the nearest setting takes precedence.
	public func maskedTextFieldMaskFillSymbol( _ value: Character? ) -> some View {
		environment(
			\.maskedTextFieldMaskFillSymbol,
			value,
		)
	}

	/// Displays a suffix, such as `" kg"`, after the field's
	/// formatted value or placeholder.
	///
	/// Include any desired leading space. The suffix is visual
	/// decoration: it is not editable, stored in the binding, or
	/// announced by VoiceOver. Pass nil to remove it. It is hidden
	/// along with the mask when
	/// `.maskedTextFieldHidesMaskWhenEmpty()` applies. Applies to
	/// descendant masked text fields; the nearest setting takes
	/// precedence.
	public func maskedTextFieldTrailingText( _ value: String? ) -> some View {
		environment(
			\.maskedTextFieldTrailingText,
			value,
		)
	}

	/// Hides the fixed mask prefix, unfilled remainder, and suffix
	/// while the field is empty and unfocused.
	///
	/// Decorations reappear when the field gains focus or its value
	/// becomes nonempty. The placeholder remains visible. Defaults to
	/// false; pass false to keep decorations visible. Applies to
	/// descendant masked text fields; the nearest setting takes
	/// precedence.
	public func maskedTextFieldHidesMaskWhenEmpty( _ value: Bool = true ) -> some View {
		environment(
			\.maskedTextFieldHidesMaskWhenEmpty,
			value,
		)
	}

	/// Prevents user edits while allowing the field to receive focus
	/// and select or copy text.
	///
	/// The field keeps its normal appearance. Programmatic binding
	/// updates still work. Input is enabled by default; call without
	/// an argument to disable it, or pass false to enable it,
	/// including when an ancestor disables input with this modifier.
	/// Applies to descendant masked text fields; the nearest setting
	/// takes precedence.
	public func maskedTextFieldInputDisabled( _ disabled: Bool = true ) -> some View {
		environment(
			\.maskedTextFieldInputDisabled,
			disabled,
		)
	}

	/// Sets the color of the placeholder and unfilled mask remainder.
	///
	/// Defaults to the platform's placeholder text color. The entered
	/// text, fixed prefix, and suffix keep their own foreground
	/// style. Applies to descendant masked text fields; the nearest
	/// setting takes precedence.
	public func maskedTextFieldPlaceholderColor( _ color: Color ) -> some View {
		environment(
			\.maskedTextFieldPlaceholderColor,
			color,
		)
	}
}
#endif
