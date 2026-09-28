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

import Testing
@testable import UIExtensions

private struct LoadError: Error, Equatable {}

/// Suspends loading actions until the test resumes them,
/// so the test controls the order in which loads complete.
@MainActor
private final class PendingLoads {

	private var continuations: [CheckedContinuation<Int, any Error>] = []

	/// The action to pass to the model. Every call waits to be resumed.
	func action( _: Int ) async throws -> Int {
		try await withCheckedThrowingContinuation { continuations.append( $0 ) }
	}

	/// Resumes the oldest pending load with a value.
	func resume( returning value: Int ) async {
		await waitForPendingLoad()
		continuations.removeFirst().resume( returning: value )
	}

	/// Resumes the oldest pending load with an error.
	func resume( throwing error: any Error ) async {
		await waitForPendingLoad()
		continuations.removeFirst().resume( throwing: error )
	}

	/// Lets the started loading tasks reach the action.
	private func waitForPendingLoad() async {
		while continuations.isEmpty {
			await Task.yield()
		}
	}
}

@MainActor
struct `Loader model` {

	let model = LoaderModel<Int, Int>()

	// MARK: Loading

	@Test
	func `Load passes the input to the action and stores the output`() async {
		await model.load( 21, reason: .appear, options: [] ) { $0 * 2 }.value

		#expect( model.output == 42 )
		#expect( model.failure == nil )
		#expect( !model.isLoading )
	}

	@Test
	func `Load reports loading until the action finishes`() async {
		let pending = PendingLoads()

		let task = model.load( 0, reason: .appear, options: [], action: pending.action )
		#expect( model.isLoading )
		#expect( model.contentState.isLoading )

		await pending.resume( returning: 1 )
		await task.value

		#expect( !model.isLoading )
		#expect( !model.contentState.isLoading )
	}

	@Test
	func `Load stores the error thrown by the action`() async {
		await model.load( 0, reason: .appear, options: [] ) { _ in throw LoadError() }.value

		#expect( model.failure is LoadError )
		#expect( model.output == nil )
		#expect( !model.isLoading )
	}

	@Test
	func `Load clears the previous failure`() async {
		let pending = PendingLoads()
		await model.load( 0, reason: .appear, options: [] ) { _ in throw LoadError() }.value

		let task = model.load( 0, reason: .reload, options: [], action: pending.action )
		#expect( model.failure == nil )

		await pending.resume( returning: 1 )
		await task.value
	}

	@Test
	func `Failure keeps the output of a previous load`() async {
		await model.load( 0, reason: .appear, options: [] ) { _ in 1 }.value
		await model.load( 0, reason: .reload, options: [] ) { _ in throw LoadError() }.value

		#expect( model.output == 1 )
		#expect( model.failure is LoadError )
	}

	// MARK: Clearing

	@Test(
		arguments: [
			( .reload, .clearOnReload, true ),
			( .reload, .clearOnAppear, false ),
			( .reload, [], false ),
			( .appear, .clearOnAppear, true ),
			( .appear, .clearOnReload, false ),
			( .appear, [], false ),
		] as [ ( LoaderModel<Int, Int>.Reason, ReloadOptions, Bool ) ],
	)
	func `Load clears the output according to reload options`(
		reason: LoaderModel<Int, Int>.Reason,
		options: ReloadOptions,
		clears: Bool,
	) async {
		let pending = PendingLoads()
		await model.load( 0, reason: .appear, options: [] ) { _ in 1 }.value

		let task = model.load( 0, reason: reason, options: options, action: pending.action )
		#expect( ( model.output == nil ) == clears )

		await pending.resume( returning: 2 )
		await task.value
		#expect( model.output == 2 )
	}

	// MARK: Cancellation

	@Test
	func `New load cancels the load in progress`() async {
		let pending = PendingLoads()

		let first = model.load( 1, reason: .appear, options: [], action: pending.action )
		let second = model.load( 2, reason: .reload, options: [], action: pending.action )

		await pending.resume( returning: 1 )
		await first.value
		#expect( model.output == nil )
		#expect( model.isLoading )

		await pending.resume( returning: 2 )
		await second.value
		#expect( model.output == 2 )
		#expect( !model.isLoading )
	}

