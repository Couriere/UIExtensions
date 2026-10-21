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

import XCTest

// Type one key at a time and await formatting: batched XCUITest input can
// coalesce with a programmatic rewrite of the field. Hardware arrow keys and
// Control-D exercise caret movement and forward deletion.

@MainActor
final class MaskedTextFieldUITests: XCTestCase {

	private var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
	}

	override func tearDownWithError() throws {
		app = nil
	}
}

extension MaskedTextFieldUITests {

	func testForwardDeletionAndCaretAfterInsertion() {

		launchApp()

		guard let field = focusedField( .phone ) else { return }

		let steps = [
			( "1", "1" ),
			( "2", "12" ),
			( "3", "12 3" ),
			( "4", "12 34" ),
			( "5", "12 345" ),
			( "6", "12 345 6" ),
		]

		for ( digit, displayed ) in steps {
			field.typeText( digit )
			assertDisplayed(
				displayed,
				in: field,
				of: .phone,
			)
		}

		for _ in 0..<4 {
			field.typeKey(
				XCUIKeyboardKey.leftArrow.rawValue,
				modifierFlags: [],
			)
		}
		field.typeKey(
			"d",
			modifierFlags: .control,
		)
		assertDisplayed(
			"12 356",
			in: field,
			of: .phone,
		)
		assertValue(
			"12356",
			of: .phone,
		)

		field.typeText( "9" )
		assertDisplayed(
			"12 395 6",
			in: field,
			of: .phone,
		)
		assertValue(
			"123956",
			of: .phone,
		)

		assertForwardDeleteBeforeSeparator(
			leftArrowCount: 6,
			displayed: "12 345 78 9",
			value: "12345789",
			afterInsertion: "12 345 07 89",
		)
		assertForwardDeleteBeforeSeparator(
			leftArrowCount: 3,
			displayed: "12 345 67 9",
			value: "12345679",
			afterInsertion: "12 345 67 09",
		)
	}

	func testMaskedTextFieldInput() {

		launchApp()

		assertMaskFormatsTypedCharacters()
		assertOverflowIsRejected()
		assertDeletionRemovesCharactersOneByOne()
		assertExternalValueIsEditable()
		assertSeparatorIsInsertedAutomatically()
		assertInputTransformationAndTokenKinds()
		assertCharacterLimitWithoutMask()
		assertBlockedFieldIgnoresInput()
		assertMaskIsHiddenWhileFieldIsEmpty()
	}
	func testGroupedIntegerInputAndEditing() {
		launchApp()
		guard let field = focusedField( .number ) else { return }
		for ( input, value, displayed ) in [
			( "0", "0", "0" ),
			( "0", "0", "0" ),
			( "1", "1", "1" ),
			( "2", "12", "12" ),
			( "3", "123", "123" ),
			( "4", "1234", "1 234" ),
			( "5", "12345", "12 345" ),
			( "6", "123456", "123 456" ),
			( "7", "123456", "123 456" ),
			( XCUIKeyboardKey.delete.rawValue, "12345", "12 345" ),
			( XCUIKeyboardKey.delete.rawValue, "1234", "1 234" ),
			( XCUIKeyboardKey.delete.rawValue, "123", "123" ),
			( XCUIKeyboardKey.delete.rawValue, "12", "12" ),
			( XCUIKeyboardKey.delete.rawValue, "1", "1" ),
			( XCUIKeyboardKey.delete.rawValue, "", "" ),
			( "r", "12", "12" ),
			( "i", "12", "12" ),
			( "o", "12", "12" ),
			( "3", "123", "123" ),
		] {
			assertEdit(
				input,
				value: value,
				displayed: displayed,
				in: field,
				of: .number,
			)
		}
		resetFixture( field )
		for ( input, value, displayed ) in [
			( "1", "1", "1" ),
			( "2", "12", "12" ),
			( "3", "123", "123" ),
			( "4", "1234", "1 234" ),
		] {
			assertEdit(
				input,
				value: value,
				displayed: displayed,
				in: field,
				of: .number,
			)
		}
		moveCaret(
			3,
			in: field,
		)
		for ( input, value, displayed ) in [
			( XCUIKeyboardKey.delete.rawValue, "234", "234" ),
			( "9", "9234", "9 234" ),
		] {
			assertEdit(
				input,
				value: value,
				displayed: displayed,
				in: field,
				of: .number,
			)
		}
		moveCaret(
			1,
			in: field,
		)
		field.typeKey(
			"d",
			modifierFlags: .control,
		)
		assertField(
			"234",
			displayed: nil,
			in: field,
			of: .number,
		)
		assertEdit(
			"5",
			value: "5234",
			displayed: "5 234",
			in: field,
			of: .number,
		)
		resetFixture( field )
		paste( "000000123456" )
		assertField(
			"123456",
			displayed: "123 456",
			in: field,
			of: .number,
		)

	}

