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

/// A text field with masked, plain-text, and special numeric input modes.
///
/// ### Input modes
///
/// - **Masked input:** `mask` defines the accepted characters, separators, and
///   input capacity. The binding contains significant characters only.
/// - **Plain text:** accepts text as entered, subject to `.characterLimit(_:)`.
/// - **Numeric input:** `.numberInput()` enables a special mode for nonnegative
///   integers. Digits are grouped in threes (`"1 234 567"`), while the binding
///   stores digits only (`"1234567"`). Leading zeros are removed; a single zero
///   and an empty value are preserved. `.characterLimit(_:)` counts digits after
///   normalization. A mask takes precedence over this mode.
///
/// ```swift
/// MaskedTextField("Phone", text: $phone, mask: "+998 ## ### ## ##")
/// MaskedTextField("0", text: $amount)
///     .numberInput()
///     .characterLimit(16)
/// ```
///
/// ### Mask tokens
///
/// - `#` accepts an ASCII digit.
/// - `@` accepts a letter.
/// - `*` accepts a letter or digit.
///
/// Other characters are separators. A prefix before the first token is immutable.
/// Separators after the prefix must not match the mask's tokens.
///
/// ### Appearance
///
/// Placeholder and mask remainder colors inherit from
/// `.maskedTextFieldPlaceholderColor(_:)`, defaulting to the system placeholder
/// color. `.placeholderColor(_:)` overrides the color for an individual field.
/// `.maskFillSymbol(_:)` sets the unfilled token symbol; nil hides the remainder.
/// `.hidesMaskWhenEmpty()` hides the mask while empty and unfocused.
/// `.trailingText(_:)` appends a label, such as a unit, after the entered value.
///
/// ### Keyboard
///
/// Numeric masks and the special numeric input mode use the number pad on iOS.
public struct MaskedTextField {

	private let prompt: String?
	@Binding private var text: String
	private let mask: Mask?

	private var maskFillSymbol: Character? = " "
	@Environment( \.maskedTextFieldPlaceholderColor ) private var defaultPlaceholderColor
	private var placeholderColor: Color?
	private var trailingText: String?
	private var hidesMaskWhenEmpty: Bool = false
	private var characterLimit: Int?
	private var usesNumberInput: Bool = false
	private var allowsInput: Bool = true
	private var inputFilter: (( String ) -> String?)?

	@FocusState private var isFocused: Bool
	@State private var selection: TextSelection?
	/// Separate display state restores rejected edits even when the binding is unchanged.
	@State private var displayedText: String = ""
	/// Compare values rather than flags so coalesced user edits are not discarded.
	@State private var appliedText: String?
	/// Selection before an edit disambiguates deletion among identical characters.
	@State private var caretOffset: Int?
	/// The display value to which the stored caret belongs.
	@State private var caretText: String = ""

	public init(
		_ prompt: String? = nil,
		text: Binding<String>,
		mask: String? = nil,
	) {
		self.prompt = prompt
		self._text = text
		self.mask = mask.flatMap { Mask( pattern: $0 ) }
	}
}

public extension MaskedTextField {

	/// Sets the unfilled token symbol; nil hides the unfilled mask remainder.
	func maskFillSymbol( _ character: Character? ) -> Self {
		var new = self
		new.maskFillSymbol = character
		return new
	}

	/// Overrides the inherited placeholder and unfilled mask color for this field.
	func placeholderColor( _ color: Color ) -> Self {
		var new = self
		new.placeholderColor = color
		return new
	}

	/// Appends a label, such as a unit, after the entered value.
	func trailingText( _ text: String? ) -> Self {
		var new = self
		new.trailingText = text
		return new
	}

	/// Hides the mask while the field is empty and unfocused.
	func hidesMaskWhenEmpty( _ hides: Bool = true ) -> Self {
		var new = self
		new.hidesMaskWhenEmpty = hides
		return new
	}

	/// Limits significant input length without a mask; a mask defines its own capacity.
	func characterLimit( _ limit: Int? ) -> Self {
		var new = self
		new.characterLimit = limit
		return new
	}

	/// Enables the special numeric input mode for nonnegative integers.
	/// Groups digits in threes and removes leading zeros, preserving a single zero
	/// or an empty value. The binding stores digits only; a mask takes precedence.
	func numberInput( _ enabled: Bool = true ) -> Self {
		var new = self
		new.usesNumberInput = enabled
		return new
	}

	/// Prevents edits without disabling the field or removing focus.
	func allowsInput( _ allows: Bool ) -> Self {
		var new = self
		new.allowsInput = allows
		return new
	}

