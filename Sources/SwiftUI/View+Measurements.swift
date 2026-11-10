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
	@inlinable
	public func onGeometryChange<T>(
		update binding: Binding<T>,
		with transform: @escaping @Sendable (GeometryProxy) -> T,
	) -> some View where T : Equatable, T : Sendable {

		onGeometryChange(
			for: T.self,
			of: transform,
		) {
			binding.wrappedValue = $0
		}
	}

	/// Observes the scroll geometry of this scroll view and updates a binding
	/// with a transformed value.
	///
	/// The binding is only updated when the new value differs from the previous one
	/// (requires `T: Equatable`).
	///
	/// - Parameters:
	///   - binding: A binding that will be updated with the transformed scroll geometry value.
	///   - transform: A closure that receives the current `ScrollGeometry` and returns
	///     the value to assign to `binding`.
	/// - Returns: A view that monitors its scroll geometry and updates `binding` accordingly.
	///
	/// ### Example
	/// Update a binding with the scroll view's content offset:
	/// ```swift
	/// @State private var offset: CGFloat = 0
	///
	/// ScrollView { ... }
	///     .onScrollGeometryChange(update: $offset, with: \.contentOffset.y)
	/// ```
	@inlinable
	public func onScrollGeometryChange<T>(
		update binding: Binding<T>,
		with transform: @escaping (ScrollGeometry) -> T,
	) -> some View where T : Equatable {

		onScrollGeometryChange(
			for: T.self,
			of: transform,
		) {
			binding.wrappedValue = $1
		}
	}

	/// Updates a binding when the view crosses the threshold to be considered
	/// on-screen or off-screen.
	///
	/// Use this modifier to keep a `Binding<Bool>` in sync with the scroll
	/// visibility state of the view. The binding is updated when the view
	/// crosses the provided visibility threshold.
	///
	///     struct VideoPlayer: View {
	///         @State private var isVisible: Bool = false
	///
	///         var body: some View {
	///             Group {
	///                 // ...
	///             }
	///             .onScrollVisibilityChange(
	///                 threshold: 0.2,
	///                 update: $isVisible
	///             )
	///         }
	///     }
	///
	/// If the view is already on-screen when it appears and the threshold
	/// has been reached, the binding will be updated immediately.
	///
	/// - Parameters:
	///   - threshold: The fraction of the view that must be visible within the
	///     viewport before the binding is updated. The default value is `0.5`,
	///     meaning more than 50% of the view must be visible.
	///   - binding: A Boolean binding that reflects whether the view is
	///     considered visible based on the given threshold.
	@inlinable
	public func onScrollVisibilityChange(
		threshold: Double = 0.5,
		update binding: Binding<Bool>,
	) -> some View {
		onScrollVisibilityChange( threshold: threshold ) {
			binding.wrappedValue = $0
		}
	}

	/// Updates a binding with a value derived from the view's scroll visibility
	/// when the view crosses the threshold to be considered on-screen or off-screen.
	///
	/// - Parameters:
	///   - threshold: The fraction of the view that must be visible within the
	///     viewport before the binding is updated. The default value is `0.5`,
	///     meaning more than 50% of the view must be visible.
	///   - binding: A binding that will be updated with the transformed visibility.
	///   - transform: A closure that receives whether the view is visible and
	///     returns the value to assign to `binding`.
	///
	/// ### Example
	/// ```swift
	/// @State private var opacity: Double = 0
	///
	/// Image( "promo" )
	///     .onScrollVisibilityChange( update: $opacity.animation() ) { $0 ? 1 : 0 }
	/// ```
	@inlinable
	public func onScrollVisibilityChange<T>(
		threshold: Double = 0.5,
		update binding: Binding<T>,
		with transform: @escaping ( _ isVisible: Bool ) -> T,
	) -> some View {
		onScrollVisibilityChange( threshold: threshold ) {
			binding.wrappedValue = transform( $0 )
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
	public func measureSize(
		perform action: @escaping ( CGSize ) -> Void,
	) -> some View {

		onGeometryChange(
			for: CGSize.self,
			of: \.size,
			action: action,
		)
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
	@inlinable
	public func measure(
		width binding: Binding<Double>,
	) -> some View {

		onGeometryChange(
			update: binding,
			with: \.size.width.asDouble,
		)
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
	@inlinable
	public func measure(
		height binding: Binding<Double>,
	) -> some View {

		onGeometryChange(
			update: binding,
			with: \.size.height.asDouble,
		)
	}
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
	@inlinable
	public func measureFrame(
		in coordinateSpace: CoordinateSpace = .global,
		action: @escaping ( CGRect ) -> Void,
	) -> some View {

		let coordinateSpace = UnsafeSendable( coordinateSpace )

		return onGeometryChange(
			for: CGRect.self,
			of: {
				$0.frame( in: coordinateSpace.value )
			},
			action: action,
		)
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
		in coordinateSpace: CoordinateSpace = .global,
	) -> some View {
		measureFrame( in: coordinateSpace ) { binding.wrappedValue = $0 }
	}
}

extension View {

	/// Observes changes to the scroll offset and reports transformed values.
	///
	/// The offset is adjusted by the scroll view's content insets before being
	/// passed to `transform`, so the initial content position is represented by
	/// `CGPoint.zero`.
	///
	/// - Parameters:
	///   - transform: A closure that converts the current scroll offset into the
	///     equatable value to observe.
	///   - action: A closure called with the previous and current transformed
	///     values when the value changes.
	public func measureOffset<Value: Equatable>(
		of transform: @escaping ( _ offset: CGPoint ) -> Value,
		action: @escaping ( _ old: Value, _ new: Value ) -> Void,
	) -> some View {

		onScrollGeometryChange(
			for: Value.self,
			of: {
				transform(
					$0.contentOffset.offset(
						dx: $0.contentInsets.leading,
						dy: $0.contentInsets.top,
					),
				)
			},
			action: action,
		)
	}

	/// Keeps a binding synchronized with a transformed scroll offset.
	///
	/// - Parameters:
	///   - bind: The binding updated whenever the transformed offset changes.
	///   - transform: A closure that converts the current scroll offset into the
	///     value stored in `bind`.
	///
	/// Example usage:
	/// ```
	/// @State private var isScrolled = false
	/// ...
	/// ScrollView { ... }
	///     .measureOffset( bind: $isScrolled ) { $0.y > 0 }
	/// ```
	public func measureOffset<Value: Equatable>(
		bind: Binding<Value>,
		to transform: @escaping ( _ offset: CGPoint ) -> Value,
	) -> some View {
		measureOffset( of: transform ) {
			bind.wrappedValue = $1
		}
	}
}

extension GeometryProxy {

	/// The frame of the container view in the global coordinate space.
	///
	/// Shorthand for `frame( in: .global )`.
	@inlinable
	public var globalFrame: CGRect { frame( in: .global ) }
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
						height: fixHeight ? 100 : nil,
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
							height: 100,
						)
						.measure(
							frame: $frame,
							in: .named(scrollNamespace),
						)

					ForEach( 0..<100, id: \.self ) { _ in
						Color.green.frame( height: 24 )
					}
				}
				.border( .orange, width: 2 )
				.coordinateSpace(
					name: scrollNamespace,
				)

				Text( "Frame: ( \(Int(frame.minX)), \(Int(frame.minY)), \(Int(frame.size.width)), \(Int(frame.size.height)) )" )
					.font( .headline )
			}
		}
	}

	return PreviewContainer()
}
