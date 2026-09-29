import XCTest

@MainActor
final class OnReappearUITests: XCTestCase {
	func testActionsSkipFirstAppearanceAndRunOnEveryReturn() {
		let app = launch( .onReappear )
		let syncCount = app.staticTexts[ OnReappearID.syncCount ]
		let asyncCount = app.staticTexts[ OnReappearID.asyncCount ]

		assertLabel( syncCount, "Sync: 0" )
		assertLabel( asyncCount, "Async: 0" )

		for count in 1...2 {
			app.buttons[ OnReappearID.openDetails ].tap()
			assertExists( app.staticTexts[ OnReappearID.details ] )
			app.navigateBack()

			assertLabel( syncCount, "Sync: \( count )" )
			assertLabel( asyncCount, "Async: \( count )" )
		}
	}
}
