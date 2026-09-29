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

import XCTest

@MainActor
final class OnFirstAppearUITests: XCTestCase {

	func testRunsActionOnlyOnFirstAppearance() {
		let app = launch( .onFirstAppear )
		let firstAppearCount = app.staticTexts[ OnFirstAppearID.firstAppearCount ]
		let appearCount = app.staticTexts[ OnFirstAppearID.appearCount ]

		assertLabel( firstAppearCount, "First appear: 1" )
		assertLabel( appearCount, "Appear: 1" )

		for expectedAppearCount in 2...3 {
			app.buttons[ OnFirstAppearID.openDetails ].tap()
			assertExists( app.staticTexts[ OnFirstAppearID.details ])
			app.navigateBack()

			assertLabel( appearCount, "Appear: \( expectedAppearCount )" )
			assertLabel( firstAppearCount, "First appear: 1" )
		}
	}
}
