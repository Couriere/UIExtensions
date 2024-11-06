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

public extension View {
	
	/// Positions this view within an invisible frame with the specified size.
	///
	/// - Parameters:
	///   - size: A fixed size for the resulting view.
	///   - alignment: The alignment of this view inside the resulting frame.
	///     Note that most alignment values have no apparent effect when the
	///     size of the frame happens to match that of this view.
	///
	/// - Returns: A view with fixed dimensions of `size`.
	///
	func frame(
		_ size: CGSize,
		alignment: Alignment = .center
	) -> some View {
		
		self.frame(
			width: size.width,
			height: size.height,
			alignment: alignment
		)
	}

	/// Conditionally hides the view based on a Boolean flag.
	///
	/// - Parameter isHidden: A Boolean flag to determine whether the view is hidden.
	///
	/// - Returns: A hidden or visible view based on the `isHidden` flag.
	///
	@ViewBuilder
	func hidden( _ isHidden: Bool ) -> some View {
		if isHidden {
			self.hidden()
		} else {
			self
		}
	}

	/// Sets a background view that covers the entire screen, optionally ignoring safe area edges.
	///
	/// - Parameters:
	///   - background: The background view to set.
	///   - safeAreaEdges: The safe area edges to be ignored by the background.
	///
	/// - Returns: A view with the specified background view covering the screen.
	/// 
	func wholeViewBackground<Background: View>(
		_ background: Background,
		ignoreSafeAreaEdges safeAreaEdges: Edge.Set = .all
	) -> some View {
		ZStack {
			background
				.edgesIgnoringSafeArea( safeAreaEdges )
			self
		}
	}
}
