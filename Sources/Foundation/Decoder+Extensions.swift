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

private struct DecoderDummyEmptyValue: Decodable {}

public extension UnkeyedDecodingContainer {

	/// Iterates over unkeyed container elements trying to decode each element.
	/// If element decoding fails, method skips it and continiues to the next.
	mutating func compactDecode<T: Decodable>() -> [ T ] {

		var result: [ T ] = []
		while !isAtEnd {
			if let value = try? self.decode( T.self ) {
				result.append( value )
			}
			else {
				_ = try? decode( DecoderDummyEmptyValue.self )
			}
		}
		return result
	}
}

private let fractionalSecondsFormatStyle = Date.ISO8601FormatStyle( includingFractionalSeconds: true )
private let wholeSecondsFormatStyle = Date.ISO8601FormatStyle()

extension JSONDecoder.DateDecodingStrategy {

	/// A strategy that decodes ISO 8601 dates with or without
	/// fractional seconds.
	///
	/// The system `iso8601` strategy matches the format exactly: fractional
	/// seconds are either always required or always rejected, so a payload
	/// that mixes `2026-08-17T05:32:17Z` and `2026-08-17T05:32:17.289731Z`
	/// fails to decode. This strategy accepts both spellings.
	///
	///     decoder.dateDecodingStrategy = .iso8601Lenient
	@available(
		anyAppleOS,
		deprecated: 26.0,
		message: "The system `iso8601` strategy parses fractional seconds itself starting with version 26"
	)
	public static let iso8601Lenient = custom { decoder in

		let string = try decoder.singleValueContainer().decode( String.self )

		if let date = try? fractionalSecondsFormatStyle.parse( string ) {
			return date
		}

		if let date = try? wholeSecondsFormatStyle.parse( string ) {
			return date
		}

		throw DecodingError.dataCorrupted(
			.init(
				codingPath: decoder.codingPath,
				debugDescription: "Expected an ISO8601 formatted date, got: \( string )",
			),
		)
	}
}