	/// Transforms significant input, or rejects an edit by returning nil.
	/// The result is not revalidated against the mask or character limit.
	func inputFilter( _ filter: (( String ) -> String?)? ) -> Self {
		var new = self
		new.inputFilter = filter
		return new
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
		.animation( .default, value: isMaskVisible )

		.onAppear {
			setDisplayedText( formattedText )
		}
		.onChange( of: displayedText ) { previousText, editedText in
			let ownEdit = appliedText
			appliedText = nil
			guard editedText != ownEdit else { return }
			apply( edit: editedText, previousText: previousText )
		}
		.onChange( of: selection ) {
			guard displayedText == caretText else { return }
			caretOffset = caretOffset( of: selection, in: displayedText )
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
			prompt: prompt.map { Text( verbatim: $0 ).foregroundStyle( placeholderColor ?? defaultPlaceholderColor ) },
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
			result = result + Text( verbatim: remainder ).foregroundStyle( placeholderColor ?? defaultPlaceholderColor )
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

	var formattedText: String {
		guard let mask else {
			var characters = significantCharacters( in: text )
			if isNumberInput {
				characters = Self.normalizedNumber( characters )
				if let characterLimit {
					characters = String( characters.prefix( max( characterLimit, 0 ) ) )
				}
			}
			return format( characters )
		}
		return mask.format( mask.significantCharacters( in: text ) )
	}

	func apply( edit editedText: String, previousText: String ) {

		let caretBeforeEdit = caretOffsetBeforeEdit( from: previousText, to: editedText )

		guard allowsInput else {
			return revertEdit( to: previousText, caretOffset: caretBeforeEdit )
		}

		// Reject overflow rather than truncating an existing suffix the user did not delete.
		guard !overflows( editedText ) else {
			return revertEdit( to: previousText, caretOffset: caretBeforeEdit )
		}

		let caretAfterEdit = caretOffset( of: selection, in: editedText ) ?? min(
			max( caretBeforeEdit + editedText.count - previousText.count, 0 ),
			editedText.count,
		)

		var significantCount = significantCharacters(
			in: String( editedText.prefix( caretAfterEdit ) ),
		).count
		var characters = significantCharacters( in: editedText )

		// Deleting a separator removes the adjacent significant character instead.
		if mask != nil || isNumberInput,
		   editedText.count < previousText.count,
		   significantCount > 0,
		   characters == significantCharacters( in: previousText ) {
			let isBackwardDeletion = caretAfterEdit < caretBeforeEdit
			if isBackwardDeletion {
				significantCount -= 1
			}
			characters.remove(
				at: characters.index( characters.startIndex, offsetBy: significantCount ),
			)
		}

		if let inputFilter {
			guard let filtered = inputFilter( characters ) else {
				return revertEdit( to: previousText, caretOffset: caretBeforeEdit )
			}
			characters = filtered
			significantCount = min( significantCount, characters.count )
		}

		if isNumberInput {
			let normalized = Self.normalizedNumber( characters )
			significantCount = max( significantCount - (characters.count - normalized.count), 0 )
			characters = normalized
		}

		let updatedText = format( characters )
		// Only restore the caret when formatting changed the text, preserving rapid typing.
		let isFieldRewritten = updatedText != displayedText

		text = characters
		setDisplayedText( updatedText )

		if isFieldRewritten {
			setCaret( afterSignificantCount: significantCount, in: updatedText )
		}
	}

	func revertEdit( to previousText: String, caretOffset: Int ) {
		setDisplayedText( previousText )
		setCaret( offset: caretOffset, in: previousText )
	}

	func setDisplayedText( _ value: String ) {
		caretText = value
		guard value != displayedText else { return }
		appliedText = value
		displayedText = value
	}

	func setCaret( afterSignificantCount count: Int, in updatedText: String ) {
		setCaret(
			offset: mask?.caretOffset( afterSignificantCount: count, in: updatedText )
				?? numberCaretOffset( after: count, in: updatedText ),
			in: updatedText,
		)
	}

	func setCaret( offset: Int, in updatedText: String ) {

		let index = updatedText.index(
			updatedText.startIndex,
			offsetBy: min( max( offset, 0 ), updatedText.count ),
		)
		selection = TextSelection( insertionPoint: index )
	}

	func significantCharacters( in string: String ) -> String {

		guard let mask else {
			if isNumberInput {
				return string.filter { Mask.Token.digit.accepts( $0 ) }
			}
			let characters = string
			guard let characterLimit else { return characters }
			return String( characters.prefix( max( characterLimit, 0 ) ) )
		}
		return mask.significantCharacters( in: string )
	}

	func overflows( _ string: String ) -> Bool {

		guard let mask else {
			guard let characterLimit else { return false }
			let characters = isNumberInput
				? Self.normalizedNumber( string.filter { Mask.Token.digit.accepts( $0 ) } )
				: string
			return characters.count > max( characterLimit, 0 )
		}
		return mask.overflows( string )
	}

	var isNumberInput: Bool { usesNumberInput && mask == nil }

	func format( _ characters: String ) -> String {
		if let mask {
			return mask.format( characters )
		}
		return isNumberInput ? Self.groupedNumber( characters ) : characters
	}

	func numberCaretOffset( after count: Int, in string: String ) -> Int {
		guard isNumberInput, count > 0 else { return count }
		var remaining = count
		for (offset, character) in string.enumerated() {
			if Mask.Token.digit.accepts( character ) {
				remaining -= 1
			}
			if remaining == 0 {
				return offset + 1
			}
		}
		return string.count
	}

	func caretOffsetBeforeEdit( from previousText: String, to editedText: String ) -> Int {

		if caretText == previousText, let caretOffset {
			return min( caretOffset, previousText.count )
		}
		return estimatedCaretOffset( from: previousText, to: editedText )
	}

	func caretOffset( of selection: TextSelection?, in string: String ) -> Int? {

		guard let indices = selection?.indices,
		      case .selection( let range ) = indices,
		      range.upperBound >= string.startIndex,
		      range.upperBound <= string.endIndex else { return nil }

		return string.distance( from: string.startIndex, to: range.upperBound )
	}

	/// Falls back to common prefix/suffix comparison until a stable selection is available.
	func estimatedCaretOffset( from previousText: String, to editedText: String ) -> Int {

		let previousCharacters = Array( previousText )
		let editedCharacters = Array( editedText )

		var prefixLength = 0
		while prefixLength < previousCharacters.count,
		      prefixLength < editedCharacters.count,
		      previousCharacters[prefixLength] == editedCharacters[prefixLength] {
			prefixLength += 1
		}

		var suffixLength = 0
		while suffixLength < previousCharacters.count - prefixLength,
		      suffixLength < editedCharacters.count - prefixLength,
		      previousCharacters[previousCharacters.count - suffixLength - 1]
		      == editedCharacters[editedCharacters.count - suffixLength - 1] {
			suffixLength += 1
		}

		return previousCharacters.count - suffixLength
	}
}

extension MaskedTextField {

	static func normalizedNumber( _ digits: String ) -> String {
		let trimmed = digits.drop( while: { $0 == "0" } )
		return trimmed.isEmpty && !digits.isEmpty ? "0" : String( trimmed )
	}

	static func groupedNumber( _ digits: String ) -> String {
		let count = digits.count
		var result = ""
		for (offset, digit) in digits.enumerated() {
			if offset > 0, (count - offset).isMultiple( of: 3 ) {
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

	func remainder( after offset: Int, fillSymbol: Character ) -> String {
		String( body.dropFirst( offset ).map { Token( $0 ) == nil ? $0 : fillSymbol } )
	}

	func caretOffset( afterSignificantCount count: Int, in formattedText: String ) -> Int {

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

				row( "Unformatted", value: plainText ) {
					MaskedTextField( "Plain text", text: $plainText )
				}

				row( "Phone", value: phone ) {
					MaskedTextField(
						"Phone number",
						text: $phone,
						mask: "+998 ## ### ## ##",
					)
					.placeholderColor( .red.opacity(0.6) )
				}

				row( "Prefilled phone", value: filledPhone ) {
					MaskedTextField( text: $filledPhone, mask: "+998 ## ### ## ##" )
				}

				row( "Date", value: date ) {
					MaskedTextField( text: $date, mask: "##.##.####" )
						.maskFillSymbol( "_" )
				}

				row( "Card", value: card ) {
					MaskedTextField( text: $card, mask: "#### #### #### ####" )
						.maskFillSymbol( "•" )
						.placeholderColor( .blue )
				}

				row( "Passport", value: passport ) {
					MaskedTextField( "AA 1234-567", text: $passport, mask: "@@ ####-###" )
						.inputFilter { $0.uppercased() }
						#if os(iOS)
						.textInputAutocapitalization( .characters )
						#endif
				}

				row( "Letters and digits", value: alphanumeric ) {
					MaskedTextField( text: $alphanumeric, mask: "**** ****" )
						.maskFillSymbol( "_" )
				}

				row( "Number input", value: amount ) {
					MaskedTextField( "0", text: $amount )
						.characterLimit( 16 )
						.numberInput()
						.trailingText( " units" )
				}

				row( "Hidden when empty", value: comment ) {
					MaskedTextField( "Comment", text: $comment, mask: "+998 ## ### ## ##" )
						.hidesMaskWhenEmpty()
				}

				VStack( spacing: 12 ) {
					row( "Blocked input", value: blockedCard ) {
						MaskedTextField( text: $blockedCard, mask: "#### #### #### ####" )
							.allowsInput( !isInputBlocked )
					}

					Toggle( "Block input", isOn: $isInputBlocked )
						.font( .footnote )
				}
				.padding( 12 )
				.background( Color.purple.opacity( 0.18 ), in: RoundedRectangle( cornerRadius: 16 ) )
			}
			.padding()
		}
	}

	func row(
		_ title: String,
		value: String,
		@ViewBuilder field: () -> some View,
	) -> some View {

		VStack( alignment: .leading, spacing: 4 ) {

			HStack {
				Text( title )
				Spacer()
				Text( verbatim: "«\( value )»" )
					.foregroundStyle( .secondary )
			}
			.font( .caption )

			field()
				.font( .body )
				.padding( .horizontal, 12 )
				.frame( height: 48 )
				.overlay(
					RoundedRectangle( cornerRadius: 12 )
						.stroke( .gray.opacity( 0.4 ), lineWidth: 1 ),
				)
		}
	}
}

#Preview {
	MaskedTextFieldPreview()
}
#endif
#endif
