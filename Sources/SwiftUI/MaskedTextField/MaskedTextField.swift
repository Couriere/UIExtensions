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

#if os(iOS) || os(macOS)

/// A text field that formats input while keeping the editable value
/// in a string binding.
///
/// Choose `.plain` for unformatted text, `.masked(pattern)` for
/// values such as phone numbers and dates, or `.groupedInteger` for
/// nonnegative whole numbers. Mask separators and number-grouping
/// spaces appear in the field but are not stored in the binding. See
/// ``InputMode`` for each mode's value format.
///
/// ```swift
/// MaskedTextField(
///     "Phone",
///     text: $phone,
///     mode: .masked( "+998 ## ### ## ##" )
/// )
/// MaskedTextField(
///     "Amount",
///     text: $amount,
///     mode: .groupedInteger( characterLimit: 16 )
/// )
/// ```
///
/// Configure appearance and editing with the `maskedTextField…` view
/// modifiers. A modifier on a container applies to every masked text
/// field inside it; a modifier closer to a field overrides the
/// inherited setting.
///
/// On iOS, digit-only masks and `.groupedInteger` use the number pad
/// and disable autocorrection. Other modes use the standard text
/// field keyboard behavior.
public struct MaskedTextField {

	/// The format of a field's displayed text and the value stored in
	/// its binding.
	///
	/// For modes with a character limit, nil allows any length. Zero
	/// or a negative limit permits only an empty value. An edit
	/// exceeding the limit is rejected as a whole, preserving the
	/// previous value.
	public enum InputMode: Equatable {
		/// Text without automatic formatting. The binding stores the
		/// entered text. `characterLimit` counts Swift characters,
		/// including spaces.
		case plain( characterLimit: Int? )

		/// Text formatted with a pattern, such as `"+1 ## ### ## ##"`
		/// for a phone number.
		///
		/// Each `#` accepts an ASCII digit, `@` a letter, and `*` a
		/// letter or digit. Other characters are fixed separators.
		/// Characters before the first token form a prefix that the
		/// user cannot edit. Separators after the prefix must not be
		/// characters accepted by the pattern's tokens.
		///
		/// The binding stores only characters entered into token
		/// positions: for example, `"931234567"` is displayed as `"+1
		/// 93 123 45 67"`. The number of tokens determines capacity.
		/// A pattern without tokens behaves like `.plain`.
		case masked( String )

		/// A nonnegative whole number displayed with spaces between
		/// groups of three digits.
		///
		/// The binding stores ASCII digits only: `"1234567"` is
		/// displayed as `"1 234 567"`. Leading zeros are removed,
		/// while an empty value and a single `"0"` are preserved.
		/// Signs and decimal separators are not supported. Values
		/// remain strings, so their size is not restricted to the
		/// range of an integer type. `characterLimit` counts digits
		/// after leading zeros are removed; grouping spaces do not
		/// count.
		case groupedInteger( characterLimit: Int? )

		/// Unformatted text without a length limit.
		public static var plain: Self {
			.plain( characterLimit: nil )
		}

		/// A grouped nonnegative whole number without a digit limit.
		public static var groupedInteger: Self {
			.groupedInteger( characterLimit: nil )
		}
	}

	/// How to handle a user edit received by
	/// `.maskedTextFieldOnInputChange(_:)`.
	public enum InputChange {
		/// Applies the edit using the field's normal character
		/// filtering and length limits.
		///
		/// Pass nil, or use `.accept`, to keep the original inserted
		/// fragment. Pass a string to transform only that fragment,
		/// for example `.accept(replacement:
		/// replacement.uppercased())`. An empty string removes the
		/// fragment. Formatting adjusts the caret to follow the
		/// accepted characters.
		case accept( replacement: String? = nil )

		/// Discards the edit and restores the previous text and caret
		/// position.
		case reject

		/// Replaces the entire editable value and moves the caret to
		/// its end.
		///
		/// Provide a value without mask separators or the fixed
		/// prefix. The edit is rejected if the value contains
		/// characters the mode cannot accept or exceeds its capacity.
		/// In `.groupedInteger`, leading zeros are removed first.
		case replaceAll( String )

		/// Applies the original edit using the field's normal
		/// filtering and length limits.
		public static var accept: Self {
			.accept( replacement: nil )
		}
	}

	private let prompt: String?
	@Binding private var text: String
	private let inputMode: InputMode

