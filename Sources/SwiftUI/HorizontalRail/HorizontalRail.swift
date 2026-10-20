//
//  HorizontalRail.swift
//  UIExtensions
//
//  Copyright © 2026 mc2 software. All rights reserved
//

import SwiftUI

/// The strategy for determining the number of visible rail columns.
///
/// Both strategies distribute item widths evenly across the available space,
/// accounting for item spacing and the additional peek length.
public enum RailColumnStrategy: Sendable {
	/// Displays a fixed number of columns.
	///
	/// - Parameter count: The number of columns. This value must be greater than zero.
	case fixed( _ count: Int )
	/// Fits columns within a maximum item width.
	///
	/// - Parameter maxItemWidth: The maximum item width, in points.
	///   This value must be greater than zero.
	case adaptive( maxItemWidth: Double )
}

/// A behavior that determines when a rail scrolls to its selected item.
public enum RailSelectionScrollBehavior: Sendable {
	/// Keeps the scroll position and selected item synchronized in both directions.
	case always
	/// Scrolls to the selected item on appearance and when the sequence of item identifiers changes.
	case onChanged
	/// Preserves the scroll position when the selected item changes.
	case never
}

/// A horizontal rail with item-aligned scrolling and configurable item sizing.
///
/// Items use either a fixed column count or an adaptive count based on a maximum width.
/// Selection can drive scrolling, while optional progress reporting provides a fractional
/// scroll position in item units.
///
/// The following example displays two columns and reveals part of the next item:
///
///     HorizontalRail(
///         items: products,
///         id: \.id,
///         columns: .fixed(2),
///         extraPeekOutLength: 24
///     ) { product in
///         ProductCard(product: product)
///     }
///
/// Use ``View/onRailProgressChange(_:)`` to observe the fractional scroll position.
public nonisolated struct HorizontalRail<Data, ID, Content> where Data: RandomAccessCollection,
	ID: Hashable & Sendable, Data.Index == Int, Content: View {

	/// The collection displayed by the rail.
	private let items: Data
	/// The key path to each item's stable, unique identifier.
	private let id: KeyPath<Data.Element, ID>
	/// The strategy used to calculate item widths.
	private let columns: RailColumnStrategy
	/// The selected item, synchronized with scrolling when the behavior is `.always`.
	@Binding private var selectedItem: Data.Element?
	/// The policy for scrolling to the selected item.
	private let selectedItemScrollBehavior: RailSelectionScrollBehavior
	/// The horizontal spacing between adjacent items, in points.
	private let interItemSpace: Double
	/// The leading and trailing scroll content margins, in points.
	private let contentInset: Double
	/// The width reserved for revealing part of the next item, in points.
	/// Reduces the width used for sizing without adding space after the last item.
	private let extraPeekOutLength: Double
	/// Whether content narrower than the visible area is centered horizontally.
	private let centersContentWhenUnderflow: Bool
	/// Identifiers of items sized by their content instead of the rail sizing strategy.
	private let intrinsicSizeItemIDs: Set<ID>
	@Environment(\.railProgressChanged) private var scrollProgressChanged

	/// Builds the view for each item.
	@ViewBuilder private let cellContent: ( Data.Element ) -> Content

	/// Creates a horizontal rail with optional selection tracking.
	///
	/// - Parameters:
	///   - items: The collection to display.
	///   - id: The key path to each item's stable, unique identifier.
	///   - columns: The strategy used to determine the number of visible columns.
	///   - selectedItem: A binding to the selected element. With
	///     ``RailSelectionScrollBehavior/always``, scrolling updates the binding,
	///     and changes to the binding scroll to the corresponding item.
	///   - selectedItemScrollBehavior: The behavior that determines when the rail scrolls
	///     to the selected item.
	///   - interItemSpace: The horizontal spacing between items, in points.
	///   - contentInset: The leading and trailing scroll content margins, in points.
	///   - extraPeekOutLength: The width reserved for revealing part of the next item, in points.
	///     Reduces item widths without increasing the trailing margin.
	///   - intrinsicSizeItemIDs: Identifiers of items that keep their content-defined size.
	///     Other items use the column strategy.
	///   - centersContentWhenUnderflow: Whether a row narrower than the visible area is centered.
	///   - cellContent: A closure that creates a view for each element.
	public init(
		items: Data,
		id: KeyPath<Data.Element, ID>,
		columns: RailColumnStrategy,
		selectedItem: Binding<Data.Element?> = .constant( nil ),
		selectedItemScrollBehavior: RailSelectionScrollBehavior = .always,
		interItemSpace: Double = 8,
		contentInset: Double = 16,
		extraPeekOutLength: Double = 0,
		intrinsicSizeItemIDs: Set<ID> = [],
		centersContentWhenUnderflow: Bool = false,
		cellContent: @escaping ( Data.Element ) -> Content,
	) {
		self.items = items
		self.id = id
		self.columns = columns
		self._selectedItem = selectedItem
		self.selectedItemScrollBehavior = selectedItemScrollBehavior
		self.interItemSpace = interItemSpace
		self.contentInset = contentInset
		self.extraPeekOutLength = extraPeekOutLength
		self.centersContentWhenUnderflow = centersContentWhenUnderflow
		self.intrinsicSizeItemIDs = intrinsicSizeItemIDs
		self.cellContent = cellContent
	}
}

