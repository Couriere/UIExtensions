import SwiftUI
import UIExtensions

struct TabContainerScreen: View {
	@State private var selection = 1
	@State private var includesSecondTab = true

	var body: some View {
		VStack {
			HStack {
				Button( "First" ) { selection = 1 }
					.accessibilityIdentifier( TabContainerID.firstTab )
				Button( "Second" ) { selection = 2 }
					.accessibilityIdentifier( TabContainerID.secondTab )
					.disabled( !includesSecondTab )
				Button( includesSecondTab ? "Remove second" : "Add second" ) {
					if includesSecondTab { selection = 1 }
					includesSecondTab.toggle()
				}
				.accessibilityIdentifier( TabContainerID.toggleSecondTab )
			}

			TabContainer( selection: $selection ) {
				TabCounter( tab: 1 )
					.tabTag( 1 )
				if includesSecondTab {
					TabCounter( tab: 2 )
						.tabTag( 2 )
				}
			}
		}
	}
}

private struct TabCounter: View {
	let tab: Int
	@State private var count = 0

	var body: some View {
		VStack {
			Text( "Tab \( tab ): \( count )" )
				.accessibilityIdentifier( tab == 1 ? TabContainerID.firstCount : TabContainerID.secondCount )
			Spacer()
			Button( "Increment" ) { count += 1 }
				.accessibilityIdentifier( tab == 1 ? TabContainerID.incrementFirst : TabContainerID.incrementSecond )
		}
		.frame( maxWidth: .infinity, maxHeight: .infinity )
	}
}
