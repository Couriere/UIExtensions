import SwiftUI
import UIExtensions

struct HorizontalRailScreen: View {
	private let variant = UserDefaults.standard.string( forKey: "UITestRailVariant" )
		.flatMap( HorizontalRailID.Variant.init( rawValue: )) ?? .standard

	@State private var items = Array( 1...6 )
	@State private var selection: Int? = 3
	@State private var progress: Double = -1

	private var columns: RailColumnStrategy {
		switch variant {
		case .fixedColumns: .fixed( 2 )
		case .adaptiveColumns: .adaptive( maxItemWidth: 100 )
		case .centered: .fixed( 3 )
		default: .fixed( 1 )
		}
	}

	private var behavior: RailSelectionScrollBehavior {
		switch variant {
		case .onChanged: .onChanged
		case .never, .fixedColumns, .adaptiveColumns, .centered, .intrinsic, .empty: .never
		default: .always
		}
	}

	var body: some View {
		VStack( spacing: 20 ) {
			HorizontalRail(
				items: variant == .empty ? [] : variant == .centered ? [1] : items,
				id: \.self,
				columns: columns,
				selectedItem: $selection,
				selectedItemScrollBehavior: behavior,
				extraPeekOutLength: variant == .fixedColumns ? 24 : 0,
				intrinsicSizeItemIDs: variant == .intrinsic ? [1] : [],
				centersContentWhenUnderflow: variant == .centered,
				cellContent: { item in
					Text( "Item \( item )" )
						.frame( maxWidth: .infinity )
						.frame( width: variant == .intrinsic && item == 1 ? 64 : nil, height: 100 )
						.background( .blue.opacity( 0.2 ))
						.accessibilityIdentifier( HorizontalRailID.item( item ))
				}
			)
			.onRailProgressChange( update: $progress )
			.frame( width: 320, height: 100 )
			.accessibilityIdentifier( HorizontalRailID.rail )

			Text( "Selection: \( selection ?? 0 )" )
				.accessibilityIdentifier( HorizontalRailID.selection )
			Text( verbatim: progress.formatted( .number.locale( Locale( identifier: "en_US_POSIX" )).precision( .fractionLength( 2 ))))
				.accessibilityIdentifier( HorizontalRailID.progress )
			Button( "Select 5" ) { selection = 5 }
				.accessibilityIdentifier( HorizontalRailID.select )
			Button( "Replace items" ) { items = Array( 5...10 ) }
				.accessibilityIdentifier( HorizontalRailID.replace )
		}
	}
}
