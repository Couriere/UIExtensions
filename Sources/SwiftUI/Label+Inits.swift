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

extension Label where Title == Text, Icon == Image {

	/// Creates a label with an icon image and a title generated from a
	/// localized string key.
	///
	/// This initializer treats the localized key similar to
	/// ``Text/init(_:tableName:bundle:comment:)``. See ``Text`` for more
	/// information about localizing strings.
	///
	/// - Parameters:
	///    - titleKey: A title generated from a localized string key.
	///    - image: The image to use as the label's icon.
	///    - tableName: The name of the string table to search. If `nil`,
	///      use the table in the `Localizable.strings` file.
	///    - bundle: The bundle containing the strings file. If `nil`,
	///      use the main bundle.
	@inlinable
	public nonisolated init(
		_ titleKey: LocalizedStringKey,
		image: Image,
		tableName: String? = nil,
		bundle: Bundle? = nil
	) {
		self.init(
			title: { Text( titleKey, tableName: tableName, bundle: bundle ) },
			icon: { image }
		)
	}

	/// Creates a label with an icon image and a title generated from a
	/// string.
	///
	/// - Parameters:
	///    - title: A string used as the label's title.
	///    - image: The image to use as the label's icon.
	@inlinable @_disfavoredOverload
	public nonisolated init( _ title: some StringProtocol, image: Image ) {
		self.init( title: { Text( title ) }, icon: { image } )
	}
}
