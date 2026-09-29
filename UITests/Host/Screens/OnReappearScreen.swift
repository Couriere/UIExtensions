import SwiftUI
import UIExtensions

struct OnReappearScreen: View {
	@State private var syncCount = 0
	@State private var asyncCount = 0

	var body: some View {
		NavigationStack {
			List {
				Text( "Sync: \( syncCount )" )
					.accessibilityIdentifier( OnReappearID.syncCount )
				Text( "Async: \( asyncCount )" )
					.accessibilityIdentifier( OnReappearID.asyncCount )
				NavigationLink( "Open details" ) {
					Text( "Details" )
						.accessibilityIdentifier( OnReappearID.details )
				}
				.accessibilityIdentifier( OnReappearID.openDetails )
			}
			.onReappear { syncCount += 1 }
			.onReappear {
				await Task.yield()
				asyncCount += 1
			}
			.navigationTitle( "onReappear" )
		}
	}
}
