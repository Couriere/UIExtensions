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
import UIKit

public extension Date {

	// ..<
	@available( swift, deprecated: 4.2, message: "Use isBetween(_: and: )" )
	func isBetweenDate( _ firstDate: Date, andDate secondDate: Date ) -> Bool {
		let startResult = firstDate.compare( self )
		return ( startResult == .orderedSame || startResult == .orderedAscending ) && compare( secondDate ) == .orderedAscending
	}

	@available( swift, deprecated: 4.2, message: "Use Date.addingMonths(_:)" )
	func dateByAddingMonths( _ months: Int ) -> Date {
		return addingMonths( months )
	}
}

public extension Dictionary {
	
	@available( swift, deprecated: 4.0, obsoleted: 5.0, message: "Use Dictionary( uniqueKeysWithValues: ) instead" )
	init(_ elements: [Element]) {
		self.init()
		for (k, v) in elements {
			self[k] = v
		}
	}

	@available( swift, deprecated: 4.0, obsoleted: 5.0, message: "Use `Dictionary[ key, default: value ] instead" )
	subscript(key: Key, defaultValue: Value ) -> Value {
		if let value = self[ key ] {
			return value
		}
		else {
			return defaultValue
		}
	}
}

public extension URL {

#if os( iOS )
	@available( iOS, deprecated: 11.0, message: "Use UIDevice.current.freeSpace instead" )
	var freeSpace: Int64? {
		if #available( iOS 11, * ) {
			return UIDevice.current.freeSpace
		}
		let systemAttributes = try? FileManager.default.attributesOfFileSystem( forPath: path )
		let freeSpace = ( systemAttributes?[ FileAttributeKey.systemFreeSize ] as? NSNumber )?.int64Value
		return freeSpace
	}
#endif
}


@available( swift, deprecated: 5.1, message: "User @UserDefault property wrapper instead." )
public final class DefaultsKey<T> {

	public let key: String
	public let userDefaults: UserDefaults

	private let archive: ( ( T ) throws -> Any )?
	private let unarchive: ( ( Any? ) throws -> T? )?

	public init(
		key: String,
		userDefaults: UserDefaults = UserDefaults.standard,
		archive: ( ( T ) throws -> Any )? = nil,
		unarchive: ( ( Any? ) throws -> T? )? = nil ) {

		self.key = key
		self.userDefaults = userDefaults

		switch "\(T.self)" {
		case NSStringFromClass( UIColor.self ):
			self.archive = { color in
				NSKeyedArchiver.archivedData( withRootObject: color )
			}
			self.unarchive = { object in
				guard let data = object as? Data else { return nil }
				return NSKeyedUnarchiver.unarchiveObject( with: data ) as? T
			}

		default:
			self.archive = archive
			self.unarchive = unarchive
		}
	}

	public subscript() -> T? {
		get { return unarchiveValue() }
		set { userDefaults.setValue( archiveValue( newValue ), forKey: key ) }
	}

	public subscript( defaultValue: T ) -> T {
		get { return unarchiveValue() ?? defaultValue }
		set { userDefaults.setValue( archiveValue( newValue ), forKey: key ) }
	}

	public func remove() {
		userDefaults.removeObject( forKey: key )
	}


	private func unarchiveValue() -> T? {
		let data = userDefaults.value( forKey: key )
		guard let unarchive = unarchive else { return data as? T }
		do { return try unarchive( data ) } catch { return nil }
	}

	private func archiveValue( _ value: T? ) -> Any? {
		guard let value = value else { return nil }
		guard let archive = archive else { return value }
		do { return try archive( value ) } catch { return nil }
	}
}
