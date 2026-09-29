import XCTest

@MainActor
final class AsyncButtonUITests: XCTestCase {
	func testButtonDisablesDuringActionAndEnablesAfterCompletion() {
		let app = launch( .asyncButton )
		let button = app.buttons[ AsyncButtonID.button ]
		XCTAssertTrue( button.isEnabled )

		button.tap()
		assertLabel( app.staticTexts[ AsyncButtonID.started ], "Started: 1" )
		assertLabel( app.staticTexts[ AsyncButtonID.pending ], "Pending: 1" )
		XCTAssertFalse( button.isEnabled )
		assertLabel( app.staticTexts[ AsyncButtonID.started ], "Started: 1" )

		app.buttons[ AsyncButtonID.complete ].tap()
		assertLabel( app.staticTexts[ AsyncButtonID.completed ], "Completed: 1" )
		assertLabel( app.staticTexts[ AsyncButtonID.pending ], "Pending: 0" )
		XCTAssertTrue( button.isEnabled )
	}

	func testActionCancelsWhenButtonDisappears() {
		let app = launch( .asyncButton )
		app.buttons[ AsyncButtonID.button ].tap()
		assertLabel( app.staticTexts[ AsyncButtonID.pending ], "Pending: 1" )

		app.buttons[ AsyncButtonID.openDetails ].tap()
		assertExists( app.staticTexts[ AsyncButtonID.details ] )
		app.navigateBack()

		assertLabel( app.staticTexts[ AsyncButtonID.cancelled ], "Cancelled: 1" )
		assertLabel( app.staticTexts[ AsyncButtonID.pending ], "Pending: 0" )
		assertLabel( app.staticTexts[ AsyncButtonID.completed ], "Completed: 0" )
	}

	func testActionContinuesWhenCancellationOnDisappearIsDisabled() {
		let app = launch( .asyncButtonKeepsRunning )
		app.buttons[ AsyncButtonID.button ].tap()
		assertLabel( app.staticTexts[ AsyncButtonID.pending ], "Pending: 1" )

		app.buttons[ AsyncButtonID.openDetails ].tap()
		assertExists( app.staticTexts[ AsyncButtonID.details ] )
		app.navigateBack()

		assertLabel( app.staticTexts[ AsyncButtonID.cancelled ], "Cancelled: 0" )
		assertLabel( app.staticTexts[ AsyncButtonID.pending ], "Pending: 1" )
		app.buttons[ AsyncButtonID.complete ].tap()
		assertLabel( app.staticTexts[ AsyncButtonID.completed ], "Completed: 1" )
	}
}
