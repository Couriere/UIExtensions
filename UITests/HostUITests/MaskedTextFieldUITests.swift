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

	func testForwardDeleteBeforeSeparatorAfterFifthDigit() {
		assertForwardDeleteBeforeSeparator(
			leftArrowCount: 6,
			displayed: "12 345 78 9",
			value: "12345789",
			afterInsertion: "12 345 07 89",
		)
	}

	func testForwardDeleteBeforeSeparatorAfterSeventhDigit() {
		assertForwardDeleteBeforeSeparator(
			leftArrowCount: 3,
			displayed: "12 345 67 9",
			value: "12345679",
			afterInsertion: "12 345 67 09",
		)
	}

	func testForwardDeleteKeepsCaretPosition() {

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
			assertDisplayed( displayed, in: field, of: .phone )
		}

		for _ in 0..<4 {
			field.typeKey( XCUIKeyboardKey.leftArrow.rawValue, modifierFlags: [] )
		}
		field.typeKey( "d", modifierFlags: .control )
		assertDisplayed( "12 356", in: field, of: .phone )
		assertValue( "12356", of: .phone )

		field.typeText( "9" )
		assertDisplayed( "12 395 6", in: field, of: .phone )
		assertValue( "123956", of: .phone )
	}

	func testMaskedTextFieldInput() {

		launchApp()

		assertMaskFormatsTypedCharacters()
		assertOverflowIsRejected()
		assertDeletionRemovesCharactersOneByOne()
		assertExternalValueIsEditable()
		assertSeparatorIsInsertedAutomatically()
		assertInputFilterAndTokenKinds()
		assertCharacterLimitWithoutMask()
		assertBlockedFieldIgnoresInput()
		assertMaskIsHiddenWhileFieldIsEmpty()
	}
}

private extension MaskedTextFieldUITests {

	func assertForwardDeleteBeforeSeparator(
		leftArrowCount: Int,
		displayed: String,
		value: String,
		afterInsertion: String,
	) {
		launchApp()
		guard let field = focusedField( .phone ) else { return }

		let steps = [
			"1", "12", "12 3", "12 34", "12 345", "12 345 6",
			"12 345 67", "12 345 67 8", "12 345 67 89",
		]
		for ( digit, expected ) in zip( "123456789", steps ) {
			field.typeText( String( digit ) )
			assertDisplayed( expected, in: field, of: .phone )
		}
		for _ in 0..<leftArrowCount {
			field.typeKey( XCUIKeyboardKey.leftArrow.rawValue, modifierFlags: [] )
		}
		field.typeKey( "d", modifierFlags: .control )
		assertDisplayed( displayed, in: field, of: .phone )
		assertValue( value, of: .phone )

		field.typeText( "0" )
		assertDisplayed( afterInsertion, in: field, of: .phone )
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
			assertDisplayed( displayed, in: field, of: .phone )
		}

		assertValue( "931331400", of: .phone )
	}

	func assertOverflowIsRejected() {

		guard let field = focusedField( .phone ) else { return }

		field.typeText( "5" )

		assertUnchanged( "93 133 14 00", in: field, of: .phone )
		assertValue( "931331400", of: .phone )
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
			assertDisplayed( displayed, in: field, of: .phone )
			assertValue( value, of: .phone )
		}

		field.typeText( XCUIKeyboardKey.delete.rawValue )
		assertUnchanged( "", in: field, of: .phone )
		assertValue( "", of: .phone )
	}

	func assertExternalValueIsEditable() {

		guard let field = field( .phone ) else { return }

		guard tapButton( AID.fillPhone, name: "Set external value" ) else { return }

		assertDisplayed( "93 133 14 00", in: field, of: .phone )
		assertValue( AID.externalPhone, of: .phone )

		field.tap()
		field.typeText( XCUIKeyboardKey.delete.rawValue )
		assertDisplayed( "93 133 14 0", in: field, of: .phone )

		field.typeText( "5" )
		assertDisplayed( "93 133 14 05", in: field, of: .phone )
		assertValue( "931331405", of: .phone )

		guard tapButton( AID.clearPhone, name: "Clear" ) else { return }

		assertDisplayed( "", in: field, of: .phone )
		assertValue( "", of: .phone )
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
			assertDisplayed( displayed, in: field, of: .date )
			assertValue( value, of: .date )
		}
	}

	func assertInputFilterAndTokenKinds() {

		guard let field = focusedField( .passport ) else { return }

		field.typeText( "a" )
		assertDisplayed( "A", in: field, of: .passport )

		field.typeText( "b" )
		assertDisplayed( "AB", in: field, of: .passport )
		assertValue( "AB", of: .passport )

		for letter in [ "c", "d" ] {
			field.typeText( letter )
			assertUnchanged( "AB", in: field, of: .passport )
		}
		assertValue( "AB", of: .passport )

		let digits = "1234567"

		for ( index, digit ) in digits.enumerated() {
			field.typeText( String( digit ) )
			assertDisplayed( "AB \( digits.prefix( index + 1 ) )", in: field, of: .passport )
		}

		assertValue( "AB1234567", of: .passport )
	}

	func assertCharacterLimitWithoutMask() {

		guard let field = focusedField( .plain ) else { return }

		let text = String( "123456789".prefix( AID.plainCharacterLimit ) )

		for ( index, character ) in text.enumerated() {
			field.typeText( String( character ) )
			assertDisplayed( String( text.prefix( index + 1 ) ), in: field, of: .plain )
		}

		assertValue( text, of: .plain )

		field.typeText( "7" )
		assertUnchanged( text, in: field, of: .plain )
		assertValue( text, of: .plain )
	}

	func assertBlockedFieldIgnoresInput() {

		let card = AID.blockedCard

		guard let field = focusedField( .blocked ) else { return }

		field.typeText( "9" )
		assertUnchanged( "8600 1234 1234 1234", in: field, of: .blocked )
		assertValue( card, of: .blocked )

		field.typeText( XCUIKeyboardKey.delete.rawValue )
		assertUnchanged( "8600 1234 1234 1234", in: field, of: .blocked )
		assertValue( card, of: .blocked )
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

		guard tapButton( AID.variant( variant ), name: variant.rawValue ) else { return nil }

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
			.matching( NSPredicate( format: "label BEGINSWITH %@", "+998" ) )
			.firstMatch
	}

	@discardableResult
	func tapButton( _ identifier: String, name: String ) -> Bool {

		let button = app.buttons[ identifier ]
		guard button.waitForExistence( timeout: 10 ) else {
			XCTFail( "Button «\( name )» was not found. \( screenDump() )" )
			return false
		}

		button.tap()
		return true
	}
}

private extension MaskedTextFieldUITests {

	func assertDisplayed( _ expected: String, in field: XCUIElement, of variant: AID.Variant ) {

		let displayed = waitFor( expected ) { field.value as? String ?? "" }

		XCTAssertEqual(
			displayed,
			expected,
			"Field «\( variant.rawValue )» should display «\( expected )», "
				+ "but displays «\( displayed )»",
		)
	}

	func assertValue( _ expected: String, of variant: AID.Variant ) {

		let label = app.staticTexts[ AID.value( variant ) ]
		let value = waitFor( "«\( expected )»" ) { label.label }

		XCTAssertEqual(
			value,
			"«\( expected )»",
			"Value for field «\( variant.rawValue )» should be «\( expected )», "
				+ "but is \( value )",
		)
	}

	func assertUnchanged( _ expected: String, in field: XCUIElement, of variant: AID.Variant ) {

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
			.map(\.label)

		return "Buttons: \( buttons ). Fields: \( fields ). Texts: \( texts )"
	}
}
