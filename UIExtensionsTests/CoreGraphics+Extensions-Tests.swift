//
//  CoreGraphics+Extensions.swift
//  UIExtensionsTests
//
//  Created by Vladimir on 07/02/2019.
//  Copyright © 2019 Vladimir Kazantsev. All rights reserved.
//

import XCTest

class CoreGraphics_Extensions: XCTestCase {

	func testIsEmpty() {

		let nonEmpty = CGSize( width: 1, height: 1 )
		XCTAssertFalse( nonEmpty.isEmpty )

		let emptyWidth = CGSize( width: 0, height: 1 )
		XCTAssertTrue( emptyWidth.isEmpty )

		let emptyHeight = CGSize( width: 0, height: 1 )
		XCTAssertTrue( emptyHeight.isEmpty )

		let emptySize = CGSize( width: 0, height: 0 )
		XCTAssertTrue( emptySize.isEmpty )

		let invalidSize = CGSize( width: Double.nan, height: 1 )
		XCTAssertTrue( invalidSize.isEmpty )
	}
}
