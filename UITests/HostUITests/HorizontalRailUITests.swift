import XCTest

@MainActor
final class HorizontalRailUITests: XCTestCase {

	func testSelectionDrivesScrollingAndProgress() {
		let app = launchRail()
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "2.00" )
		app.buttons[ HorizontalRailID.select ].tap()
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "4.00" )
		XCTAssertEqual( app.staticTexts[ HorizontalRailID.item( 5 )].frame.minX,
			app.scrollViews[ HorizontalRailID.rail ].frame.minX + 16, accuracy: 1 )
	}

	func testSwipeUpdatesSelectionAndProgress() {
		let app = launchRail()
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "2.00" )
		app.scrollViews[ HorizontalRailID.rail ].swipeLeft()
		XCTAssertTrue( app.staticTexts[ HorizontalRailID.selection ]
			.wait( for: \.label, toEqual: "Selection: 4", timeout: 5 ))
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "3.00" )
	}

	func testFixedColumnsReserveSpaceForNextItem() {
		let app = launchRail( .fixedColumns )
		let first = app.staticTexts[ HorizontalRailID.item( 1 )]
		let second = app.staticTexts[ HorizontalRailID.item( 2 )]
		assertExists( first )
		XCTAssertEqual( first.frame.width, 128, accuracy: 1 )
		XCTAssertEqual( second.frame.minX - first.frame.maxX, 8, accuracy: 1 )
		XCTAssertTrue( app.staticTexts[ HorizontalRailID.item( 3 )].isHittable )
	}

	func testAdaptiveColumnsRespectMaximumWidth() {
		let app = launchRail( .adaptiveColumns )
		let first = app.staticTexts[ HorizontalRailID.item( 1 )]
		assertExists( first )
		XCTAssertEqual( first.frame.width, 272.0 / 3, accuracy: 1 )
		XCTAssertTrue( app.staticTexts[ HorizontalRailID.item( 3 )].isHittable )
	}

	/// Before iOS 27 centering widens the content, so the same rail must still scroll once it overflows.
	func testCenteredRailCentersUnderflowAndScrollsWhenOverflowing() {
		let app = launchRail( .centered )
		let rail = app.scrollViews[ HorizontalRailID.rail ]
		let first = app.staticTexts[ HorizontalRailID.item( 1 )]
		assertExists( first )
		XCTAssertEqual( first.frame.midX, rail.frame.midX, accuracy: 1 )
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "0.00" )

		// Six items of three columns overflow; scrolling to item 5 stops at the end with item 4 leading.
		app.buttons[ HorizontalRailID.replace ].tap()
		app.buttons[ HorizontalRailID.select ].tap()
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "3.00" )
		XCTAssertEqual( app.staticTexts[ HorizontalRailID.item( 6 )].frame.maxX, rail.frame.maxX - 16, accuracy: 1 )
	}

	/// On iOS 26 the centering inset used to shrink the length items are sized from,
	/// switching adaptive columns between 3 and 2 on every layout pass and hanging the app.
	func testCenteredAdaptiveUnderflowKeepsStableWidths() {
		let app = launchRail( .centeredAdaptive )
		let first = app.staticTexts[ HorizontalRailID.item( 1 )]
		assertExists( first )
		XCTAssertEqual( first.frame.width, 90.67, accuracy: 1 )
		XCTAssertEqual( app.staticTexts[ HorizontalRailID.item( 2 )].frame.width, 90.67, accuracy: 1 )
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "0.00" )
	}

	func testIntrinsicItemKeepsItsOwnWidth() {
		let app = launchRail( .intrinsic )
		let first = app.staticTexts[ HorizontalRailID.item( 1 )]
		assertExists( first )
		XCTAssertEqual( first.frame.width, 64, accuracy: 1 )
		XCTAssertEqual( app.staticTexts[ HorizontalRailID.item( 2 )].frame.width, 288, accuracy: 1 )
	}

	func testOnChangedScrollsOnAppearanceAndWhenIdentifiersChange() {
		let app = launchRail( .onChanged )
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "2.00" )
		app.buttons[ HorizontalRailID.select ].tap()
		assertLabel( app.staticTexts[ HorizontalRailID.selection ], "Selection: 5" )
		assertProgressDoesNotChange( in: app, from: "2.00" )
		app.buttons[ HorizontalRailID.replace ].tap()
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "0.00" )
		XCTAssertTrue( app.staticTexts[ HorizontalRailID.item( 5 )].isHittable )
	}

	func testNeverDoesNotScrollToSelection() {
		let app = launchRail( .never )
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "0.00" )
		app.buttons[ HorizontalRailID.select ].tap()
		assertLabel( app.staticTexts[ HorizontalRailID.selection ], "Selection: 5" )
		assertProgressDoesNotChange( in: app, from: "0.00" )
		XCTAssertTrue( app.staticTexts[ HorizontalRailID.item( 1 )].isHittable )
	}

	func testEmptyRailReportsZeroProgress() {
		let app = launchRail( .empty )
		assertLabel( app.staticTexts[ HorizontalRailID.progress ], "0.00" )
		XCTAssertFalse( app.staticTexts[ HorizontalRailID.item( 1 )].exists )
	}

	private func launchRail( _ variant: HorizontalRailID.Variant = .standard ) -> XCUIApplication {
		launch( .horizontalRail, arguments: [ HorizontalRailID.variantArgument, variant.rawValue ])
	}

	private func assertProgressDoesNotChange( in app: XCUIApplication, from value: String ) {
		let changed = XCTNSPredicateExpectation(
			predicate: NSPredicate( format: "label != %@", value ),
			object: app.staticTexts[ HorizontalRailID.progress ]
		)
		changed.isInverted = true
		wait( for: [changed], timeout: 1 )
	}
}
