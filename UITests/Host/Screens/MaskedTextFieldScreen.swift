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
import UIKit
import UIExtensions

struct MaskedTextFieldScreen: View {

	@State private var variant: Variant = .phone

	@State private var phone: String = ""
	@State private var date: String = ""
	@State private var passport: String = ""
	@State private var plain: String = ""
	@State private var card: String = MaskedTextFieldID.blockedCard
	@State private var hiddenMaskPhone: String = ""
	@State private var number: String = ""
	@State private var transformed: String = "abCD"
	@State private var replacement: String = "1234"
	@State private var rejectsEdits: Bool = false

	var body: some View {

		VStack( spacing: 12 ) {

			variantPicker

			field
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

			Text( verbatim: "«\( value )»" )
				.accessibilityIdentifier( "masked_text_field_demo_value_\( variant.rawValue )" )

			externalValueButtons

			editingButtons

			Spacer()
		}
		.padding()
		.navigationTitle( "MaskedTextField" )
		.navigationBarTitleDisplayMode( .inline )
	}
}

extension MaskedTextFieldScreen {

	enum Variant: String, CaseIterable, Identifiable {

		case phone
		case date
		case passport
		case plain
		case blocked
		case hiddenMask
		case number
		case transformed
		case replacement

		var id: String { rawValue }

		var title: String {
			switch self {
			case .phone: "Phone"
			case .date: "Date"
			case .passport: "Passport"
			case .plain: "Plain"
			case .blocked: "Blocked"
			case .hiddenMask: "Hidden mask"
			case .number: "Number"
			case .transformed: "Transform"
			case .replacement: "Replace all"
			}
		}
	}
}

private extension MaskedTextFieldScreen {

	var variantPicker: some View {

		LazyVGrid(
			columns: Array(
				repeating: GridItem( .flexible() ),
				count: 3,
			),
			spacing: 8,
		) {
			ForEach( Variant.allCases ) { item in
				Button( item.title ) {
					variant = item
				}
				.accessibilityIdentifier( "masked_text_field_demo_variant_\( item.rawValue )" )
				.buttonStyle( .bordered )
				.tint( item == variant ? .purple : .gray )
			}
		}
		.font( .caption )
	}

	@ViewBuilder
	var field: some View {

		switch variant {
		case .phone:
			MaskedTextField(
				text: $phone,
				mode: .masked( "+998 ## ### ## ##" ),
			)
			.accessibilityIdentifier( fieldIdentifier )

		case .date:
			MaskedTextField(
				text: $date,
				mode: .masked( "##.##.####" ),
			)
			.maskedTextFieldMaskFillSymbol( "_" )
			.accessibilityIdentifier( fieldIdentifier )

		case .passport:
			VStack {
				MaskedTextField(
					text: $passport,
					mode: .masked( "** #######" ),
				)
				.accessibilityIdentifier( fieldIdentifier )
				.maskedTextFieldOnInputChange { _, _, replacement in
					.accept( replacement: replacement.uppercased() )
				}
			}
			.maskedTextFieldOnInputChange { _, _, _ in .reject }

		case .plain:
			MaskedTextField(
				text: $plain,
				mode: .plain( characterLimit: MaskedTextFieldID.plainCharacterLimit ),
			)
			.maskedTextFieldTrailingText( " units" )
			.accessibilityIdentifier( fieldIdentifier )

		case .blocked:
			MaskedTextField(
				text: $card,
				mode: .masked( "#### #### #### ####" ),
			)
			.maskedTextFieldInputDisabled()
			.accessibilityIdentifier( fieldIdentifier )

		case .hiddenMask:
			MaskedTextField(
				text: $hiddenMaskPhone,
				mode: .masked( "+998 ## ### ## ##" ),
			)
			.maskedTextFieldHidesMaskWhenEmpty()
			.accessibilityIdentifier( fieldIdentifier )

		case .number:
			MaskedTextField(
				text: $number,
				mode: .groupedInteger( characterLimit: 6 ),
			)
			.maskedTextFieldOnInputChange { _, _, inserted in
				switch inserted {
				case "r": .replaceAll( "000000012" )
				case "i": .replaceAll( "-1" )
				case "o": .replaceAll( "1234567" )
				default: .accept
				}
			}
			.accessibilityIdentifier( fieldIdentifier )

		case .transformed:
			MaskedTextField(
				text: $transformed,
				mode: .plain( characterLimit: 8 ),
			)
			.maskedTextFieldOnInputChange { _, _, inserted in
				if rejectsEdits { return .reject }
				// UIKit smart paste may add spaces around clipboard fragments.
				switch inserted.trimmingCharacters( in: .whitespaces ) {
				case "x": return .accept( replacement: "XYZ" )
				case "shrink": return .accept( replacement: "q" )
				case "drop": return .accept( replacement: "" )
				case "12": return .accept( replacement: "12" )
				default: return .accept
				}
			}
			.accessibilityIdentifier( fieldIdentifier )

		case .replacement:
			MaskedTextField(
				text: $replacement,
				mode: .masked( "+998 ## ### ## ##" ),
			)
			.maskedTextFieldOnInputChange { _, _, inserted in
				switch inserted {
				case "r": return .replaceAll( "98765432" )
				case "i": return .replaceAll( "invalid" )
				case "o": return .replaceAll( "1234567890" )
				default:
					let digits = inserted.filter { $0.isASCII && $0.isNumber }
					if digits.count == 12, digits.hasPrefix( "998" ) {
						return .replaceAll( String( digits.suffix( 9 ) ) )
					}
					return .accept
				}
			}
			.accessibilityIdentifier( fieldIdentifier )
		}
	}

