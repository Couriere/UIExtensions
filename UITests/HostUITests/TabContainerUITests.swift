import XCTest

@MainActor
final class TabContainerUITests: XCTestCase {
	func testSwitchingTabsPreservesStateAndHidesInactiveContent() {
		let app = launch( .tabContainer )
		let firstCount = app.staticTexts[ TabContainerID.firstCount ]
		let secondCount = app.staticTexts[ TabContainerID.secondCount ]

		assertLabel( firstCount, "Tab 1: 0" )
		app.buttons[ TabContainerID.incrementFirst ].tap()
		assertLabel( firstCount, "Tab 1: 1" )

		app.buttons[ TabContainerID.secondTab ].tap()
		assertLabel( secondCount, "Tab 2: 0" )
		assertNotExists( firstCount )
		app.buttons[ TabContainerID.incrementSecond ].tap()

		app.buttons[ TabContainerID.firstTab ].tap()
		assertLabel( firstCount, "Tab 1: 1" )
		assertNotExists( secondCount )
	}

	func testTabContentRespectsBottomSafeArea() {
		let app = launch( .tabContainer )
		let increment = app.buttons[ TabContainerID.incrementFirst ]
		assertExists( increment )
		XCTAssertLessThan( increment.frame.maxY, app.windows.firstMatch.frame.maxY - 10 )
	}

	func testRemovingAndAddingTabRecreatesItsState() {
		let app = launch( .tabContainer )
		let secondCount = app.staticTexts[ TabContainerID.secondCount ]

		app.buttons[ TabContainerID.secondTab ].tap()
		app.buttons[ TabContainerID.incrementSecond ].tap()
		assertLabel( secondCount, "Tab 2: 1" )

		app.buttons[ TabContainerID.toggleSecondTab ].tap()
		assertLabel( app.staticTexts[ TabContainerID.firstCount ], "Tab 1: 0" )
		assertNotExists( secondCount )

		app.buttons[ TabContainerID.toggleSecondTab ].tap()
		app.buttons[ TabContainerID.secondTab ].tap()
		assertLabel( secondCount, "Tab 2: 0" )
	}
}