	@Environment( \.maskedTextFieldMaskFillSymbol ) private var maskFillSymbol
	@Environment( \.maskedTextFieldPlaceholderColor ) private var placeholderColor
	@Environment( \.maskedTextFieldTrailingText ) private var trailingText
	@Environment( \.maskedTextFieldHidesMaskWhenEmpty ) private var hidesMaskWhenEmpty
	@Environment( \.maskedTextFieldInputDisabled ) private var isInputDisabled
	@Environment( \.maskedTextFieldOnInputChange ) private var inputChange

	@FocusState private var isFocused: Bool
	@State private var selection: TextSelection?
	// Separate display state restores rejected edits even when the
	// binding is unchanged.
	@State private var displayedText: String = ""
	// Compare values rather than flags so coalesced user edits are
	// not discarded.
	@State private var appliedText: String?
	// Selection before an edit disambiguates deletion among identical
	// characters.
	@State private var caretOffset: Int?
	// The display value to which the stored caret belongs.
	@State private var caretText: String = ""

	/// Creates a field with an optional placeholder and the requested
	/// input format.
	///
	/// - Parameters:
	///   - prompt: Placeholder shown when the editable
	///     value is empty.
	///   - text: The editable value. For masked input,
	///     provide characters without separators or the fixed prefix;
	///     for grouped integers, provide digits only. Programmatic
	///     updates refresh the display without calling the input
	///     handler.
	///   - mode: How characters are accepted, displayed,
	///     and stored. Defaults to `.plain`.
	public init(
		_ prompt: String? = nil,
		text: Binding<String>,
		mode: InputMode = .plain,
	) {
		self.prompt = prompt
		self._text = text
		self.inputMode = mode
	}

	/// Creates a text field that formats its value with a mask.
	///
	/// The field inserts fixed separators as the user types.
	/// The binding stores only characters entered into token
	/// positions, without separators or a fixed prefix. For example,
	/// `"4155550123"` appears as `"+1 (415) 555-0123"` with this
	/// mask:
	///
	/// ```swift
	/// MaskedTextField(
	///     "Phone",
	///     text: $phone,
	///     mask: "+1 (###) ###-####",
	/// )
	/// ```
	///
	/// The number of input tokens determines the field's capacity.
	/// A pattern without input tokens uses plain text input instead.
	/// On iOS, digit-only masks use the number pad and disable
	/// autocorrection.
	///
	/// This initializer is equivalent to passing `.masked(mask)` to
	/// ``init(_:text:mode:)``.
	///
	/// - Parameters:
	///   - prompt: The placeholder shown when the editable value is
	///     empty. Defaults to nil, which shows no placeholder.
	///   - text: A binding to the editable characters, without the
	///     mask's separators or fixed prefix. Programmatic updates
	///     refresh the display without calling the input handler.
	///   - mask: A pattern in which `#` accepts an ASCII digit, `@`
	///     accepts a letter, and `*` accepts a letter or digit. Other
	///     characters are fixed separators. Characters before the
	///     first token form a prefix that the user cannot edit.
	public init(
		_ prompt: String? = nil,
		text: Binding<String>,
		mask: String,
	) {
		self.init(
			prompt,
			text: text,
			mode: .masked( mask ),
		)
	}
}

extension MaskedTextField: View {

	public var body: some View {

		HStack( spacing: 0 ) {

			if let maskPrefix = mask?.prefix, maskPrefix.isNotEmpty {
				Text( verbatim: maskPrefix )
					.opacity( isMaskVisible ? 1 : 0 )
			}

			ZStack( alignment: .leading ) {

				hint

				field
			}
		}
		.animation(
			.default,
			value: isMaskVisible,
		)

		.onAppear {
			setDisplayedText( formattedText )
		}
		.onChange( of: displayedText ) { previousText, editedText in
			let ownEdit = appliedText
			appliedText = nil
			guard editedText != ownEdit else { return }
			apply(
				edit: editedText,
				previousText: previousText,
			)
		}
		.onChange( of: selection ) {
			guard displayedText == caretText else { return }
			caretOffset = caretOffset(
				of: selection,
				in: displayedText,
			)
		}
		.onChange( of: text ) {
			let updatedText = formattedText
			guard updatedText != displayedText else { return }
			setDisplayedText( updatedText )
			selection = nil
		}
	}
}

@MainActor
private extension MaskedTextField {