public extension HorizontalRail where ID == Data.Element, Data.Element: Hashable {

	/// Creates a horizontal rail whose elements serve as their own identifiers.
	///
	/// Each element must be unique.
	///
	/// - Parameters:
	///   - items: The collection to display.
	///   - columns: The strategy used to determine the number of visible columns.
	///   - selectedItem: A binding to the selected element. With
	///     ``RailSelectionScrollBehavior/always``, scrolling updates the binding,
	///     and changes to the binding scroll to the corresponding item.
	///   - selectedItemScrollBehavior: The behavior that determines when the rail scrolls
	///     to the selected item.
	///   - interItemSpace: The horizontal spacing between items, in points.
	///   - contentInset: The leading and trailing scroll content margins, in points.
	///   - extraPeekOutLength: The width reserved for revealing part of the next item, in points.
	///     Reduces item widths without increasing the trailing margin.
	///   - centersContentWhenUnderflow: Whether a row narrower than the visible area is centered.
	///   - cellContent: A closure that creates a view for each element.
	init(
		items: Data,
		columns: RailColumnStrategy,
		selectedItem: Binding<Data.Element?> = .constant( nil ),
		selectedItemScrollBehavior: RailSelectionScrollBehavior = .always,
		interItemSpace: Double = 8,
		contentInset: Double = 16,
		extraPeekOutLength: Double = 0,
		centersContentWhenUnderflow: Bool = false,
		cellContent: @escaping ( Data.Element ) -> Content,
	) {
		self.init(
			items: items,
			id: \Data.Element.self,
			columns: columns,
			selectedItem: selectedItem,
			selectedItemScrollBehavior: selectedItemScrollBehavior,
			interItemSpace: interItemSpace,
			contentInset: contentInset,
			extraPeekOutLength: extraPeekOutLength,
			centersContentWhenUnderflow: centersContentWhenUnderflow,
			cellContent: cellContent,
		)
	}
}

// MARK: View

extension HorizontalRail: View {

	@MainActor
	public var body: some View {

		switch selectedItemScrollBehavior {
		case .always:
			scrollView()
				.scrollPosition(
					id: scrollPositionBinding,
					anchor: .leading,
				)

		case .onChanged:
			ScrollViewReader { proxy in

				scrollView()
					.onChange(
						of: items.map { $0[ keyPath: id ] },
						initial: true,
					) {
						if let selectedItem {
							proxy.scrollTo(
								selectedItem[ keyPath: id ],
								anchor: .leading,
							)
						}
					}
			}

		case .never:
			scrollView()
		}
	}
}

@MainActor
private extension HorizontalRail {

