import XCTest

@MainActor
final class FullScreenPopupUITests: XCTestCase {
	func testBooleanPopupOpensDismissesAndCanOpenAgain() {
		let app = launch( .fullScreenPopup )
		let popup = app.staticTexts[ FullScreenPopupID.popup ]
		let show = app.buttons[ FullScreenPopupID.show ]
		let dismiss = app.buttons[ FullScreenPopupID.dismiss ]

		show.tap()
		assertLabel( popup, "Popup 0" )
		dismiss.tap()
		assertNotExists( popup )
		assertLabel( app.staticTexts[ FullScreenPopupID.dismissCount ], "Dismissed: 1" )

		show.tap()
		assertLabel( popup, "Popup 0" )
		dismiss.tap()
		assertLabel( app.staticTexts[ FullScreenPopupID.dismissCount ], "Dismissed: 2" )
	}

	func testItemPopupReplacesContentAndDismisses() {
		let app = launch( .fullScreenPopupItem )
		app.buttons[ FullScreenPopupID.showItem ].tap()
		assertLabel( app.staticTexts[ FullScreenPopupID.popup ], "Popup 1" )

		app.buttons[ FullScreenPopupID.replace ].tap()
		assertLabel( app.staticTexts[ FullScreenPopupID.popup ], "Popup 2" )
		app.buttons[ FullScreenPopupID.dismiss ].tap()

		assertNotExists( app.staticTexts[ FullScreenPopupID.popup ] )
		assertLabel( app.staticTexts[ FullScreenPopupID.dismissCount ], "Dismissed: 1" )
	}
}
