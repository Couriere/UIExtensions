/// MIT License
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

public extension Task where Success == Never, Failure == Never {
	static func sleep( seconds: TimeInterval ) async throws {
		try await sleep( nanoseconds: UInt64.seconds( seconds ))
	}
	static func sleep<I: UnsignedInteger>( seconds: I ) async throws {
		try await sleep( nanoseconds: UInt64.seconds( seconds ))
	}
	static func sleep<I: UnsignedInteger>( miliseconds: I ) async throws {
		try await sleep( nanoseconds: UInt64.miliseconds( miliseconds ))
	}
	static func sleep<I: UnsignedInteger>( microseconds: I ) async throws {
		try await sleep( nanoseconds: UInt64.microseconds( microseconds ))
	}
}

extension Task where Success == Never, Failure == Never {

	/// Waits for the given interval and then runs the action, unless the
	/// surrounding task is cancelled first.
	///
	/// Call this from a task that is restarted whenever the input changes,
	/// such as `task( id: )` in SwiftUI: every change cancels the previous
	/// task during its delay, so the action only runs once the input has
	/// settled.
	///
	///     .task( id: query ) {
	///         await Task.debounce( for: 0.3 ) {
	///             await search( query )
	///         }
	///     }
	///
	/// - Parameters:
	///   - timeInterval: The quiet period, in seconds, that must pass
	///     before the action runs.
	///   - action: The action to run once the delay has elapsed.
	// NOTE: The action stays `@escaping @Sendable` on purpose. Rewriting it as
	// `sending @escaping @isolated(any)` requires function type metadata that is
	// not back-deployed and crashes at runtime on systems older than iOS 18.
	// Revisit once the minimum deployment target reaches iOS 18.
	public static func debounce(
		for timeInterval: TimeInterval,
		@_inheritActorContext _ action: @escaping @Sendable () async -> Void,
	) async {

		do {
			try await Task.sleep( seconds: timeInterval )
			await action()
		}
		catch {
			// Cancelled during the delay: the action is skipped on purpose.
		}
	}
}
