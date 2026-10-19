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
import UIExtensions

struct MaskedTextFieldScreen: View {

	@State private var variant: Variant = .phone

	@State private var phone: String = ""
	@State private var date: String = ""
	@State private var passport: String = ""
	@State private var plain: String = ""
	@State private var card: String = MaskedTextFieldID.blockedCard
	@State private var hiddenMaskPhone: String = ""

	var body: some View {

		VStack( spacing: 12 ) {

			variantPicker

			field
				.font( .body )
				.padding( .horizontal, 12 )
				.frame( height: 48 )
				.overlay(
					RoundedRectangle( cornerRadius: 12 )
						.stroke( .gray.opacity( 0.4 ), lineWidth: 1 ),
				)

			Text( verbatim: "«\( value )»" )
				.accessibilityIdentifier( "masked_text_field_demo_value_\( variant.rawValue )" )

			externalValueButtons

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

		var id: String { rawValue }

		var title: String {
			switch self {
			case .phone: "Phone"
			case .date: "Date"
			case .passport: "Passport"
			case .plain: "Plain"
			case .blocked: "Blocked"
			case .hiddenMask: "Hidden mask"
			}
		}
	}
}

private extension MaskedTextFieldScreen {

	var variantPicker: some View {

		LazyVGrid(
			columns: Array( repeating: GridItem( .flexible() ), count: 3 ),
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
			MaskedTextField( text: $phone, mask: "+998 ## ### ## ##" )
				.accessibilityIdentifier( fieldIdentifier )

		case .date:
			MaskedTextField( text: $date, mask: "##.##.####" )
				.maskFillSymbol( "_" )
				.accessibilityIdentifier( fieldIdentifier )

		case .passport:
			MaskedTextField( text: $passport, mask: "** #######" )
				.inputFilter { $0.uppercased() }
				.accessibilityIdentifier( fieldIdentifier )

		case .plain:
			MaskedTextField( text: $plain )
				.characterLimit( MaskedTextFieldID.plainCharacterLimit )
				.trailingText( " units" )
				.accessibilityIdentifier( fieldIdentifier )

		case .blocked:
			MaskedTextField( text: $card, mask: "#### #### #### ####" )
				.allowsInput( false )
				.accessibilityIdentifier( fieldIdentifier )

		case .hiddenMask:
			MaskedTextField( text: $hiddenMaskPhone, mask: "+998 ## ### ## ##" )
				.hidesMaskWhenEmpty()
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
