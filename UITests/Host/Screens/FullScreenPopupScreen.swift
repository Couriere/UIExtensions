import SwiftUI
import UIExtensions

struct FullScreenPopupScreen: View {
	enum Variant { case boolean, item }
	struct PopupItem: Identifiable { let id: Int }

	let variant: Variant
	@State private var isPresented = false
	@State private var item: PopupItem?
	@State private var dismissCount = 0

	var body: some View {
		VStack( spacing: 24 ) {
			Text( "Dismissed: \( dismissCount )" )
				.accessibilityIdentifier( FullScreenPopupID.dismissCount )
			if variant == .boolean {
				Button( "Show popup" ) { isPresented = true }
					.accessibilityIdentifier( FullScreenPopupID.show )
			} else {
				Button( "Show item" ) { item = PopupItem( id: 1 ) }
					.accessibilityIdentifier( FullScreenPopupID.showItem )
			}
		}
		.fullScreenCover(
			isPresented: $isPresented,
			onDismiss: { dismissCount += 1 },
			transitionStyle: .crossDissolve
		) {
			popup( number: 0 ) { isPresented = false }
		}
		.fullScreenCover(
			item: $item,
			onDismiss: { dismissCount += 1 },
			transitionStyle: .crossDissolve
		) { value in
			popup( number: value.id ) { item = nil }
		}
	}

	private func popup( number: Int, dismiss: @escaping () -> Void ) -> some View {
		VStack( spacing: 24 ) {
			Text( "Popup \( number )" )
				.accessibilityIdentifier( FullScreenPopupID.popup )
			Button( "Dismiss" , action: dismiss )
				.accessibilityIdentifier( FullScreenPopupID.dismiss )
			if number > 0 {
				Button( "Replace item" ) { item = PopupItem( id: number + 1 ) }
					.accessibilityIdentifier( FullScreenPopupID.replace )
			}
		}
	}
}