	@ViewBuilder
	var field: some View {

		let textField = TextField(
			"",
			text: $displayedText,
			selection: $selection,
			prompt: prompt.map {
				Text( verbatim: $0 )
					.foregroundStyle( placeholderColor )
			},
		)
		.textFieldStyle( .plain )
		.focused( $isFocused )

		#if os(iOS)
		if mask?.isNumeric == true || isNumberInput {
			textField
				.keyboardType( .numberPad )
				.autocorrectionDisabled()
		} else {
			textField
		}
		#else
		textField
		#endif
	}

	@ViewBuilder
	var hint: some View {

		if isMaskVisible, let hintText {
			hintText
				.lineLimit( 1 )
				.allowsHitTesting( false )
				.accessibilityHidden( true )
		}
	}

	var hintText: Text? {

		guard maskFillSymbol != nil || trailingText != nil else { return nil }

		let filledText = formattedText
		let promptText = filledText.isEmpty ? prompt : nil

		var result = Text( verbatim: promptText ?? filledText ).foregroundStyle( .clear )

		if promptText == nil, let mask, let maskFillSymbol {
			let remainder = mask.remainder(
				after: filledText.count,
				fillSymbol: maskFillSymbol,
			)
			result = result + Text( verbatim: remainder ).foregroundStyle( placeholderColor )
		}

		if let trailingText {
			result = result + Text( verbatim: trailingText )
		}

		return result
	}

	var isMaskVisible: Bool {
		!hidesMaskWhenEmpty || isFocused || text.isNotEmpty
	}
}

private extension MaskedTextField {

	var mask: Mask? {
		guard case .masked( let pattern ) = inputMode else { return nil }
		return Mask( pattern: pattern )
	}

	var isNumberInput: Bool {
		guard case .groupedInteger = inputMode else { return false }
		return true
	}

	var characterLimit: Int? {
		switch inputMode {
		case .plain( let limit ), .groupedInteger( let limit ): return limit
		case .masked: return nil
		}
	}

	var formattedText: String {

		guard let mask else {

			var characters = significantCharacters( in: text )

			if isNumberInput {

				characters = Self.normalizedNumber( characters )

				if let characterLimit {
					characters = characters.prefix(
						max( characterLimit, 0 ),
					).string
				}
			}

			return format( characters )
		}

		return mask.format(
			mask.significantCharacters( in: text ),
		)
	}

	func apply(
		edit editedText: String,
		previousText: String,
	) {

		var editedText = editedText
		var transformedCaretOffset: Int?

		let caretBeforeEdit = caretOffsetBeforeEdit(
			from: previousText,
			to: editedText,
		)

		guard !isInputDisabled else {
			return revertEdit(
				to: previousText,
				caretOffset: caretBeforeEdit,
			)
		}

		if let inputChange {

			let edit = Self.inputEdit(
				from: previousText,
				to: editedText,
			)

			switch inputChange( previousText, edit.range, edit.replacement ) {
			case .accept( let replacement ):
				if let replacement, replacement != edit.replacement {
					transformedCaretOffset = previousText.distance(
						from: previousText.startIndex,
						to: edit.range.lowerBound,
					) + replacement.count
					editedText = previousText.replacingCharacters(
						in: edit.range,
						with: replacement,
					)
				}

			case .reject:
				return revertEdit(
					to: previousText,
					caretOffset: caretBeforeEdit,
				)

			case .replaceAll( let value ):
				let normalized = isNumberInput ? Self.normalizedNumber( value ) : value
				guard !overflows( normalized ), significantCharacters( in: normalized ) == normalized else {
					return revertEdit(
						to: previousText,
						caretOffset: caretBeforeEdit,
					)
				}
				let updatedText = format( normalized )
				text = normalized
				setDisplayedText( updatedText )
				setCaret(
					afterSignificantCount: normalized.count,
					in: updatedText,
				)
				return
			}
		}

		// Reject overflow rather than truncating an existing suffix
		// the user did not delete.
		guard !overflows( editedText ) else {
			return revertEdit(
				to: previousText,
				caretOffset: caretBeforeEdit,
			)
		}

		let caretAfterEdit = transformedCaretOffset ?? caretOffset(
			of: selection,
			in: editedText,
		) ?? min(
			max( caretBeforeEdit + editedText.count - previousText.count, 0 ),
			editedText.count,
		)

		var significantCount = significantCharacters(
			in: String( editedText.prefix( caretAfterEdit )),
		).count

		var characters = significantCharacters( in: editedText )

		// Deleting a separator removes the adjacent significant
		// character instead.
		if mask != nil || isNumberInput,
		   editedText.count < previousText.count,
		   significantCount > 0,
		   characters == significantCharacters( in: previousText ) {

			let isBackwardDeletion = caretAfterEdit < caretBeforeEdit

			if isBackwardDeletion {
				significantCount -= 1
			}

			characters.remove(
				at: characters.index(
					characters.startIndex,
					offsetBy: significantCount,
				),
			)
		}

		if isNumberInput {

			let normalized = Self.normalizedNumber( characters )

			significantCount = max(
				significantCount - ( characters.count - normalized.count ),	0,
			)
			characters = normalized
		}

		let updatedText = format( characters )
		// Only restore the caret when formatting changed the text,
		// preserving rapid typing.
		let isFieldRewritten = updatedText != displayedText

		text = characters
		setDisplayedText( updatedText )

		if isFieldRewritten {
			setCaret(
				afterSignificantCount: significantCount,
				in: updatedText,
			)
		}
	}

