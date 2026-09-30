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

import Combine
import Observation
import SwiftUI
import Synchronization

/// A property wrapper that stores a value in `UserDefaults`.
/// Similar to `@AppStorage`, but supports `Codable` types and can be used
/// in models as well as views.
///
/// Supports property list types such as `Bool`, `Int`, `String`, and `Date`,
/// `RawRepresentable` types with a property list `RawValue`, and other
/// `Codable` types. The value type must be `Sendable`.
/// An optional value without an explicit default starts as `nil`.
/// Choose a different store with `store` or `suiteName`:
/// ```
/// @CodableUserDefaults( "language", suiteName: appGroupId )
/// var language: Language = .ru
///
/// @CodableUserDefaults( "nextRatingRequest" )
/// var nextRatingRequest: Date?
/// ```
///
/// The wrapper can be used from any isolation domain.
///
/// ## Usage examples
///
/// ### In a view
/// ```
/// struct OnboardingView: View {
///
///     @CodableUserDefaults( "didShowOnboarding" )
///     private var didShowOnboarding: Bool = false
///
///     var body: some View {
///         Toggle( "Shown", isOn: $didShowOnboarding.binding )
///     }
/// }
/// ```
///
/// ### In an `ObservableObject`
/// Each value change sends `objectWillChange` to the owning object,
/// notifying its subscribers.
/// ```
/// final class AppearanceModel: ObservableObject {
///
///     @CodableUserDefaults( "theme" )
///     var theme: Theme = .system
/// }
/// ```
///
/// ### In an `@Observable` type
/// Mark the property with `@ObservationIgnored`. Otherwise, the macro
/// and wrapper generate storage with the same name, preventing compilation.
/// Observation still works because the wrapper registers value reads itself.
/// ```
/// @Observable
/// final class ProfileModel {
///
///     @ObservationIgnored
///     @CodableUserDefaults( "privacyModeEnabled" )
///     var privacyModeEnabled: Bool = false
/// }
/// ```
///
/// ## Projected value
/// The `$` projection provides `binding`, `publisher` (a Combine publisher
/// that first emits the current value), `exists`, and `remove()`:
/// ```
/// $language.publisher
///     .sink { print( $0 ) }
/// ```
///
/// - Important: The key must not contain periods. The wrapper observes
///   changes through KVO, which treats periods as key path separators.
///   Values can still be read and written, but changes will not be observed.
@propertyWrapper
public struct CodableUserDefaults<Value: Sendable>: Sendable {

	private let observer: _KVO
	private let key: String
	private let getValue: @Sendable ( _ store: UserDefaults ) -> Value
	private let setValue: @Sendable ( _ store: UserDefaults, _ newValue: Value ) -> Void

	private init(
		key: String,
		store: UserDefaults = .standard,
		getValue: @escaping @Sendable ( _ store: UserDefaults ) -> Value,
		setValue: @escaping @Sendable ( _ store: UserDefaults, _ newValue: Value ) -> Void,
	) {
		self.key = key
		self.observer = _KVO( store: store, key: key )
		self.getValue = getValue
		self.setValue = setValue
	}

	public func remove() {
		observer.removeObject()
	}

	public var exists: Bool {
		observer.trackAccess()
		return observer.exists
	}

	public var wrappedValue: Value {
		get {
			observer.trackAccess()
			return getValue( observer.store )
		}
		nonmutating set {
			setValue( observer.store, newValue )
		}
	}

	public var projectedValue: Self {
		self
	}

	public var binding: Binding<Value> {
		Binding(
			get: { wrappedValue },
			set: { wrappedValue = $0 },
		)
	}

	public var publisher: AnyPublisher<Value, Never> {
		observer.signal
			.map { wrappedValue }
			.prepend( wrappedValue )
			.eraseToAnyPublisher()
	}

	public static subscript<T>(
		_enclosingInstance instance: T,
		wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
		storage storageKeyPath: ReferenceWritableKeyPath<T, Self>,
	) -> Value {
		get {
			if let observableObject = instance as? any ObservableObject,
			   let publisher = observableObject
			   .objectWillChange as any Publisher as? ObservableObjectPublisher {

				instance[ keyPath: storageKeyPath ].observer.setEnclosingObjectWillChangePublisher( publisher )
			}
			return instance[ keyPath: storageKeyPath ].wrappedValue
		}
		set {
			instance[ keyPath: storageKeyPath ].wrappedValue = newValue
		}
	}
}

public extension CodableUserDefaults where Value: Codable {

	init(
		wrappedValue: Value,
		_ key: String,
		store: UserDefaults = .standard,
	) {
		self.init(
			key: key,
			store: store,
			getValue: { store in
				guard
					let rawData = store.object( forKey: key ) as? Data,
					let value = try? _userDefaults_decoder.decode( Value.self, from: rawData )
				else { return wrappedValue }

				return value
			},
			setValue: { store, newValue in
				if let optional = newValue as? any OptionalType, optional.value == nil {
					store.removeObject( forKey: key )
				}
				else if let data = try? _userDefaults_encoder.encode( newValue ) {
					store.set( data, forKey: key )
				}
			},
		)
	}

