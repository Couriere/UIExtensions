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

#if canImport(UIKit) && !os(watchOS)
import UIKit

/// A tab container backed by `UIViewController` that provides the content-switching behavior of `TabView`.
///
/// This container avoids `TabView` layout issues on some iOS versions while providing:
/// 1. **Lazy presentation**: a tab is attached only when it is first selected.
/// 2. **State preservation**: switching tabs retains scroll positions and form input.
/// 3. **Appearance lifecycle**: `onAppear` and `onDisappear` follow tab changes.
/// 4. **No system tab bar**: callers provide their own selection controls.
///
/// ### Example
/// ```swift
/// enum Tab: Hashable {
///     case home, search, settings
/// }
///
/// struct MyView: View {
///     @State private var selection: Tab = .home
///
///     var body: some View {
///         VStack {
///             TabContainer(selection: $selection) {
///                 HomeView()
///                     .tabTag(Tab.home)
///                 SearchView()
///                     .tabTag(Tab.search)
///                 SettingsView()
///                     .tabTag(Tab.settings)
///             }
///
///             // Custom selection control
///             Picker("Menu", selection: $selection) {
///                 Text("Home").tag(Tab.home)
///                 Text("Search").tag(Tab.search)
///                 Text("Settings").tag(Tab.settings)
///             }
///             .pickerStyle(.segmented)
///         }
///     }
/// }
/// ```
@MainActor
public struct TabContainer<Selection: Hashable, Content: View> {

	@Binding var selection: Selection
	@ViewBuilder let content: () -> Content

	/// Creates a tab container.
	/// - Parameters:
	///   - selection: The currently selected tab.
	///   - content: Tab views marked with `.tabTag()`.
	public init(
		selection: Binding<Selection>,
		@ViewBuilder content: @escaping () -> Content,
	) {
		self._selection = selection
		self.content = content
	}
}

extension View {

	/// Assigns a selection tag to a tab in `TabContainer`.
	/// - Parameter selection: The tab identifier.
	public func tabTag<Selection: Hashable>(
		_ selection: Selection,
	) -> some View {
		_trait( TabContainerTag.self, AnyHashable( selection ))
	}
}

// MARK: - TabContainer + View

extension TabContainer: View {

	public var body: some View {
		_VariadicView.Tree(
			TabContainerRoot( selection: $selection ),
			content: content,
		)
	}
}

/// Collects tagged children from the variadic view tree.
private struct TabContainerRoot<Selection: Hashable>: _VariadicView_UnaryViewRoot {

	@Binding var selection: Selection

	/// Converts child views into tab items.
	func body(
		children: _VariadicView.Children,
	) -> some View {

		TabContainerControllerHost(
			selection: AnyHashable( selection ),
			tabs: children.compactMap { child in

				// Read the tag assigned by .tabTag().
				guard let tag = child[ TabContainerTag.self ] else {
					return nil
				}

				return TabItem(
					tag: tag,
					view: AnyView(
						child
							.accessibilityHidden( tag != AnyHashable( selection )),
					),
				)
			},
		)
	}
}

/// Trait key for a tab identifier.
private struct TabContainerTag: _ViewTraitKey {
	static var defaultValue: AnyHashable? {
		nil
	}
}

/// A tagged tab view.
private struct TabItem {
	/// The unique tab identifier.
	let tag: AnyHashable
	/// The tab content.
	let view: AnyView
}

/// Bridges SwiftUI tab data to the UIKit controller.
private struct TabContainerControllerHost: UIViewControllerRepresentable {

	let selection: AnyHashable
	let tabs: [ TabItem ]

	/// Creates the container controller.
	func makeUIViewController(
		context: Context,
	) -> TabContainerViewController {
		TabContainerViewController()
	}

	/// Updates the controller when SwiftUI tab data changes.
	func updateUIViewController(
		_ uiViewController: TabContainerViewController,
		context: Context,
	) {
		uiViewController.update(
			tabs: tabs,
			selection: selection,
		)
	}
}

/// Manages tab attachment and appearance transitions.
private final class TabContainerViewController: UIViewController {

	/// Cached hosting controllers, keyed by tab identifier.
	private var hostingControllers: [ AnyHashable: UIHostingController<AnyView> ] = [:]
	/// The currently presented tab identifier.
	private var selectedTag: AnyHashable?

	/// Updates the available tabs and current selection.
	func update(
		tabs: [ TabItem ],
		selection: AnyHashable,
	) {
		// Remove tabs that no longer exist.
		let validTags: Set<AnyHashable> = Set( tabs.map(\.tag ))
		removeObsoleteTabs( keeping: validTags )

		// Update existing hosts or create new ones.
		for tab in tabs {
			if let controller = hostingControllers[ tab.tag ] {
				controller.rootView = tab.view
			} else {
				let controller = UIHostingController( rootView: tab.view )
				controller.view.backgroundColor = .clear
				hostingControllers[ tab.tag ] = controller
			}
		}

		// Present the selected tab.
		showTab( with: selection )
	}
}

private extension TabContainerViewController {

	/// Switches tabs and forwards appearance transitions.
	func showTab(
		with tag: AnyHashable,
	) {
		guard tag != selectedTag else { return }

		let nextController = hostingControllers[ tag ]
		let previousController = selectedTag.flatMap { hostingControllers[ $0 ] }

		if let nextController {
			attach( nextController )
		}
		if let previousController, previousController !== nextController {
			detach( previousController )
		}

		selectedTag = tag
	}

	/// Attaches a tab controller to the view hierarchy.
	func attach(
		_ controller: UIHostingController<AnyView>,
	) {
		// A previously attached controller only needs to move to the front.
		guard controller.parent !== self else {
			view.bringSubviewToFront( controller.view )
			return
		}

		controller.beginAppearanceTransition( true, animated: false )
		addChild( controller )
		view.addSubview( controller.view )
		controller.view.translatesAutoresizingMaskIntoConstraints = false
		controller.view.pin()
		controller.didMove( toParent: self )
		controller.endAppearanceTransition()
	}

	/// Detaches a tab controller from the view hierarchy.
	func detach(
		_ controller: UIHostingController<AnyView>,
	) {

		guard controller.parent === self else { return }

		controller.beginAppearanceTransition( false, animated: false )
		controller.willMove( toParent: nil )
		controller.view.removeFromSuperview()
		controller.removeFromParent()
		controller.endAppearanceTransition()
	}

	/// Discards controllers whose tab identifiers have been removed.
	func removeObsoleteTabs(
		keeping validTags: Set<AnyHashable>,
	) {
		for ( tag, controller ) in hostingControllers where !validTags.contains( tag ) {
			detach( controller )
			hostingControllers.removeValue( forKey: tag )
			if selectedTag == tag {
				selectedTag = nil
			}
		}
	}
}
#endif