	func revertEdit(
		to previousText: String,
		caretOffset: Int,
	) {
		setDisplayedText( previousText )
		setCaret(
			offset: caretOffset,
			in: previousText,
		)
	}

	func setDisplayedText( _ value: String ) {
		caretText = value
		guard value != displayedText else { return }
		appliedText = value
		displayedText = value
	}

	func setCaret(
		afterSignificantCount count: Int,
		in updatedText: String,
	) {
		setCaret(
			offset: mask?.caretOffset(
				afterSignificantCount: count,
				in: updatedText,
			) ?? numberCaretOffset(
				after: count,
				in: updatedText,
			),
			in: updatedText,
		)
	}

	func setCaret(
		offset: Int,
		in updatedText: String,
	) {

		let index = updatedText.index(
			updatedText.startIndex,
			offsetBy: min( max( offset, 0 ), updatedText.count ),
		)
		selection = TextSelection( insertionPoint: index )
	}

	func significantCharacters( in string: String ) -> String {

		if let mask {
			return mask.significantCharacters( in: string )
		}
		else if isNumberInput {
			return string.filter { Mask.Token.digit.accepts( $0 ) }
		}
		else if let characterLimit {
			return String(
				string.prefix(
					max( characterLimit, 0 ),
				),
			)
		}

		return string
	}

	func overflows( _ string: String ) -> Bool {

		guard let mask else {
			guard let characterLimit else { return false }
			let characters = isNumberInput
				? Self.normalizedNumber( string.filter { Mask.Token.digit.accepts( $0 ) } )
				: string
			return characters.count > max(
				characterLimit,
				0,
			)
		}
		return mask.overflows( string )
	}

	func format( _ characters: String ) -> String {
		if let mask {
			return mask.format( characters )
		}
		return isNumberInput ? Self.groupedNumber( characters ) : characters
	}

	func numberCaretOffset(
		after count: Int,
		in string: String,
	) -> Int {

		guard isNumberInput, count > 0 else { return count }

		var remaining = count

		for ( offset, character ) in string.enumerated() {

			if Mask.Token.digit.accepts( character ) {
				remaining -= 1
			}

			if remaining == 0 {
				return offset + 1
			}
		}

		return string.count
	}

	func caretOffsetBeforeEdit(
		from previousText: String,
		to editedText: String,
	) -> Int {

		if caretText == previousText, let caretOffset {
			return min( caretOffset, previousText.count )
		}

		return estimatedCaretOffset(
			from: previousText,
			to: editedText,
		)
	}

	func caretOffset(
		of selection: TextSelection?,
		in string: String,
	) -> Int? {

		guard let indices = selection?.indices,
		      case .selection( let range ) = indices,
		      range.upperBound >= string.startIndex,
		      range.upperBound <= string.endIndex else { return nil }

		return string.distance(
			from: string.startIndex,
			to: range.upperBound,
		)
	}

	// Falls back to common prefix/suffix comparison until a stable
	// selection is available.
	func estimatedCaretOffset(
		from previousText: String,
		to editedText: String,
	) -> Int {

		var prefixLength = 0
		while prefixLength < previousText.count,
		      prefixLength < editedText.count,
		      previousText[prefixLength] == editedText[prefixLength] {
			prefixLength += 1
		}

		var suffixLength = 0
		while suffixLength < previousText.count - prefixLength,
		      suffixLength < editedText.count - prefixLength,
		      previousText[previousText.count - suffixLength - 1]
		      == editedText[editedText.count - suffixLength - 1] {
			suffixLength += 1
		}

		return previousText.count - suffixLength
	}
}

extension MaskedTextField {

