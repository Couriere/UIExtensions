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

#if canImport(UIKit)

public extension View {
	
	/// Applies a transparent or colored background to the view,
	/// presented using `.fullScreenCover`.
	///
	/// - Parameter color: The background color to set (default is `.clear`).
	/// - Returns: A view with the specified transparent or colored background.
	///
	/// Example usage:
	/// ```
	/// struct ContentView: View {
	///     @State private var isPresentingModal = false
	///
	///     var body: some View {
	///         Button("Show Modal") {
	///             isPresentingModal.toggle()
	///         }
	///         .fullScreenCover(isPresented: $isPresentingModal) {
	///             SomeModalView()
	///                 .transparentBackground()
	///         }
	///     }
	/// }
	/// ```
	///
	func transparentBackground(
		_ color: Color = .clear
	) -> some View {
		self
			.background(
				TransparentBackground(
					backgroundColor: color
				)
			)
	}
}

/// A SwiftUI-compatible UIViewRepresentable struct that creates
/// a transparent or colored background view.
///
/// This struct is useful for making the background
/// of a view transparent or setting a specific
/// background color when presenting views with
/// `fullScreenCover` or similar techniques.
///
/// Example usage:
/// ```
/// struct ContentView: View {
///     @State private var isPresentingModal = false
///
///     var body: some View {
///         Button("Show Modal") {
///             isPresentingModal.toggle()
///         }
///         .fullScreenCover(isPresented: $isPresentingModal) {
///             SomeModalView()
///                 .background(TransparentBackground(backgroundColor: .black.opacity(0.5)))
///         }
///     }
/// }
/// ```
///
public struct TransparentBackground: UIViewRepresentable {
	
	/// The background color to make the window transparent
	/// or the specified color.
	public let backgroundColor: UIColor

	/// Initializes a `TransparentBackground` with a background color.
	///
	/// - Parameter backgroundColor: The background color to set
	/// (default is `.clear`).
	///
	public init( backgroundColor: UIColor = .clear ) {
		self.backgroundColor = backgroundColor
	}

	/// Initializes a `TransparentBackground` with a SwiftUI `Color`
	///
	/// - Parameter backgroundColor: The background color to set.
	///
	public init( backgroundColor: Color ) {
		self.backgroundColor = UIColor( backgroundColor )
	}

	private class _TransparentBackgroundWrapperView: UIView {

		let color: UIColor
		init( color: UIColor ) {
			self.color = color
			super.init( frame: .zero )
			self.isHidden = true
		}
		required init?( coder: NSCoder ) { fatalError() }

		override func didMoveToWindow() {
			super.didMoveToWindow()
			superview?.superview?.backgroundColor = backgroundColor
		}
	}

	public func makeUIView( context: Context ) -> UIView {
		_TransparentBackgroundWrapperView( color: backgroundColor )
	}

	public func updateUIView( _ uiView: UIView, context: Context ) {}
}

struct TransparentBackground_Preview: PreviewProvider {
	
	struct PreviewContainer: View {
		@State private var isPresentingModal = false
		
		var body: some View {
			Button("Show Modal") {
				isPresentingModal = true
			}
			.buttonStyle( .plain )
			.wholeViewBackground( LinearGradient(colors: [.red, .green, .blue], startPoint: .top, endPoint: .bottom))
			.fullScreenCover(isPresented: $isPresentingModal) {
				Button( "Dismiss" ) {
					isPresentingModal = false
				}
				.padding( 30 )
				.background( Color.white )
				.cornerRadius( 12 )
				.transparentBackground( .black(0.5) )
			}
			.transaction { $0.disablesAnimations = true	}
		}
	}
	
	static var previews: some View {
		PreviewContainer()
	}
}

#endif