	init(
		wrappedValue: Value,
		_ key: String,
		suiteName: String,
	) {
		self.init(
			wrappedValue: wrappedValue,
			key,
			store: UserDefaults( suiteName: suiteName ) ?? .standard,
		)
	}

	init(
		_ key: String,
		store: UserDefaults = .standard,
	) where Value: ExpressibleByNilLiteral {
		self.init( wrappedValue: nil, key, store: store )
	}

	init(
		_ key: String,
		suiteName: String,
	) where Value: ExpressibleByNilLiteral {
		self.init( wrappedValue: nil, key, suiteName: suiteName )
	}
}

public extension CodableUserDefaults where Value: __PropertyList & Codable {

	init(
		wrappedValue: Value,
		_ key: String,
		store: UserDefaults = .standard,
	) {
		self.init(
			key: key,
			store: store,
			getValue: { store in store.object( forKey: key ) as? Value ?? wrappedValue },
			setValue: { store, newValue in store.set( newValue, forKey: key ) },
		)
	}

	init(
		wrappedValue: Value,
		_ key: String,
		suiteName: String,
	) {
		self.init(
			wrappedValue: wrappedValue,
			key,
			store: UserDefaults( suiteName: suiteName ) ?? .standard,
		)
	}

	init(
		_ key: String,
		store: UserDefaults = .standard,
	) where Value: ExpressibleByNilLiteral {
		self.init( wrappedValue: nil, key, store: store )
	}

	init(
		_ key: String,
		suiteName: String,
	) where Value: ExpressibleByNilLiteral {
		self.init( wrappedValue: nil, key, suiteName: suiteName )
	}
}

public extension CodableUserDefaults where Value: RawRepresentable, Value.RawValue: __PropertyList {

	init(
		wrappedValue: Value,
		_ key: String,
		store: UserDefaults = .standard,
	) {

		self.init(
			key: key,
			store: store,
			getValue: { store in
				guard
					let rawValue = store.object( forKey: key ) as? Value.RawValue,
					let value = Value( rawValue: rawValue )
				else { return wrappedValue }
				return value
			},
			setValue: { store, newValue in store.set( newValue.rawValue, forKey: key ) },
		)
	}

	init(
		wrappedValue: Value,
		_ key: String,
		store: UserDefaults = .standard,
		) where Value: Codable {

		self.init(
			key: key,
			store: store,
			getValue: { store in
				if let rawValue = store.object( forKey: key ) as? Value.RawValue,
				   let value = Value( rawValue: rawValue ) {
					return value
				}
				if let data = store.object( forKey: key ) as? Data,
				   let value = try? _userDefaults_decoder.decode( Value.self, from: data ) {
					return value
				}
				return wrappedValue
			},
			setValue: { store, newValue in store.set( newValue.rawValue, forKey: key ) },
		)
	}
}

public extension CodableUserDefaults where Value == Bool {
	mutating func toggle() {
		wrappedValue.toggle()
	}
}

// MARK: CodableUserDefaults._KVO

private extension CodableUserDefaults {

	/// Observes a `UserDefaults` key and forwards changes to Observation,
	/// Combine, and the owning `ObservableObject`.
	///
	/// ********** MAGIC ALERT **********
	/// `@unchecked Sendable` is safe because:
	/// - Apple documents `UserDefaults` as thread safe, although the SDK
	///   does not mark it as `Sendable`;
	/// - `ObservationRegistrar` and `PassthroughSubject` are thread safe;
	/// - the only mutable field, a reference to the owner's
	///   `objectWillChange` publisher, is protected by a `Mutex`;
	/// - this `ObservableObjectPublisher` is used only for `send()`,
	///   as it was before the migration to Swift 6.
	/// *********************************
	final class _KVO: NSObject, Observable, @unchecked Sendable {

		let signal = PassthroughSubject<Void, Never>()
		let store: UserDefaults

		private let registrar = ObservationRegistrar()
		private let enclosingObjectWillChangePublisher = Mutex( WeakPublisher() )

		init( store: UserDefaults, key: String ) {
			self.store = store
			self.keyPath = key

			super.init()

			store.addObserver(
				self,
				forKeyPath: key,
				options: .new,
				context: nil
			)
		}

		deinit {
			store.removeObserver(
				self,
				forKeyPath: keyPath
			)
		}