	@Test
	func `Cancelled load ignores the output`() async {
		let pending = PendingLoads()

		let task = model.load( 0, reason: .appear, options: [], action: pending.action )
		model.cancel()
		#expect( !model.isLoading )

		await pending.resume( returning: 1 )
		await task.value
		#expect( model.output == nil )
		#expect( !model.isLoading )
	}

	@Test
	func `Cancelled load ignores the error`() async {
		let pending = PendingLoads()

		let task = model.load( 0, reason: .appear, options: [], action: pending.action )
		model.cancel()

		await pending.resume( throwing: LoadError() )
		await task.value
		#expect( model.failure == nil )
	}

	@Test
	func `Load treats cancellation error of the superseded load as cancellation`() async {
		let pending = PendingLoads()

		let first = model.load( 0, reason: .appear, options: [], action: pending.action )
		let second = model.load( 0, reason: .reload, options: [], action: pending.action )

		await pending.resume( throwing: CancellationError() )
		await first.value
		#expect( model.failure == nil )
		#expect( model.isLoading )

		await pending.resume( returning: 1 )
		await second.value
	}

	@Test
	func `Wait for completion returns after the current load finishes`() async {
		let pending = PendingLoads()
		model.load( 0, reason: .appear, options: [], action: pending.action )

		let waiter = Task { await model.waitForCompletion() }
		await pending.resume( returning: 1 )
		await waiter.value

		#expect( model.output == 1 )
	}

	@Test
	func `Wait for completion returns immediately without a load`() async {
		await model.waitForCompletion()

		#expect( model.output == nil )
	}

	// MARK: Loading on appear

	@Test(
		arguments: [
			( [], false, true ),
			( .disableAutoLoad, false, false ),
			( [ .disableAutoLoad, .reloadOnAppear ], false, false ),
			( [], true, false ),
			( .reloadOnAppear, true, true ),
			( [ .disableAutoLoad, .reloadOnAppear ], true, true ),
		] as [ ( ReloadOptions, Bool, Bool ) ],
	)
	func `Loads on appear only when needed`(
		options: ReloadOptions,
		hasOutput: Bool,
		expected: Bool,
	) async {
		if hasOutput {
			await model.load( 0, reason: .appear, options: [] ) { _ in 1 }.value
		}

		let task = model.onAppear( 0, options: options ) { _ in 2 }
		#expect(( task != nil ) == expected )
		await task?.value
		#expect( model.output == ( expected ? 2 : hasOutput ? 1 : nil ))
	}

	// MARK: Just loaded

	@Test
	func `Content state is just loaded after the first load`() async {
		await model.load( 0, reason: .appear, options: [] ) { _ in 1 }.value
		#expect( model.contentState == .justLoaded )

		model.contentDidAppear()
		#expect( model.contentState == [] )
	}

	@Test
	func `Content state is not just loaded when reloading over existing output`() async {
		await model.load( 0, reason: .appear, options: [] ) { _ in 1 }.value
		model.contentDidAppear()

		await model.load( 0, reason: .reload, options: [] ) { _ in 2 }.value
		#expect( !model.contentState.isJustLoaded )
	}

	@Test
	func `Content state is just loaded again after a clearing reload`() async {
		await model.load( 0, reason: .appear, options: [] ) { _ in 1 }.value
		model.contentDidAppear()

		await model.load( 0, reason: .reload, options: .clearOnReload ) { _ in 2 }.value
		#expect( model.contentState.isJustLoaded )
	}

	@Test
	func `Content state combines loading and just loaded`() async {
		let pending = PendingLoads()
		await model.load( 0, reason: .appear, options: [] ) { _ in 1 }.value

		let task = model.load( 0, reason: .reload, options: [], action: pending.action )
		#expect( model.contentState == [ .loading, .justLoaded ] )

		await pending.resume( returning: 2 )
		await task.value
	}
}

struct `Loader content state` {

	@Test
	func `Flags reflect the options`() {
		#expect( LoaderContentState.loading.isLoading )
		#expect( !LoaderContentState.loading.isPlaceholder )
		#expect( LoaderContentState.placeholder.isPlaceholder )
		#expect( LoaderContentState.justLoaded.isJustLoaded )
		#expect( !LoaderContentState().isLoading )
	}

	@Test
	func `Loading placeholder combines loading and placeholder`() {
		let state = LoaderContentState.loadingPlaceholder

		#expect( state.isLoading )
		#expect( state.isPlaceholder )
		#expect( !state.isJustLoaded )
	}
}