	func scrollView() -> some View {

		ScrollView( .horizontal ) {

			LazyHStack( spacing: interItemSpace ) {

				ForEach(
					items,
					id: id,
					content: railCell,
				)
			}
			.scrollTargetLayout()
		}
		.onScrollGeometryChange(
			for: Double.self,
			of: scrollProgress
		) { _, progress in
			scrollProgressChanged?( progress )
		}
		.defaultScrollAnchor(
			centersContentWhenUnderflow ? .center : .leading,
			for: .alignment,
		)
		.scrollIndicators( .never )
		.scrollTargetBehavior( .viewAligned )
		.contentMargins( .horizontal, contentInset, for: .scrollContent )
		.scrollClipDisabled()
	}

	@ViewBuilder
	func railCell( _ item: Data.Element ) -> some View {

		let itemID = item[ keyPath: id ]
		if intrinsicSizeItemIDs.contains( itemID ) {
			cellContent( item )
				.tag( itemID )
		} else {
			cellContent( item )
				.tag( itemID )
				.containerRelativeFrame( .horizontal ) { length, _ -> CGFloat in

					return itemWidth( for: length )
				}
		}
	}
}

@MainActor
private extension HorizontalRail {

	func scrollProgress( from geometry: ScrollGeometry ) -> Double {

		guard scrollProgressChanged != nil, !items.isEmpty else { return 0 }

		let visibleWidth = geometry.containerSize.width
		guard geometry.contentSize.width > visibleWidth else { return 0 }

		let step = itemWidth( for: visibleWidth ) + interItemSpace
		guard step > 0 else { return 0 }

		let offset = geometry.contentOffset.x + geometry.contentInsets.leading
		return min( Double( items.count - 1 ), max( 0, offset / step ))
	}

	func itemWidth( for length: Double ) -> Double {

		let availableLength = max( 0, length - extraPeekOutLength )
		let columnCount: Double
		switch columns {
		case .fixed( let count ):
			columnCount = Double( count )
		case .adaptive( let width ):
			columnCount = max( 1, ceil( ( availableLength + interItemSpace ) / ( width + interItemSpace ) ))
		}
		return max( 0, ( availableLength - ( columnCount - 1 ) * interItemSpace ) / columnCount )
	}

	var scrollPositionBinding: Binding<ID?> {
		Binding<ID?>(
			get: { selectedItem?[ keyPath: id ] },
			set: { newValue in
				guard let newValue else { return }
				selectedItem = items.first( id, equalTo: newValue )
			},
		)
	}
}

#if DEBUG
private func cell( _ item: Int ) -> some View {
	Color.red
		.overlay {
			Text( item.string )
		}
		.aspectRatio( 331 / 250, contentMode: .fit)
		.border(Color.black)
		.cornerRadius( 12 )
}

private struct PreviewContainer: View {

	let items: [ Int ]
	let columns: RailColumnStrategy
	var interItemSpace: Double = 8
	var contentInset: Double = 16
	var extraPeekOutLength: Double = 0

	@State private var selectedItem: Int?

	var body: some View {

		VStack {
			HorizontalRail(
				items: items,
				columns: columns,
				selectedItem: $selectedItem,
				interItemSpace: interItemSpace,
				contentInset: contentInset,
				extraPeekOutLength: extraPeekOutLength,
				cellContent: cell,
			)

			Text( "Selected item: \( selectedItem?.string ?? "None" )")
			Button( "Select 2" ) {
				withAnimation {
					selectedItem = 2
				}
			}
		}
		.onAppear {
			selectedItem = 4
		}
	}
}

#Preview( "Fixed columns" ) {

	ScrollView {

		VStack {

			PreviewContainer(
				items: [1, 2, 3, 4, 5, 6],
				columns: .fixed( 1 ),
				interItemSpace: 12,
				extraPeekOutLength: 12,
			)

			PreviewContainer(
				items: [1, 2, 3, 4, 5, 6],
				columns: .fixed( 2 ),
				interItemSpace: 12,
				extraPeekOutLength: 50,
			)

			PreviewContainer(
				items: [1, 2, 3, 4, 5, 6],
				columns: .fixed( 3 ),
				interItemSpace: 12,
				extraPeekOutLength: 12,
			)

			HorizontalRail(
				items: (1 ... 10).array,
				columns: .fixed( 2 ),
				cellContent: cell,
			)
		}
		.padding( .vertical )
	}
}

