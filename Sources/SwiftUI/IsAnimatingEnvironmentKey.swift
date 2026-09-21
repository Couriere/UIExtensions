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

extension EnvironmentValues {

	/// A Boolean value that indicates whether the action of the enclosing
	/// button is in progress.
	///
	/// ``AsyncButton`` sets this value to `true` while its action runs.
	/// Read it in a button style to show a progress indicator in place
	/// of the label:
	///
	///     struct ProgressButtonStyle: ButtonStyle {
	///
	///         @Environment( \.isAnimating ) private var isAnimating
	///
	///         func makeBody( configuration: Configuration ) -> some View {
	///             ZStack {
	///                 configuration.label
	///                     .opacity( isAnimating ? 0 : 1 )
	///                 if isAnimating {
	///                     ProgressView()
	///                 }
	///             }
	///         }
	///     }
	@Entry
	public var isAnimating: Bool = false
}

extension View {

	/// Marks the view as performing an action.
	///
	/// Sets ``SwiftUI/EnvironmentValues/isAnimating`` for the view hierarchy,
	/// so that button styles can show a progress indicator.
	///
	/// The modifier doesn't disable the view. ``AsyncButton`` disables itself
	/// while the value is `true`; for other controls, combine this modifier
	/// with `disabled( _: )`:
	///
	///     Button( "Reload", action: reload )
	///         .isAnimating( isLoading )
	///         .disabled( isLoading )
	///
	/// - Parameter isAnimating: A Boolean value that indicates whether
	///   an action is in progress.
	/// - Returns: A view that reflects the progress of the action.
	@inlinable
	public func isAnimating( _ isAnimating: Bool ) -> some View {
		environment( \.isAnimating, isAnimating )
	}
}
