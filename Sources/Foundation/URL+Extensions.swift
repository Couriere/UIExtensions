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

extension URL {

	public static let empty = URL( static: "https://" )

	/// Initializes a new URL with the provided `string`.
	///	- parameter string: A `StaticString` representation of the URL.
	///	- returns: A newly initialized `URL` object.
	public init( static string: StaticString ) {
		let string = string.withUTF8Buffer {
			String( decoding: $0, as: UTF8.self )
		}
		self.init( string: string )!
	}
}

extension URL {

	/// Returns a URL that ensures the path ends
	/// with a trailing slash.
	///
	/// If the receiver's path does not end with `/`,
	/// a slash is appended and a new URL is returned.
	/// If the URL cannot be reconstructed from components,
	/// the original URL is returned.
	public var ensureTrailingSlash: URL {

		guard var components = URLComponents(
			url: self,
			resolvingAgainstBaseURL: false
		) else {
			return self
		}

		if !components.path.hasSuffix("/") {
			components.path += "/"
		}

		return components.url ?? self
	}

	/// Returns a new URL with the query component removed.
	/// - returns: A new `URL` object with the query component removed.
	public var urlByDeletingQuery: URL? {
		var components = URLComponents( url: self, resolvingAgainstBaseURL: false )
		components?.query = nil
		return components?.url
	}

#if os(iOS) || os(tvOS)

	// MARK: - System paths

	public static var libraryPath: URL {
		let path = try! FileManager.default.url( for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false )
		return path
	}

	public static var documentsPath: URL {
		let path = try! FileManager.default.url( for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false )
		return path
	}

	public static var cachePath: URL {
		let path = try! FileManager.default.url( for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false )
		return path
	}
#endif
}