	@ViewBuilder
	var externalValueButtons: some View {

		if variant == .phone {

			HStack( spacing: 12 ) {

				Button( "Set external value" ) {
					phone = MaskedTextFieldID.externalPhone
				}
				.accessibilityIdentifier( "masked_text_field_demo_fill_phone" )

				Button( "Clear" ) {
					phone = ""
				}
				.accessibilityIdentifier( "masked_text_field_demo_clear_phone" )
			}
			.font( .caption )
			.buttonStyle( .bordered )
		}
	}

	@ViewBuilder
	var editingButtons: some View {
		if variant == .number || variant == .transformed || variant == .replacement {
			HStack {
				Button( "Reset" ) {
					number = ""
					transformed = "abCD"
					replacement = "1234"
					rejectsEdits = false
				}
				.accessibilityIdentifier( "masked_text_field_demo_reset" )

				if variant == .transformed {
					Button( rejectsEdits ? "Allow edits" : "Reject edits" ) {
						rejectsEdits.toggle()
					}
					.accessibilityIdentifier( "masked_text_field_demo_reject" )
				}
			}
			.buttonStyle( .bordered )
		}

		if variant == .transformed || variant == .replacement || variant == .phone || variant == .number {
			HStack {
				if variant == .number {
					pasteButton( "000000123456" )
				} else if variant == .transformed {
					pasteButton( "shrink" )
					pasteButton( "drop" )
					pasteButton( "12" )
					pasteButton( "1234567890" )
				} else {
					pasteButton( "+998 93 123 45 67" )
					pasteButton( "93 123 45 67" )
					pasteButton( "1234567890" )
				}
			}
			.font( .caption2 )
			.buttonStyle( .bordered )
		}
	}

	func pasteButton( _ text: String ) -> some View {
		Button( text ) {
			UIPasteboard.general.string = text
			UIApplication.shared.sendAction(
				#selector( UIResponder.paste( _: ) ),
				to: nil,
				from: nil,
				for: nil,
			)
		}
		.accessibilityIdentifier( "masked_text_field_demo_paste_" + text )
	}

	var fieldIdentifier: String {
		"masked_text_field_demo_field_\( variant.rawValue )"
	}

	var value: String {
		switch variant {
		case .phone: phone
		case .date: date
		case .passport: passport
		case .plain: plain
		case .blocked: card
		case .hiddenMask: hiddenMaskPhone
		case .number: number
		case .transformed: transformed
		case .replacement: replacement
		}
	}
}

#if DEBUG
#Preview {
	NavigationStack {
		MaskedTextFieldScreen()
	}
}
#endif
