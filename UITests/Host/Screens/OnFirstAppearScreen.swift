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

import SwiftUI
import UIExtensions

/// Counts `onFirstAppear` and `onAppear` calls of the root view
/// while the test navigates to the details and back.
struct OnFirstAppearScreen: View {

	@State private var firstAppearCount = 0
	@State private var appearCount = 0

	var body: some View {
		NavigationStack {
			List {
				Text( "First appear: \( firstAppearCount )" )
					.accessibilityIdentifier( OnFirstAppearID.firstAppearCount )
				Text( "Appear: \( appearCount )" )
					.accessibilityIdentifier( OnFirstAppearID.appearCount )
				NavigationLink( "Open details" ) {
					Text( "Details" )
						.accessibilityIdentifier( OnFirstAppearID.details )
				}
				.accessibilityIdentifier( OnFirstAppearID.openDetails )
			}
			.onFirstAppear { firstAppearCount += 1 }
			.onAppear { appearCount += 1 }
			.navigationTitle( "onFirstAppear" )
		}
	}
}
