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

extension NSRegularExpression {

	/// Returns a Boolean value indicating whether the expression
	/// matches anywhere in the given string.
	///
	/// Use this method when only the presence of a match matters.
	/// To inspect the match itself, use
	/// `firstMatch( in:options:range: )` instead.
	///
	/// - Parameter string: The string to search.
	/// - Returns: `true` if the expression matches a part of the string,
	///   otherwise `false`.
	///
	/// - Note: Code targeting iOS 16 and later can use the `Regex` type
	///   and `string.contains( regex )` instead.
	@inlinable
	public func isMatches( _ string: String ) -> Bool {
		firstMatch( in: string, options: [], range: string.nsRange ) != nil
	}
}
