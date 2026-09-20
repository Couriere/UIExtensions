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

import Foundation

/// An asynchronous sequence that emits an element at a regular interval.
///
/// Each element is the duration that actually elapsed since the previous
/// tick, which may exceed `interval` when the task was suspended or the
/// system was busy. Ticks are scheduled against the instant the previous
/// one was due rather than the instant it was delivered, so the sequence
/// does not drift.
///
///     for await elapsed in AsyncTimer.schedule( every: .seconds( 1 )) {
///         remaining -= elapsed
///     }
///
/// The sequence finishes when the task it runs in is cancelled.
@available( iOS 16, macOS 13, tvOS 16, watchOS 9, * )
public struct AsyncTimer<C: Clock>: AsyncSequence, Sendable {

	public typealias Element = C.Duration
	public typealias Failure = Never

	/// The interval between two consecutive ticks.
	public let interval: C.Duration

	/// The maximum allowed deviation from `interval`.
	///
	/// A larger tolerance lets the system coalesce wake-ups and save power.
	public var tolerance: C.Duration?

	/// The clock used to schedule the ticks.
	public let clock: C

	/// Creates a timer sequence ticking on the given clock.
	///
	/// - Parameters:
	///   - interval: The interval between two consecutive ticks.
	///   - tolerance: The maximum allowed deviation from `interval`.
	///     Pass `nil` to use the clock's default tolerance.
	///   - clock: The clock used to schedule the ticks.
	@inlinable
	public init(
		interval: C.Duration,
		tolerance: C.Duration? = nil,
		clock: C,
	) {
		self.interval = interval
		self.tolerance = tolerance
		self.clock = clock
	}

	public func makeAsyncIterator() -> AsyncTimerIterator {
		AsyncTimerIterator(
			interval: interval,
			tolerance: tolerance,
			clock: clock,
		)
	}
}

// MARK: AsyncTimer.AsyncTimerIterator

@available( iOS 16, macOS 13, tvOS 16, watchOS 9, * )
extension AsyncTimer {

	/// The iterator that produces the ticks of an ``AsyncTimer``.
	public struct AsyncTimerIterator: AsyncIteratorProtocol {

		private let interval: C.Duration
		private let tolerance: C.Duration?
		private var clock: C?
		private var lastTick: C.Instant?

		/// Creates an iterator ticking on the given clock.
		///
		/// - Parameters:
		///   - interval: The interval between two consecutive ticks.
		///   - tolerance: The maximum allowed deviation from `interval`.
		///   - clock: The clock used to schedule the ticks.
		public init(
			interval: C.Duration,
			tolerance: C.Duration?,
			clock: C,
		) {
			self.interval = interval
			self.tolerance = tolerance
			self.clock = clock
		}

		/// Waits for the next tick.
		///
		/// - Returns: The duration elapsed since the previous tick,
		///   or `nil` if the surrounding task was cancelled.
		public mutating func next() async -> C.Duration? {

			guard let clock else { return nil }

			let now = lastTick ?? clock.now
			let wakeDate = now.advanced( by: interval )

			do {
				try await clock.sleep( until: wakeDate, tolerance: tolerance )
				let duration = now.duration( to: clock.now )
				lastTick = wakeDate
				return duration
			}
			catch {
				self.clock = nil
				return nil
			}
		}
	}
}

@available( iOS 16, macOS 13, tvOS 16, watchOS 9, * )
extension AsyncTimer where C == ContinuousClock {

	/// Creates a timer sequence ticking on the continuous clock.
	///
	/// - Parameters:
	///   - interval: The interval between two consecutive ticks.
	///   - tolerance: The maximum allowed deviation from `interval`.
	///     Pass `nil` to use the clock's default tolerance.
	/// - Returns: A sequence emitting the duration elapsed since the previous tick.
	@inlinable
	public static func schedule(
		every interval: Duration,
		tolerance: Duration? = nil,
	) -> AsyncTimer<ContinuousClock> {
		AsyncTimer(
			interval: interval,
			tolerance: tolerance,
			clock: ContinuousClock(),
		)
	}

	/// Creates a timer sequence ticking on the continuous clock.
	///
	/// - Parameters:
	///   - interval: The interval between two consecutive ticks, in seconds.
	///   - tolerance: The maximum allowed deviation from `interval`.
	///     Pass `nil` to use the clock's default tolerance.
	/// - Returns: A sequence emitting the duration elapsed since the previous tick.
	@inlinable
	public static func schedule(
		every interval: TimeInterval,
		tolerance: Duration? = nil,
	) -> AsyncTimer<ContinuousClock> {
		AsyncTimer(
			interval: .seconds( interval ),
			tolerance: tolerance,
			clock: ContinuousClock(),
		)
	}
}
