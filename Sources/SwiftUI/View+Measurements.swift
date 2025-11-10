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

extension View {

	/// Observes this view's geometry and updates a binding with a transformed value.
	///
	/// Use this helper to derive a value from the view's `GeometryProxy` and write it
	/// into a `Binding`. The value is recomputed when the view's geometry changes and
	/// the binding is only updated when the new value differs from the previous one
	/// (requires `T: Equatable`).
	///
	/// - Parameters:
	///   - binding: A binding that will be updated with the transformed geometry value.
	///   - transform: A closure that receives the current `GeometryProxy` and returns
	///     the value to assign to `binding`.
	/// - Returns: A view that monitors its geometry and updates `binding` accordingly.
	///
	/// ### Example
	/// Update a binding with the view's width:
	/// ```swift
	/// @State private var width: CGFloat = 0
	///
	/// Color.red
	///     .onGeometryChange(update: $width, with: \.size.width)
	/// ```
	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	@inlinable
	public func onGeometryChange<T>(
		update binding: Binding<T>,
		with transform: @escaping @Sendable (GeometryProxy) -> T
	) -> some View where T : Equatable, T : Sendable {

		onGeometryChange(
			for: T.self,
			of: transform,
		) {
			binding.wrappedValue = $0
		}
	}

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
	@ViewBuilder
	public func measureSize(
		perform action: @escaping ( CGSize ) -> Void
	) -> some View {
		
		if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
			self
				.onGeometryChange(
					for: CGSize.self,
					of: \.size,
					action: action
				)
		}
		else {

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
				.onPreferenceChange( ViewSizePreferenceKey.self ) { size in
					DispatchQueue.main.async {
						action( size )
					}
				}
		}
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
	@inlinable
	public func measure( size binding: Binding<CGSize> ) -> some View {
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
	@ViewBuilder @inlinable
	public func measure(
		width binding: Binding<Double>
	) -> some View {

		if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
			onGeometryChange(
				update: binding,
				with: \.size.width.double
			)
		}
		else {
			measureSize { binding.wrappedValue = $0.width }
		}
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
	@ViewBuilder @inlinable
	public func measure(
		height binding: Binding<Double>
	) -> some View {

		if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
			onGeometryChange(
				update: binding,
				with: \.size.height.double
			)
		}
		else {
			measureSize { binding.wrappedValue = $0.height }
		}
	}
}

/// A private preference key for measuring
/// the size of a view.
@available( iOS, deprecated: 16 )
@available( macOS, deprecated: 13 )
@available( tvOS, deprecated: 16 )
@available( watchOS, deprecated: 9 )
private struct ViewSizePreferenceKey: PreferenceKey {
	static let defaultValue: CGSize = .zero
	static func reduce( value: inout CGSize, nextValue: () -> CGSize ) {}
}

extension View {

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
	@ViewBuilder
	public func measureFrame(
		in coordinateSpace: CoordinateSpace = .global,
		action: @escaping ( CGRect ) -> Void
	) -> some View {

		if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {

			let coordinateSpace = UnsafeSendable( coordinateSpace )

			self
				.onGeometryChange(
					for: CGRect.self,
					of: {
						$0.frame( in: coordinateSpace.value )
					},
					action: action
				)
		}
		else {
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
				.onPreferenceChange( ViewFramePreferenceKey.self ) { frame in
					DispatchQueue.main.async {
						action( frame )
					}
				}
		}
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
	@inlinable
	public func measure(
		frame binding: Binding<CGRect>,
		in coordinateSpace: CoordinateSpace = .global
	) -> some View {
		measureFrame( in: coordinateSpace ) { binding.wrappedValue = $0 }
	}
}

/// A private preference key for measuring
/// the frame of a view.
@available( iOS, deprecated: 16 )
@available( macOS, deprecated: 13 )
@available( tvOS, deprecated: 16 )
@available( watchOS, deprecated: 9 )
private struct ViewFramePreferenceKey: PreferenceKey {
	static let defaultValue: CGRect = .zero
	static func reduce( value: inout CGRect, nextValue: () -> CGRect ) {}
}

#Preview("Size") {

	struct PreviewContainer: View {

		@State private var fixWidth: Bool = false
		@State private var fixHeight: Bool = false
		@State private var width: Double = 0
		@State private var height: Double = 0

		var body: some View {

			VStack {

				Color.red
					.frame(
						width: fixWidth ? 100 : nil,
						height: fixHeight ? 100 : nil
					)
					.measure(width: $width)
					.measure(height: $height)

				Spacer()

				Text( "Width: \(Int(width)), Height: \(Int(height))" )
					.font( .headline )

				HStack( spacing: 48 ) {
					Toggle( "Horizontal", isOn: $fixWidth )
					Toggle( "Vertical", isOn: $fixHeight )
				}
				.fixedSize()
			}
		}
	}

	return PreviewContainer()
}

@available(iOS 14.0, *)
#Preview("Frame") {

	struct PreviewContainer: View {

		@State private var frame: CGRect = .zero

		let scrollNamespace = "ScrollViewCoordinateSpace"

		var body: some View {

			VStack {

				ScrollView {

					ForEach( 0..<15, id: \.self ) { _ in
						Color.blue.frame( height: 24 )
					}

					Color.red
						.frame(
							width: 100,
							height: 100
						)
						.measure(
							frame: $frame,
							in: .named(scrollNamespace)
						)

					ForEach( 0..<100, id: \.self ) { _ in
						Color.green.frame( height: 24 )
					}
				}
				.border( .orange, width: 2 )
				.coordinateSpace(
					name: scrollNamespace
				)

				Text( "Frame: ( \(Int(frame.minX)), \(Int(frame.minY)), \(Int(frame.size.width)), \(Int(frame.size.height)) )" )
					.font( .headline )
			}
		}
	}

	return PreviewContainer()
}

