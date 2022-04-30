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
import Combine

#if canImport(UIKit)
@available(iOS 14.0, tvOS 14.0, *)
public extension View {

	/// Presents a modal view that covers as much of the screen as
	/// possible using the binding you provide as a data source for the
	/// sheet's content.
	///
	/// - Parameters:
	///   - item: A binding to an optional source of truth for the sheet.
	///     When `item` is non-`nil`, the system passes the contents to
	///     the modifier's closure. You display this content in a sheet that you
	///     create that the system displays to the user. If `item` changes,
	///     the system dismisses the currently displayed sheet and replaces
	///     it with a new one using the same process.
	///   - transitionStyle: Animation style with which the modal view is presented.
	///   - presentationStyle: Style with which the system presents the modal view.
	///   - onDismiss: The closure to execute when dismissing the modal view.
	///   - content: A closure returning the content of the modal view.
	func fullScreenCover<Item: Identifiable, Content: View>(
		item: Binding<Item?>,
		onDismiss: (() -> Void)? = nil,
		transitionStyle: UIModalTransitionStyle,
		presentationStyle: UIModalPresentationStyle = .overFullScreen,
		@ViewBuilder content: @escaping ( Item ) -> Content
	) -> some View {

		FullScreenView( isPresented: .constant( true ),
						item: item,
						onDismiss: onDismiss,
						content: content,
						transitionStyle: transitionStyle,
						presentationStyle: presentationStyle,
						parentContent: self )
	}

	/// Presents a modal view that covers as much of the screen as
	/// possible when binding to a Boolean value you provide is true.
	///
	/// - Parameters:
	///   - isPresented: A binding to a Boolean value that determines whether
	///     to present the modal view.
	///   - onDismiss: The closure to execute when dismissing the modal view.
	///   - transitionStyle: Animation style with which the modal view is presented.
	///   - presentationStyle: Style with which the system presents the modal view.
	///   - content: A closure that returns the content of the modal view.
	func fullScreenCover<Content: View>(
		isPresented: Binding<Bool>,
		onDismiss: (() -> Void)? = nil,
		transitionStyle: UIModalTransitionStyle = .crossDissolve,
		presentationStyle: UIModalPresentationStyle = .overFullScreen,
		@ViewBuilder content: @escaping () -> Content
	) -> some View {

		FullScreenView( isPresented: isPresented,
						item: .constant( __DummyIdentifiable() ),
						onDismiss: onDismiss,
						content: { _ in content() },
						transitionStyle: transitionStyle,
						presentationStyle: presentationStyle,
						parentContent: self )
	}
}

@available(iOS 14.0, tvOS 14.0, *)
private struct FullScreenView<Item: Identifiable, ParentContent: View, PopupView: View>: View {

	@Binding var isPresented: Bool
	@Binding var item: Item?
	let onDismiss: ( () -> Void )?

	@ViewBuilder let content: ( Item ) -> PopupView

	let transitionStyle: UIModalTransitionStyle
	let presentationStyle: UIModalPresentationStyle
	let parentContent: ParentContent

	@State private var underlyingViewController: UIViewController?

	var body: some View {
		parentContent
			._underlyingViewController { underlyingViewController = $0 }
			.onChange( of: isPresented ) { _ in presentOrDismissFullScreenCover() }
			.onChange(of: item?.id ) { _ in presentOrDismissFullScreenCover() }
	}
}

@available(iOS 14.0, tvOS 14.0, *)
private extension FullScreenView {

	final class WrappedHostingController<V: View>: UIHostingController<V>, UIAdaptivePresentationControllerDelegate {

		let onDismiss: (() -> Void)?

		init( rootView: V, onDismiss: (() -> Void)? ) {
			self.onDismiss = onDismiss
			super.init( rootView: rootView )
		}
		override func viewDidLoad() {
			super.viewDidLoad()
			presentationController?.delegate = self
		}
		@MainActor required dynamic init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}


		func presentationControllerDidDismiss(
			_ presentationController: UIPresentationController
		) {
			onDismiss?()
		}
	}

	/// Показывает или скрывает окно на весь экран.
	private func presentOrDismissFullScreenCover() {

		let userDismissHandler = {
			isPresented = false
			item = nil
			onDismiss?()
		}

		switch ( isPresented, item, underlyingViewController?.presentedViewController ) {
		case ( true, .some( let parameter ), nil ):
			let overlay = WrappedHostingController( rootView: content( parameter ),
													onDismiss: userDismissHandler )
			overlay.modalTransitionStyle = transitionStyle
			overlay.modalPresentationStyle = presentationStyle
			overlay.view.backgroundColor = .clear

			underlyingViewController?.present( overlay, animated: true )

		case let ( true, .some( parameter ), .some ):
			underlyingViewController?.dismiss( animated: true ) {
				let overlay = WrappedHostingController( rootView: content( parameter ),
														onDismiss: userDismissHandler )
				overlay.modalTransitionStyle = transitionStyle
				overlay.modalPresentationStyle = presentationStyle
				overlay.view.backgroundColor = .clear

				underlyingViewController?.present( overlay, animated: true )
			}

		case ( false, _, .some ):
			underlyingViewController?.dismiss( animated: true, completion: onDismiss )
		case ( _, nil, .some ):
			underlyingViewController?.dismiss( animated: true, completion: onDismiss )

		default:
			break
		}
	}
}


@available(iOS 14.0, tvOS 14.0, *)
private struct _UIKitIntrospectionViewController: UIViewControllerRepresentable {

	let handler: ( UIViewController ) -> Void

	func makeUIViewController( context: Context ) -> UIViewController {
		return UIViewController()
	}

	func updateUIViewController(
		_ uiViewController: UIViewController,
		context: Context
	) {
		DispatchQueue.main.async {
			guard let parent = uiViewController.parent else { return }
			handler( parent )
		}
	}
}

@available(iOS 14.0, tvOS 14.0, *)
private extension View {

	func _underlyingViewController(
		handler: @escaping ( UIViewController ) -> Void
	) -> some View {
		let introspectView = _UIKitIntrospectionViewController( handler: handler )
		return self
			.overlay( introspectView.frame( width: 0, height: 0 ))
	}
}

@available(iOS 14.0, tvOS 14.0, *)
private struct __DummyIdentifiable: Identifiable { public let id = 0 }


@available(iOS 14.0, tvOS 14.0, *)
struct FullScreenPopup_Previews: PreviewProvider {

	@State private static var isPresented: Bool = false

	static var previews: some View {
		Button( "Show Custom PopUp View" ) {
			isPresented.toggle()
		}
		.fullScreenCover(
			isPresented: $isPresented,
			content: { popupView }
		)
	}

	static var popupView: some View {

		RoundedRectangle( cornerRadius: 20.0 )
			.fill( Color.white )
			.frame( width: 300.0, height: 200.0 )
			.overlay(
				VStack {
					Button( "Dismiss" ) {
						isPresented = false
					}
				}
			)
			.shadow( radius: 10.0 )
			.blurredBackground()
	}
}
#endif