		override func observeValue(
			forKeyPath keyPath: String?,
			of object: Any?,
			change: [NSKeyValueChangeKey: Any]?,
			context: UnsafeMutableRawPointer?,
		) {
			if keyPath == self.keyPath {
				registrar.withMutation(
					of: self,
					keyPath: \.value
				) {}
				signal.send(())
				enclosingObjectWillChangePublisher
					.withLock { $0.publisher }?
					.send()
			}
		}

		/// Registers a value read so SwiftUI updates the view when it changes.
		func trackAccess() {
			registrar.access( self, keyPath: \.value )
		}

		func setEnclosingObjectWillChangePublisher( _ publisher: ObservableObjectPublisher ) {
			enclosingObjectWillChangePublisher.withLock { $0.publisher = publisher }
		}

		func removeObject() {
			store.removeObject( forKey: keyPath )
		}

		var exists: Bool {
			store.value( forKey: keyPath ) != nil
		}

		/// An Observation key that records reads and changes; the actual value
		/// remains in `UserDefaults`.
		private var value: Void { () }

		private let keyPath: String
	}

	/// The `@unchecked Sendable` rationale is documented on `_KVO`.
	struct WeakPublisher: @unchecked Sendable {
		weak var publisher: ObservableObjectPublisher?
	}
}

// MARK: Equatable

extension CodableUserDefaults: Equatable where Value: Equatable {

	public static func == ( lhs: Self, rhs: Self ) -> Bool {
		lhs.key == rhs.key && lhs.getValue( lhs.observer.store ) == rhs.getValue( rhs.observer.store )
	}
}

// MARK: Hashable

extension CodableUserDefaults: Hashable where Value: Hashable {

	public func hash( into hasher: inout Hasher ) {
		hasher.combine( key )
		hasher.combine( getValue( observer.store ) )
	}
}

private let _userDefaults_encoder = JSONEncoder()
private let _userDefaults_decoder = JSONDecoder()

public protocol __PropertyList {}

// MARK: - Bool + __PropertyList

extension Bool: __PropertyList {}

// MARK: - Date + __PropertyList

extension Date: __PropertyList {}

// MARK: - URL + __PropertyList

extension URL: __PropertyList {}

// MARK: - String + __PropertyList

extension String: __PropertyList {}

// MARK: - Int + __PropertyList

extension Int: __PropertyList {}

// MARK: - Int8 + __PropertyList

extension Int8: __PropertyList {}

// MARK: - Int16 + __PropertyList

extension Int16: __PropertyList {}

// MARK: - Int32 + __PropertyList

extension Int32: __PropertyList {}

// MARK: - Int64 + __PropertyList

extension Int64: __PropertyList {}

// MARK: - UInt + __PropertyList

extension UInt: __PropertyList {}

// MARK: - UInt8 + __PropertyList

extension UInt8: __PropertyList {}

// MARK: - UInt16 + __PropertyList

extension UInt16: __PropertyList {}

// MARK: - UInt32 + __PropertyList

extension UInt32: __PropertyList {}

// MARK: - UInt64 + __PropertyList

extension UInt64: __PropertyList {}

// MARK: - Float + __PropertyList

extension Float: __PropertyList {}

// MARK: - Double + __PropertyList

extension Double: __PropertyList {}

// MARK: - CGPoint + __PropertyList

extension CGPoint: __PropertyList {}

// MARK: - CGVector + __PropertyList

extension CGVector: __PropertyList {}

// MARK: - CGSize + __PropertyList

extension CGSize: __PropertyList {}

// MARK: - CGRect + __PropertyList

extension CGRect: __PropertyList {}

// MARK: - CGAffineTransform + __PropertyList

extension CGAffineTransform: __PropertyList {}

#if DEBUG

@Observable
final class CodableUserDefaultsPreviewModel {
	@ObservationIgnored
	@CodableUserDefaults( "userDefaultPreviewCounter" )
	var counter: Int = 0
}

@MainActor
final class ObjectModel: ObservableObject {
	@CodableUserDefaults( "userDefaultPreviewCounter" )
	var counter: Int = 0
}

#Preview {

	// All three variants share a key, so each button updates every value.

	struct PreviewContent: View {

		@CodableUserDefaults( "userDefaultPreviewCounter" )
		var counter: Int = 0

		@StateObject var objectModel = ObjectModel()
		@State var observableModel = CodableUserDefaultsPreviewModel()

		var body: some View {
			VStack( spacing: 16 ) {
				Button( "View: \( counter )" ) { counter += 1 }
				Button( "ObservableObject: \( objectModel.counter )" ) { objectModel.counter += 1 }
				Button( "@Observable: \( observableModel.counter )" ) { observableModel.counter += 1 }
				Button( "Через стандартный UserDefaults" ) {
					// Writing directly to UserDefaults verifies that KVO reports the change.
					UserDefaults.standard.set( counter + 1, forKey: "userDefaultPreviewCounter" )
				}
			}
		}
	}

	return PreviewContent()
}
#endif
