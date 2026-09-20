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

extension RedactionReasons {

	/// A Boolean value indicating whether the reasons contain
	/// ``RedactionReasons/placeholder``.
	///
	/// Read the reasons from the environment to lay out a view
	/// differently while it stands in for content that is not
	/// available yet.
	///
	///     @Environment( \.redactionReasons ) private var redactionReasons
	///
	///     var body: some View {
	///         Text( value )
	///             .opacity( redactionReasons.isPlaceholder ? 0 : 1 )
	///     }
	@inlinable
	public var isPlaceholder: Bool { contains( .placeholder ) }

	/// A Boolean value indicating whether the reasons do not contain
	/// ``RedactionReasons/placeholder``.
	@inlinable
	public var isNotPlaceholder: Bool { !contains( .placeholder ) }

	/// A Boolean value indicating whether the reasons contain
	/// ``RedactionReasons/privacy``.
	///
	/// The system sets this reason for content that should be
	/// obscured from casual onlookers, such as a balance shown
	/// in a widget on the Lock Screen.
	@inlinable
	public var isPrivacy: Bool { contains( .privacy ) }

	/// A Boolean value indicating whether the reasons do not contain
	/// ``RedactionReasons/privacy``.
	@inlinable
	public var isNotPrivacy: Bool { !contains( .privacy ) }

	/// A Boolean value indicating whether the reasons contain
	/// ``RedactionReasons/invalidated``.
	///
	/// The system sets this reason for content that is displayed
	/// but is known to be out of date, such as a widget whose
	/// timeline has not been refreshed yet.
	@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
	@inlinable
	public var isInvalidated: Bool { contains( .invalidated ) }

	/// A Boolean value indicating whether the reasons do not contain
	/// ``RedactionReasons/invalidated``.
	@available( iOS 17, macOS 14, tvOS 17, watchOS 10, * )
	@inlinable
	public var isNotInvalidated: Bool { !contains( .invalidated ) }
}
