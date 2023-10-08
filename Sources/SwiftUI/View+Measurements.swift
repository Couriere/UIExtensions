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

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {

	/// Measures the size of the view and performs an action with the result.
	///
	/// - Parameter action: A closure that takes a CGSize as its argument,
	/// representing the measured size.
	/// - Returns: A view modified to include the measurement functionality.
	///
	/// Example usage:
	/// ```
	/// someView
	///     .measureSize { size in
	///			print("Measured Size: \(size)")
	///     }
	/// ```
	func measureSize( perform action: @escaping ( CGSize ) -> Void ) -> some View {

		self
			.background(
				GeometryReader { geometry in
					Color.clear
						.preference(
							key: ViewSizePreferenceKey.self,
							value: geometry.size
						)
				}
			)
			.onPreferenceChange( ViewSizePreferenceKey.self, perform: action )
	}

	/// Measures the size of the view and binds it to a CGSize variable.
	///
	/// - Parameter binding: A binding to a CGSize property where the measured
	///                      size will be stored.
	/// - Returns: A view modified to include the measurement functionality.
	///
	/// Example usage:
	/// ```
	/// @State private var viewSize: CGSize = .zero
	/// ...
	/// someView
	///    .measure( size: $viewSize )
	/// ```
	///
	func measure( size binding: Binding<CGSize> ) -> some View {
		measureSize { binding.wrappedValue = $0 }
	}

	/// Measures the width of the view and binds it to a Double variable.
	///
	/// - Parameter binding: A binding to a Double property where the measured
	///                      width will be stored.
	/// - Returns: A view modified to include the width measurement functionality.
	///
	/// Example usage:
	/// ```
	/// @State private var viewWidth: Double = 0
	/// ...
	/// someView
	///    .measure( width: $viewWidth )
	/// ```
	///
	func measure( width binding: Binding<Double> ) -> some View {
		measureSize { binding.wrappedValue = $0.width }
	}

	/// Measures the height of the view and binds it to a Double variable.
	///
	/// - Parameter binding: A binding to a Double property where the measured
	///                      height will be stored.
	/// - Returns: A view modified to include the height measurement functionality.
	///
	/// Example usage:
	/// ```
	/// @State private var viewHeight: Double = 0
	/// ...
	/// someView
	///    .measure(height: $viewHeight)
	/// ```
	///
	func measure( height binding: Binding<Double> ) -> some View {
		measureSize { binding.wrappedValue = $0.height }
	}
}

/// A private preference key for measuring the size of a view.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private struct ViewSizePreferenceKey: PreferenceKey {
	static var defaultValue: CGSize = .zero
	static func reduce( value: inout CGSize, nextValue: () -> CGSize ) {}
}


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {

	/// Measures and observes the frame of the view
	/// within a specified coordinate space.
	///
	/// - Parameters:
	///   - coordinateSpace: The coordinate space in which to measure
	///   the frame (default is `.global`).
	///   - action: A closure that takes a CGRect as its argument,
	///   representing the measured frame.
	/// - Returns: A view modified to include the frame
	/// measurement functionality.
	///
	/// Example usage:
	/// ```
	/// someView
	///     .measureFrame( in: .local ) { frame in
	///			print("Measured Frame: \( frame )")
	///     }
	/// ```
	func measureFrame(
		in coordinateSpace: CoordinateSpace = .global,
		action: @escaping ( CGRect ) -> Void
	) -> some View {
		self
			.background(
				GeometryReader { geometry in
					Color.clear
						.preference(
							key: ViewFramePreferenceKey.self,
							value: geometry.frame( in: coordinateSpace )
						)
				}
			)
			.onPreferenceChange( ViewFramePreferenceKey.self, perform: action )
	}

	/// Measures and observes the frame of the view within a specified coordinate space
	/// and binds it to a CGRect.
	///
	/// - Parameters:
	///   - binding: A binding to a CGRect property where
	///   the measured frame will be stored.
	///   - coordinateSpace: The coordinate space in which to measure
	///   the frame (default is `.global`).
	/// - Returns: A view modified to include the frame measurement functionality.
	///
	/// Example usage:
	/// ```
	/// @State private var frame: CGRect = .zero
	/// ...
	/// someView
	///     .measure( frame: $frame )
	/// ```
	func measure(
		frame binding: Binding<CGRect>,
		in coordinateSpace: CoordinateSpace = .global
	) -> some View {
		measureFrame( in: coordinateSpace ) { binding.wrappedValue = $0 }
	}
}

/// A private preference key for measuring the frame of a view.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private struct ViewFramePreferenceKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	static func reduce( value: inout CGRect, nextValue: () -> CGRect ) {}
}
