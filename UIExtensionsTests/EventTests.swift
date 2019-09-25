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

import XCTest

enum TestEnum {
	case test1
	case test2
}

class EventTests: XCTestCase {

	func testIntEvent() {

		let expectation = self.expectation( description: "Raise Int event expectation." )
		let intEvent = Event<Int>()

		intEvent.addClosureHandler( self ) { result in
			XCTAssertEqual( result, 23 )
			expectation.fulfill()
		}

		intEvent.raise( 23 )
		waitForExpectations( timeout: 1, handler: nil )
	}

	func testEnumEvent() {

		let expectation = self.expectation( description: "Raise Enum event expectation." )
		let enumEvent = Event<TestEnum>()

		enumEvent.addClosureHandler( self ) { result in
			XCTAssertEqual( result, TestEnum.test2 )
			expectation.fulfill()
		}

		enumEvent.raise( .test2 )
		waitForExpectations( timeout: 1, handler: nil )
	}

	func testOptionalEvent() {

		let expectation = self.expectation( description: "Raise Enum event expectation." )
		let optionalEvent = Event<String?>()

		optionalEvent.addClosureHandler( self ) { result in
			XCTAssertNil( result )
			expectation.fulfill()
		}

		optionalEvent.raise( nil )
		waitForExpectations( timeout: 1, handler: nil )
	}

	func testTuple() {

		let expectation = self.expectation( description: "Raise tuple event expectation." )
		let tupleEvent = Event<(Int, String)>()

		tupleEvent.addClosureHandler( self ) { result in
			XCTAssertEqual( result.0, 1 )
			XCTAssertEqual( result.1, "No error" )
			expectation.fulfill()
		}

		tupleEvent.raise( ( 1, "No error" ) )
		waitForExpectations( timeout: 1, handler: nil )
	}

	func testMethodHandler() {
		let expectation = self.expectation( description: "Raise method event expectation." )
		let methodEvent = Event<XCTestExpectation?>()

		methodEvent.addHandler( self, handler: EventTests.eventMethodHandler )

		methodEvent.raise( expectation )
		waitForExpectations( timeout: 1, handler: nil )
	}

	func eventMethodHandler( _ expectation: XCTestExpectation? ) {
		XCTAssertNotNil( expectation )
		expectation?.fulfill()
		XCTAssertTrue( Thread.current === Thread.main )
	}

	func testPrivateQueueEventHandler() {

		let queue = DispatchQueue( label: "Event queue", attributes: DispatchQueue.Attributes.concurrent )
		let expectation = self.expectation( description: "Raise Queue event expectation." )
		let queueEvent = Event<String>()

		queueEvent.addClosureHandler( self, queue: queue ) { result in
			XCTAssertEqual( result, "TestQueue" )
			XCTAssertTrue( Thread.current !== Thread.main )
			expectation.fulfill()
		}

		queueEvent.raise( "TestQueue" )
		waitForExpectations( timeout: 1, handler: nil )
	}

	func testDispose() {

		let expectation = self.expectation( description: "Raise dispose event expectation." )
		let intEvent = Event<Int>()

		let disposable = intEvent.addClosureHandler( self ) { result in
			XCTAssertEqual( result, 23 )
			expectation.fulfill()
		}

		intEvent.raise( 23 )
		waitForExpectations( timeout: 1, handler: nil )

		XCTAssertEqual( intEvent.handlersCount, 1 )
		disposable.dispose()
		XCTAssertEqual( intEvent.handlersCount, 0 )
	}

	func testAutoDispose() {

		class AutoDisposeTestClass {
			let methodExpectation: XCTestExpectation
			init( event: Event<String>, closureExpectation: XCTestExpectation, methodExpectation: XCTestExpectation ) {

				self.methodExpectation = methodExpectation
				event.addHandler( self, handler: AutoDisposeTestClass.eventMethodHandler )

				event.addClosureHandler( self ) { string in
					XCTAssertEqual( string, "Raise 1" )
					closureExpectation.fulfill()
				}
			}

			func eventMethodHandler( _ string: String ) {
				XCTAssertEqual( string, "Raise 1" )
				methodExpectation.fulfill()
			}
		}


		let closureExpectation = expectation( description: "Raise auto-dispose closure event expectation." )
		let methodExpectation = expectation( description: "Raise auto-dispose method event expectation." )
		let stringEvent = Event<String>()

		var testClass: AutoDisposeTestClass? = AutoDisposeTestClass( event: stringEvent, closureExpectation: closureExpectation, methodExpectation: methodExpectation )
		weak var weakTestRef: AutoDisposeTestClass? = testClass

		stringEvent.raise( "Raise 1" )
		waitForExpectations( timeout: 1, handler: nil )

		XCTAssertEqual( stringEvent.handlersCount, 2 )
		testClass = nil
		XCTAssertNil( weakTestRef )
		stringEvent.raise( "Raise 2" )
		XCTAssertEqual( stringEvent.handlersCount, 0 )
	}
}