#Preview( "Maximum item width" ) {

	ScrollView {

		VStack {

			PreviewContainer(
				items: [1, 2, 3, 4, 5, 6],
				columns: .adaptive( maxItemWidth: 150 ),
				interItemSpace: 8,
				extraPeekOutLength: 12,
			)

			PreviewContainer(
				items: [1, 2, 3, 4, 5, 6],
				columns: .adaptive( maxItemWidth: 200 ),
				interItemSpace: 8,
				contentInset: 24,
				extraPeekOutLength: 60,
			)
		}
		.padding( .vertical )
	}
}

func section( _ centers: Bool ) -> some View {
	VStack( spacing: 24 ) {
		ForEach( [1, 2, 6], id: \.self ) { count in
			HorizontalRail(
				items: Array( 1...count ),
				columns: .fixed( 3 ),
				extraPeekOutLength: 80,
				centersContentWhenUnderflow: centers,
				cellContent: cell,
			)
		}
	}
}

#Preview( "Centered underflow" ) {

	ScrollView {
		VStack( spacing: 100 ) {
			section(true)
				.padding( .vertical )
			section(false)
				.padding( .vertical )
		}
	}
}

#Preview( "Selected item scroll behavior" ) {

	struct SelectedItemScrollBehaviorPreview: View {

		private let items = [1, 2, 3, 4, 5, 6]

		@State private var onChangedSelectedItem: Int? = 3
		@State private var neverSelectedItem: Int? = 4

		var body: some View {
			ScrollView {
				VStack( alignment: .leading, spacing: 24 ) {
					previewSection(
						title: ".onChanged",
						selectedItem: $onChangedSelectedItem,
						selectedItemScrollBehavior: .onChanged,
					)

					previewSection(
						title: ".never",
						selectedItem: $neverSelectedItem,
						selectedItemScrollBehavior: .never,
					)
				}
				.padding()
			}
		}

		private func previewSection(
			title: String,
			selectedItem: Binding<Int?>,
			selectedItemScrollBehavior: RailSelectionScrollBehavior,
		) -> some View {
			VStack( alignment: .leading, spacing: 12 ) {
				Text( title )
					.font( .headline )

				HorizontalRail(
					items: items,
					columns: .fixed( 2 ),
					selectedItem: selectedItem,
					selectedItemScrollBehavior: selectedItemScrollBehavior,
					interItemSpace: 12,
					extraPeekOutLength: 12,
					cellContent: cell,
				)

				HStack {
					Text( "Selected item: \( selectedItem.wrappedValue?.string ?? "None" )" )

					Spacer()

					Button( "Select 2" ) {
						withAnimation {
							selectedItem.wrappedValue = 2
						}
					}

					Button( "Select 6" ) {
						withAnimation {
							selectedItem.wrappedValue = 6
						}
					}
				}
			}
		}
	}

	return SelectedItemScrollBehaviorPreview()
}

#Preview( "Scroll progress" ) {

	@Previewable @State var currentIndex: Double = 0
	@Previewable @State var selectedItem: Int? = 1

	VStack( spacing: 24 ) {
		HorizontalRail(
			items: Array( 1...6 ),
			columns: .fixed( 1 ),
			selectedItem: $selectedItem,
			extraPeekOutLength: 60,
			cellContent: cell,
		)
		.onRailProgressChange( update: $currentIndex )

		Text( "Current index (zero-based): \(currentIndex, specifier: "%.3f")" )
		Text( "Selected item: \(selectedItem?.string ?? "None")" )

		HStack {
			Button( "First" ) {
				withAnimation {
					selectedItem = 1
				}
			}

			Button( "Last" ) {
				withAnimation {
					selectedItem = 6
				}
			}
		}
	}
}
#endif