	// shortcut: matching edges make repeated-character edits
	// ambiguous; retain the old selection if exact ranges become
	// necessary.
	static func inputEdit(
		from previous: String,
		to edited: String,
	) -> ( range: Range<String.Index>, replacement: String ) {

		let prefixCount = zip(
			previous,
			edited,
		).prefix { $0 == $1 }.count

		let oldTail = previous.dropFirst( prefixCount )
		let newTail = edited.dropFirst( prefixCount )

		let suffixCount = zip(
			oldTail.reversed(),
			newTail.reversed(),
		).prefix { $0 == $1 }.count

		let start = previous.index(
			previous.startIndex,
			offsetBy: prefixCount,
		)
		let end = previous.index(
			previous.endIndex,
			offsetBy: -suffixCount,
		)

		return ( start..<end, String( newTail.dropLast( suffixCount ) ) )
	}

	static func normalizedNumber( _ digits: String ) -> String {
		let trimmed = digits.drop( while: { $0 == "0" } )
		return trimmed.isEmpty && !digits.isEmpty ? "0" : String( trimmed )
	}

	static func groupedNumber( _ digits: String ) -> String {

		let count = digits.count
		var result = ""

		for ( offset, digit ) in digits.enumerated() {
			if offset > 0, ( count - offset ).isMultiple( of: 3 ) {
				result.append( " " )
			}
			result.append( digit )
		}

		return result
	}
}

extension MaskedTextField {

	struct Mask {

		let prefix: String
		let body: String
		let tokens: [Token]

		init?( pattern: String ) {
			guard let firstTokenIndex = pattern.firstIndex( where: { Token( $0 ) != nil } )
			else { return nil }

			self.prefix = String( pattern[..<firstTokenIndex] )
			self.body = String( pattern[firstTokenIndex...] )
			self.tokens = body.compactMap { Token( $0 ) }
		}
	}
}

extension MaskedTextField.Mask {

	enum Token {

		case digit
		case letter
		case alphanumeric

		init?( _ symbol: Character ) {
			switch symbol {
			case "#": self = .digit
			case "@": self = .letter
			case "*": self = .alphanumeric
			default: return nil
			}
		}

		func accepts( _ character: Character ) -> Bool {
			switch self {
			case .digit: character.isASCII && character.isNumber
			case .letter: character.isLetter
			case .alphanumeric: character.isLetter || character.isNumber
			}
		}
	}

	var isNumeric: Bool {
		tokens.allSatisfy { $0 == .digit }
	}

	func significantCharacters( in string: String ) -> String {

		var result = ""

		for character in string {
			guard result.count < tokens.count else { break }
			if tokens[result.count].accepts( character ) {
				result.append( character )
			}
		}

		return result
	}

	func overflows( _ string: String ) -> Bool {

		var count = 0

		for character in string {
			guard count < tokens.count else {
				if tokens.contains( where: { $0.accepts( character ) } ) {
					return true
				}
				continue
			}
			if tokens[count].accepts( character ) {
				count += 1
			}
		}

		return false
	}

	func format( _ characters: String ) -> String {

		var characters = Substring( characters )
		var result = ""

		for symbol in body {
			guard characters.isNotEmpty else { break }
			if Token( symbol ) == nil {
				result.append( symbol )
			} else {
				result.append( characters.removeFirst() )
			}
		}

		return result
	}

	func remainder(
		after offset: Int,
		fillSymbol: Character,
	) -> String {
		body
			.dropFirst( offset )
			.map { Token( $0 ) == nil ? $0 : fillSymbol }
			.string
	}

	func caretOffset(
		afterSignificantCount count: Int,
		in formattedText: String,
	) -> Int {

		guard count > 0 else { return 0 }

		var remaining = count
		var offset = 0

		for symbol in body {
			guard offset < formattedText.count else { break }
			offset += 1
			guard Token( symbol ) != nil else { continue }
			remaining -= 1
			guard remaining > 0 else { break }
		}

		return offset
	}
}

#if DEBUG

private struct MaskedTextFieldPreview: View {

	@State private var plainText: String = ""
	@State private var phone: String = ""
	@State private var inputChangePhone: String = ""
	@State private var filledPhone: String = "931331400"
	@State private var date: String = ""
	@State private var card: String = ""
	@State private var passport: String = ""
	@State private var alphanumeric: String = ""
	@State private var amount: String = ""
	@State private var comment: String = ""
	@State private var blockedCard: String = "8600123412341234"
	@State private var isInputBlocked: Bool = true