	func testInputDecisionsPasteAndSelection() {
		launchApp()
		guard let field = focusedField( .transformed ) else { return }
		moveCaret(
			2,
			in: field,
		)
		for ( input, value, displayed ) in [
			( "x", "abXYZCD", "abXYZCD" ),
			( "1", "abXYZ1CD", "abXYZ1CD" ),
		] {
			assertEdit(
				input,
				value: value,
				displayed: displayed,
				in: field,
				of: .transformed,
			)
		}
		resetFixture( field )
		moveCaret(
			2,
			in: field,
		)
		paste( "shrink" )
		assertField(
			"abqCD",
			displayed: nil,
			in: field,
			of: .transformed,
		)
		assertEdit(
			"1",
			value: "abq1CD",
			displayed: nil,
			in: field,
			of: .transformed,
		)
		resetFixture( field )
		moveCaret(
			2,
			in: field,
		)
		paste( "drop" )
		assertField(
			"abCD",
			displayed: nil,
			in: field,
			of: .transformed,
		)
		assertEdit(
			"1",
			value: "ab1CD",
			displayed: nil,
			in: field,
			of: .transformed,
		)
		resetFixture( field )
		moveCaret(
			2,
			in: field,
		)
		paste( "1234567890" )
		assertField(
			"abCD",
			displayed: nil,
			in: field,
			of: .transformed,
		)
		assertEdit(
			"1",
			value: "ab1CD",
			displayed: nil,
			in: field,
			of: .transformed,
		)
		resetFixture( field )
		moveCaret(
			2,
			in: field,
		)
		tapButton(
			"masked_text_field_demo_reject",
			name: "Reject edits",
		)
		for ( input, value, displayed ) in [
			( "9", "abCD", "abCD" ),
			( XCUIKeyboardKey.delete.rawValue, "abCD", "abCD" ),
		] {
			assertEdit(
				input,
				value: value,
				displayed: displayed,
				in: field,
				of: .transformed,
			)
		}
		paste( "12" )
		assertField(
			"abCD",
			displayed: nil,
			in: field,
			of: .transformed,
		)
		tapButton(
			"masked_text_field_demo_reject",
			name: "Allow edits",
		)
		assertEdit(
			"1",
			value: "ab1CD",
			displayed: nil,
			in: field,
			of: .transformed,
		)
		resetFixture( field )
		moveCaret(
			2,
			in: field,
			selecting: true,
		)
		assertEdit(
			"k",
			value: "abk",
			displayed: nil,
			in: field,
			of: .transformed,
		)
		resetFixture( field )
		moveCaret(
			2,
			in: field,
			selecting: true,
		)
		paste( "12" )
		assertField(
			"ab12",
			displayed: nil,
			in: field,
			of: .transformed,
		)

		guard let replacementField = focusedField( .replacement ) else { return }
		moveCaret(
			2,
			in: replacementField,
		)
		for ( input, value, displayed ) in [
			( "r", "98765432", "98 765 43 2" ),
			( "1", "987654321", "98 765 43 21" ),
			( "i", "987654321", "98 765 43 21" ),
			( "o", "987654321", "98 765 43 21" ),
			( XCUIKeyboardKey.delete.rawValue, "98765432", "98 765 43 2" ),
		] {
			assertEdit(
				input,
				value: value,
				displayed: displayed,
				in: replacementField,
				of: .replacement,
			)
		}
		resetFixture( replacementField )
		moveCaret(
			2,
			in: replacementField,
		)
		paste( "+998 93 123 45 67" )
		assertField(
			"931234567",
			displayed: "93 123 45 67",
			in: replacementField,
			of: .replacement,
		)

		guard let phoneField = focusedField( .phone ) else { return }
		paste( "93 123 45 67" )
		assertField(
			"931234567",
			displayed: "93 123 45 67",
			in: phoneField,
			of: .phone,
		)
		tapButton(
			AID.clearPhone,
			name: "Clear",
		)
		phoneField.tap()
		for ( input, value, displayed ) in [
			( "1", "1", "1" ),
			( "2", "12", "12" ),
			( "3", "123", "12 3" ),
		] {
			assertEdit(
				input,
				value: value,
				displayed: displayed,
				in: phoneField,
				of: .phone,
			)
		}
		moveCaret(
			2,
			in: phoneField,
		)
		paste( "1234567890" )
		assertField(
			"123",
			displayed: "12 3",
			in: phoneField,
			of: .phone,
		)
		assertEdit(
			"9",
			value: "1293",
			displayed: "12 93",
			in: phoneField,
			of: .phone,
		)
	}

}

