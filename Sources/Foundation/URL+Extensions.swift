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

public extension URL {

	var URLByDeletingQuery: URL? {
		var components = URLComponents( url: self, resolvingAgainstBaseURL: false )
		components?.query = nil
		return components?.url
	}

	var freeSpace: Int64? {
		let systemAttributes = try? FileManager.default.attributesOfFileSystem( forPath: path )
		let freeSpace = ( systemAttributes?[ FileAttributeKey.systemFreeSize ] as? NSNumber )?.int64Value
		return freeSpace
	}

	#if os(iOS) || os(tvOS)

		// MARK: - System paths

		static var libraryPath: URL {
			let path = try! FileManager.default.url( for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false )
			return path
		}

		static var documentsPath: URL {
			let path = try! FileManager.default.url( for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false )
			return path
		}

		static var cachePath: URL {
			let path = try! FileManager.default.url( for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false )
			return path
		}
	#endif
}