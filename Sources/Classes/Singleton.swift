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

@propertyWrapper
public struct Singleton<ObjectType> {

	/// The underlying value referenced by the environment object.
	public var wrappedValue: ObjectType {
		get {
			if let value = get() { return value }

			let typeName = String( reflecting: ObjectType.self )
				.split( separator: "." )
				.dropFirst()
				.joined( separator: "." )

			fatalError( "Object of type `\( typeName )` does not exist in Singleton")
		}
		set { Singleton.set( newValue ) }
	}

	public var projectedValue: Singleton<ObjectType> {
		return self
	}

	public func get() -> ObjectType? {
		_singletonStorage.first( where: { $0 is ObjectType } ) as? ObjectType
	}

	public static func set( _ value: ObjectType ) {
		if let index = _singletonStorage.firstIndex( where: { $0 is ObjectType } ) {
			_singletonStorage.remove( at: index )
		}

		_singletonStorage.append( value )
	}

	public init() {
	}
}

private var _singletonStorage: [ Any ] = []