private extension MaskedTextFieldUITests {

	func assertForwardDeleteBeforeSeparator(
		leftArrowCount: Int,
		displayed: String,
		value: String,
		afterInsertion: String,
	) {
		guard tapButton(
			AID.clearPhone,
			name: "Clear",
		) else { return }
		guard let field = focusedField( .phone ) else { return }

		let steps = [
			"1", "12", "12 3", "12 34", "12 345", "12 345 6",
			"12 345 67", "12 345 67 8", "12 345 67 89",
		]
		for ( digit, expected ) in zip(
			"123456789",
			steps,
		) {
			field.typeText( String( digit ) )
			assertDisplayed(
				expected,
				in: field,
				of: .phone,
			)
		}
		for _ in 0..<leftArrowCount {
			field.typeKey(
				XCUIKeyboardKey.leftArrow.rawValue,
				modifierFlags: [],
			)
		}
		field.typeKey(
			"d",
			modifierFlags: .control,
		)
		assertDisplayed(
			displayed,
			in: field,
			of: .phone,
		)
		assertValue(
			value,
			of: .phone,
		)

		field.typeText( "0" )
		assertDisplayed(
			afterInsertion,
			in: field,
			of: .phone,
		)
	}

	func assertMaskFormatsTypedCharacters() {

		guard let field = focusedField( .phone ) else { return }

		let steps = [
			( "9", "9" ),
			( "3", "93" ),
			( "1", "93 1" ),
			( "3", "93 13" ),
			( "3", "93 133" ),
			( "1", "93 133 1" ),
			( "4", "93 133 14" ),
			( "0", "93 133 14 0" ),
			( "0", "93 133 14 00" ),
		]

		for ( digit, displayed ) in steps {
			field.typeText( digit )
			assertDisplayed(
				displayed,
				in: field,
				of: .phone,
			)
		}

		assertValue(
			"931331400",
			of: .phone,
		)
	}

	func assertOverflowIsRejected() {

		guard let field = focusedField( .phone ) else { return }

		field.typeText( "5" )

		assertUnchanged(
			"93 133 14 00",
			in: field,
			of: .phone,
		)
		assertValue(
			"931331400",
			of: .phone,
		)
	}

	func assertDeletionRemovesCharactersOneByOne() {

		guard let field = focusedField( .phone ) else { return }

		let steps = [
			( "93 133 14 0", "93133140" ),
			( "93 133 14", "9313314" ),
			( "93 133 1", "931331" ),
			( "93 133", "93133" ),
			( "93 13", "9313" ),
			( "93 1", "931" ),
			( "93", "93" ),
			( "9", "9" ),
			( "", "" ),
		]

		for ( displayed, value ) in steps {
			field.typeText( XCUIKeyboardKey.delete.rawValue )
			assertDisplayed(
				displayed,
				in: field,
				of: .phone,
			)
			assertValue(
				value,
				of: .phone,
			)
		}

		field.typeText( XCUIKeyboardKey.delete.rawValue )
		assertUnchanged(
			"",
			in: field,
			of: .phone,
		)
		assertValue(
			"",
			of: .phone,
		)
	}

	func assertExternalValueIsEditable() {

		guard let field = field( .phone ) else { return }

		guard tapButton(
			AID.fillPhone,
			name: "Set external value",
		) else { return }

		assertDisplayed(
			"93 133 14 00",
			in: field,
			of: .phone,
		)
		assertValue(
			AID.externalPhone,
			of: .phone,
		)

		field.tap()
		field.typeText( XCUIKeyboardKey.delete.rawValue )
		assertDisplayed(
			"93 133 14 0",
			in: field,
			of: .phone,
		)

		field.typeText( "5" )
		assertDisplayed(
			"93 133 14 05",
			in: field,
			of: .phone,
		)
		assertValue(
			"931331405",
			of: .phone,
		)

		guard tapButton(
			AID.clearPhone,
			name: "Clear",
		) else { return }

		assertDisplayed(
			"",
			in: field,
			of: .phone,
		)
		assertValue(
			"",
			of: .phone,
		)
	}

	func assertSeparatorIsInsertedAutomatically() {

		guard let field = focusedField( .date ) else { return }

		let steps = [
			( "0", "0", "0" ),
			( "1", "01", "01" ),
			( "0", "01.0", "010" ),
			( "2", "01.02", "0102" ),
			( "2", "01.02.2", "01022" ),
			( "0", "01.02.20", "010220" ),
			( "2", "01.02.202", "0102202" ),
			( "6", "01.02.2026", "01022026" ),
		]

		for ( digit, displayed, value ) in steps {
			field.typeText( digit )
			assertDisplayed(
				displayed,
				in: field,
				of: .date,
			)
			assertValue(
				value,
				of: .date,
			)
		}
	}

