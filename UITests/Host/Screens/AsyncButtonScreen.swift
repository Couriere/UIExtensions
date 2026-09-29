import SwiftUI
import UIExtensions

struct AsyncButtonScreen: View {
	let cancelsOnDisappear: Bool
	@State private var operation = ControlledOperation()

	var body: some View {
		NavigationStack {
			VStack( spacing: 20 ) {
				AsyncButton( "Run", cancelsOnDisappear: cancelsOnDisappear ) {
					await operation.run()
				}
				.accessibilityIdentifier( AsyncButtonID.button )
				Text( "Started: \( operation.started )" )
					.accessibilityIdentifier( AsyncButtonID.started )
				Text( "Pending: \( operation.isPending ? 1 : 0 )" )
					.accessibilityIdentifier( AsyncButtonID.pending )
				Text( "Cancelled: \( operation.cancelled )" )
					.accessibilityIdentifier( AsyncButtonID.cancelled )
				Text( "Completed: \( operation.completed )" )
					.accessibilityIdentifier( AsyncButtonID.completed )
				Button( "Complete" ) { operation.complete() }
					.accessibilityIdentifier( AsyncButtonID.complete )
				NavigationLink( "Details" ) {
					Text( "Details" )
						.accessibilityIdentifier( AsyncButtonID.details )
				}
				.accessibilityIdentifier( AsyncButtonID.openDetails )
			}
			.navigationTitle( "AsyncButton" )
		}
	}
}

@MainActor
@Observable
private final class ControlledOperation {
	private var continuation: CheckedContinuation<Void, Never>?
	private( set ) var started = 0
	private( set ) var cancelled = 0
	private( set ) var completed = 0
	var isPending: Bool { continuation != nil }

	func run() async {
		started += 1
		await withTaskCancellationHandler {
			await withCheckedContinuation { continuation in
				self.continuation = continuation
			}
		} onCancel: {
			Task { @MainActor in self.cancel() }
		}
		if !Task.isCancelled { completed += 1 }
	}

	func complete() {
		let pending = continuation
		continuation = nil
		pending?.resume()
	}

	private func cancel() {
		guard continuation != nil else { return }
		cancelled += 1
		complete()
	}
}
