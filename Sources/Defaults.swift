//
//  Defaults.swift
//  UIExtensions iOS
//
//  Created by Vladimir Kazantsev on 23/04/16.
//  Copyright © 2016 Vladimir Kazantsev. All rights reserved.
//

import UIKit



final public class DefaultsKey<T> {
	
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
				return NSKeyedArchiver.archivedData( withRootObject: color )
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
		let data = userDefaults.value( forKey: self.key )
		guard let unarchive = unarchive else { return data as? T }
		do { return try unarchive( data ) } catch { return nil }
	}
	private func archiveValue( _ value: T? ) -> Any? {
		guard let value = value else { return nil }
		guard let archive = archive else { return value }
		do { return try archive( value ) } catch { return nil }
	}
}
