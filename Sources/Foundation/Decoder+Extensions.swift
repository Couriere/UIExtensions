//
//  Decoder+Extensions.swift
//  UIExtensions iOS
//
//  Created by Vladimir on 26/03/2019.
//  Copyright © 2019 Vladimir Kazantsev. All rights reserved.
//

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