	var body: some View {

		ScrollView {

			VStack( spacing: 12 ) {

				row(
					"Unformatted",
					value: plainText,
				) {
					MaskedTextField(
						"Plain text",
						text: $plainText,
					)
				}

				row(
					"Phone",
					value: phone,
				) {
					MaskedTextField(
						"Phone number",
						text: $phone,
						mode: .masked( "+998 ## ### ## ##" ),
					)
					.maskedTextFieldPlaceholderColor( .red.opacity( 0.6 ) )
				}

				row(
					"onInputChange",
					value: inputChangePhone,
				) {
					MaskedTextField(
						text: $inputChangePhone,
						mode: .masked( "+998 ## ### ## ##" ),
					)
					.maskedTextFieldOnInputChange { _, _, replacement in
						let digits = replacement.filter { $0.isASCII && $0.isNumber }
						guard digits.count == 12, digits.hasPrefix( "998" ) else { return .accept }
						return .replaceAll( String( digits.suffix( 9 ) ) )
					}
					.maskedTextFieldMaskFillSymbol( "0" )

					#if os(iOS)
					HStack {
						Button( "Copy +998 93 123 45 67" ) {
							UIPasteboard.general.string = "+998 93 123 45 67"
						}
						Button( "Copy 1234" ) {
							UIPasteboard.general.string = "1234"
						}
					}
					.buttonStyle( .bordered )
					.font( .caption )
					#endif
				}

				row(
					"Prefilled phone",
					value: filledPhone,
				) {
					MaskedTextField(
						text: $filledPhone,
						mode: .masked( "+998 ## ### ## ##" ),
					)
				}

				row(
					"Date",
					value: date,
				) {
					MaskedTextField(
						text: $date,
						mode: .masked( "##.##.####" ),
					)
						.maskedTextFieldMaskFillSymbol( "_" )
				}

				row(
					"Card",
					value: card,
				) {
					MaskedTextField(
						text: $card,
						mode: .masked( "#### #### #### ####" ),
					)
						.maskedTextFieldMaskFillSymbol( "•" )
						.maskedTextFieldPlaceholderColor( .blue )
				}

				row(
					"Passport",
					value: passport,
				) {
					MaskedTextField(
						"AA 1234-567",
						text: $passport,
						mode: .masked( "@@ ####-###" ),
					)
						.maskedTextFieldOnInputChange { _, _, replacement in
							.accept( replacement: replacement.uppercased() )
						}
						#if os(iOS)
						.textInputAutocapitalization( .characters )
						#endif
				}

				row(
					"Letters and digits",
					value: alphanumeric,
				) {
					MaskedTextField(
						text: $alphanumeric,
						mode: .masked( "**** ****" ),
					)
						.maskedTextFieldMaskFillSymbol( "_" )
				}

				row(
					"Number input",
					value: amount,
				) {
					MaskedTextField(
						"0",
						text: $amount,
						mode: .groupedInteger( characterLimit: 16 ),
					)
						.maskedTextFieldTrailingText( " units" )
				}

				row(
					"Hidden when empty",
					value: comment,
				) {
					MaskedTextField(
						"Comment",
						text: $comment,
						mode: .masked( "+998 ## ### ## ##" ),
					)
						.maskedTextFieldHidesMaskWhenEmpty()
				}

				VStack( spacing: 12 ) {
					row(
						"Blocked input",
						value: blockedCard,
					) {
						MaskedTextField(
							text: $blockedCard,
							mode: .masked( "#### #### #### ####" ),
						)
							.maskedTextFieldInputDisabled( isInputBlocked )
					}

					Toggle(
						"Block input",
						isOn: $isInputBlocked,
					)
						.font( .footnote )
				}
				.padding( 12 )
				.background(
					Color.purple.opacity( 0.18 ),
					in: RoundedRectangle( cornerRadius: 16 ),
				)
			}
			.padding()
		}
	}

	func row(
		_ title: String,
		value: String,
		@ViewBuilder field: () -> some View,
	) -> some View {

		VStack(
			alignment: .leading,
			spacing: 4,
		) {

			HStack {
				Text( title )
				Spacer()
				Text( verbatim: "«\( value )»" )
					.foregroundStyle( .secondary )
			}
			.font( .caption )

			field()
				.font( .body )
				.padding(
					.horizontal,
					12,
				)
				.frame( height: 48 )
				.overlay(
					RoundedRectangle( cornerRadius: 12 )
						.stroke(
							.gray.opacity( 0.4 ),
							lineWidth: 1,
						),
				)
		}
	}
}

#Preview {
	MaskedTextFieldPreview()
}
#endif
#endif