	func assertInputTransformationAndTokenKinds() {

		guard let field = focusedField( .passport ) else { return }

		field.typeText( "a" )
		assertDisplayed(
			"A",
			in: field,
			of: .passport,
		)

		field.typeText( "b" )
		assertDisplayed(
			"AB",
			in: field,
			of: .passport,
		)
		assertValue(
			"AB",
			of: .passport,
		)

		for letter in [ "c", "d" ] {
			field.typeText( letter )
			assertUnchanged(
				"AB",
				in: field,
				of: .passport,
			)
		}
		assertValue(
			"AB",
			of: .passport,
		)

		let digits = "1234567"

		for ( index, digit ) in digits.enumerated() {
			field.typeText( String( digit ) )
			assertDisplayed(
				"AB \( digits.prefix( index + 1 ) )",
				in: field,
				of: .passport,
			)
		}

		assertValue(
			"AB1234567",
			of: .passport,
		)

		// Transform a replacement in the middle and keep the following insertion there.
		for _ in 0..<10 {
			field.typeKey(
				XCUIKeyboardKey.leftArrow.rawValue,
				modifierFlags: [],
			)
		}
		field.typeKey(
			"d",
			modifierFlags: .control,
		)
		assertValue(
			"B1234567",
			of: .passport,
		)
		field.typeText( "c" )
		assertDisplayed(
			"CB 1234567",
			in: field,
			of: .passport,
		)
		field.typeKey(
			"d",
			modifierFlags: .control,
		)
		assertValue(
			"C1234567",
			of: .passport,
		)
		field.typeText( "d" )
		assertDisplayed(
			"CD 1234567",
			in: field,
			of: .passport,
		)

	}

	func assertCharacterLimitWithoutMask() {

		guard let field = focusedField( .plain ) else { return }

		let text = String( "123456789".prefix( AID.plainCharacterLimit ) )

		for ( index, character ) in text.enumerated() {
			field.typeText( String( character ) )
			assertDisplayed(
				String( text.prefix( index + 1 ) ),
				in: field,
				of: .plain,
			)
		}

		assertValue(
			text,
			of: .plain,
		)

		field.typeText( "7" )
		assertUnchanged(
			text,
			in: field,
			of: .plain,
		)
		assertValue(
			text,
			of: .plain,
		)
	}

	func assertBlockedFieldIgnoresInput() {

		let card = AID.blockedCard

		guard let field = focusedField( .blocked ) else { return }

		field.typeText( "9" )
		assertUnchanged(
			"8600 1234 1234 1234",
			in: field,
			of: .blocked,
		)
		assertValue(
			card,
			of: .blocked,
		)

		field.typeText( XCUIKeyboardKey.delete.rawValue )
		assertUnchanged(
			"8600 1234 1234 1234",
			in: field,
			of: .blocked,
		)
		assertValue(
			card,
			of: .blocked,
		)
	}

	func assertMaskIsHiddenWhileFieldIsEmpty() {

		guard let field = field( .hiddenMask ) else { return }

		let prefix = maskPrefixLabel
		guard prefix.waitForExistence( timeout: 5 ) else {
			XCTFail( "Mask prefix label was not found. \( screenDump() )" )
			return
		}

		let hidden = prefix.screenshot().pngRepresentation

		field.tap()

		guard app.keyboards.element.waitForExistence( timeout: 10 ) else {
			XCTFail( "Keyboard did not appear for hiddenMask. \( screenDump() )" )
			return
		}

		Thread.sleep( forTimeInterval: 1 )

		XCTAssertNotEqual(
			prefix.screenshot().pngRepresentation,
			hidden,
			"The prefix must be hidden while empty and unfocused, "
				+ "and appear on focus; both screenshots "
				+ "are identical",
		)
	}
}

private extension MaskedTextFieldUITests {

	typealias AID = MaskedTextFieldID

	func field( _ variant: AID.Variant ) -> XCUIElement? {

		guard tapButton(
			AID.variant( variant ),
			name: variant.rawValue,
		) else { return nil }

		let field = app.textFields[ AID.field( variant ) ]
		guard field.waitForExistence( timeout: 10 ) else {
			XCTFail( "Field «\( variant.rawValue )» did not appear. \( screenDump() )" )
			return nil
		}

		return field
	}

