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

/// A wrapper that force-declares a value as `Sendable`.
///
/// `UnsafeSendable` can be used to bridge values that are not statically
/// `Sendable` into concurrency contexts that require sendability (e.g.,
/// passing across actor boundaries or into `Task` closures).
///
/// Important
/// Using this type opts you out of the compiler's data-race safety checks.
/// You, as the author, are responsible for ensuring the wrapped value is
/// actually safe to share across concurrency domains. Misuse can lead to
/// undefined behavior and data races.
///
/// Discussion
/// Prefer making your types conform to `Sendable` (or using immutable
/// value types) whenever possible. Reach for `UnsafeSendable` only as a
/// last resort—for example, when interacting with legacy APIs or types you
/// cannot modify.
///
/// Example
/// ```swift
/// // A non-Sendable reference type
/// final class LegacyController { /* ... */ }
///
/// let controller = LegacyController()
/// // Wrap it to pass into a Task
/// let sendableController = UnsafeSendable(controller)
///
/// Task { @MainActor in
///     // Use with care; you are responsible for thread safety
///     _ = sendableController.value
/// }
/// ```
public struct UnsafeSendable<T>: @unchecked Sendable {
    /// The wrapped value that is being treated as `Sendable`.
    public let value: T

    /// Creates a wrapper that treats `value` as `Sendable`.
    /// - Parameter value: The value to wrap.
    public init(_ value: T) { self.value = value }
}