	func focusedField( _ variant: AID.Variant ) -> XCUIElement? {

		guard let field = field( variant ) else { return nil }

		field.tap()

		guard app.keyboards.element.waitForExistence( timeout: 10 ) else {
			XCTFail(
				"Keyboard for field «\( variant.rawValue )» did not appear. \( screenDump() )",
			)
			return nil
		}

		return field
	}

	var maskPrefixLabel: XCUIElement {
		app.staticTexts
			.matching( NSPredicate(
				format: "label BEGINSWITH %@",
				"+998",
			) )
			.firstMatch
	}

	@discardableResult
	func tapButton( _ identifier: String, name: String ) -> Bool {

		let button = app.buttons[ identifier ]
		guard button.exists || button.waitForExistence( timeout: 10 ) else {
			XCTFail( "Button «\( name )» was not found. \( screenDump() )" )
			return false
		}

		button.tap()
		return true
	}
}

private extension MaskedTextFieldUITests {

	func assertDisplayed(
		_ expected: String,
		in field: XCUIElement,
		of variant: AID.Variant,
	) {

		let displayed = waitFor( expected ) { field.value as? String ?? "" }

		XCTAssertEqual(
			displayed,
			expected,
			"Field «\( variant.rawValue )» should display «\( expected )», "
				+ "but displays «\( displayed )»",
		)
	}

	func assertValue(
		_ expected: String,
		of variant: AID.Variant,
	) {

		let label = app.staticTexts[ AID.value( variant ) ]
		let value = waitFor( "«\( expected )»" ) { label.label }

		XCTAssertEqual(
			value,
			"«\( expected )»",
			"Value for field «\( variant.rawValue )» should be «\( expected )», "
				+ "but is \( value )",
		)
	}

	func assertUnchanged(
		_ expected: String,
		in field: XCUIElement,
		of variant: AID.Variant,
	) {

		Thread.sleep( forTimeInterval: 0.5 )

		let displayed = field.value as? String ?? ""

		XCTAssertEqual(
			displayed,
			expected,
			"Edit of field «\( variant.rawValue )» must be rejected: "
				+ "expected «\( expected )», displayed «\( displayed )»",
		)
	}

	func waitFor(
		_ expected: String,
		timeout: TimeInterval = 5,
		reading value: () -> String,
	) -> String {

		let deadline = Date().addingTimeInterval( timeout )
		var current = value()

		while current != expected, Date() < deadline {
			Thread.sleep( forTimeInterval: 0.1 )
			current = value()
		}

		return current
	}
}

private extension MaskedTextFieldUITests {

	func launchApp() {
		app = launch( .maskedTextField )
	}

	func screenDump() -> String {

		let buttons = app.buttons.allElementsBoundByIndex
			.prefix( 20 )
			.map { "«\( $0.label )» [\( $0.identifier )]" }

		let fields = app.textFields.allElementsBoundByIndex
			.prefix( 10 )
			.map { "«\( $0.value as? String ?? "" )» [\( $0.identifier )]" }

		let texts = app.staticTexts.allElementsBoundByIndex
			.prefix( 20 )
			.map( \.label )

		return "Buttons: \( buttons ). Fields: \( fields ). Texts: \( texts )"
	}
}

private extension MaskedTextFieldUITests {

	func assertField(
		_ value: String,
		displayed: String?,
		in field: XCUIElement,
		of variant: AID.Variant,
	) {
		assertDisplayed(
			displayed ?? value,
			in: field,
			of: variant,
		)
		assertValue(
			value,
			of: variant,
		)
	}

	func assertEdit(
		_ input: String,
		value: String,
		displayed: String?,
		in field: XCUIElement,
		of variant: AID.Variant,
	) {
		field.typeText( input )
		assertField(
			value,
			displayed: displayed,
			in: field,
			of: variant,
		)
	}

	func moveCaret(
		_ count: Int,
		in field: XCUIElement,
		selecting: Bool = false,
	) {
		for _ in 0..<count {
			field.typeKey(
				XCUIKeyboardKey.leftArrow.rawValue,
				modifierFlags: selecting ? .shift : [],
			)
		}
	}

	func resetFixture( _ field: XCUIElement ) {
		tapButton(
			"masked_text_field_demo_reset",
			name: "Reset",
		)
		field.tap()
		let length = ( field.value as? String ?? "" ).count
		for _ in 0..<length {
			field.typeKey(
				XCUIKeyboardKey.rightArrow.rawValue,
				modifierFlags: [],
			)
		}
	}

	func paste( _ text: String ) {
		tapButton(
			"masked_text_field_demo_paste_" + text,
			name: "Paste sample",
		)
	}
}
