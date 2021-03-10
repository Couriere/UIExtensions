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

#if canImport(UIKit)
import XCTest
import UIExtensions

class GlobalTableViewCell: UITableViewCell {}
class GlobalTableHeaderFooterView: UITableViewHeaderFooterView {}
class GlobalCollectionViewCell: UICollectionViewCell { let i: Int = 0 }
class GlobalCollectionReusable: UICollectionViewCell {}

enum Enum {
	class TableViewCell: UITableViewCell { let i: Int = 0 }
	class TableHeaderFooterView: UITableViewHeaderFooterView {}
	class CollectionViewCell: UICollectionViewCell {}
	class CollectionReusable: UICollectionViewCell {}
}
class CellIdentifiersTests: XCTestCase {

	class InnerTableViewCell: UITableViewCell {}
	class InnerTableHeaderFooterView: UITableViewHeaderFooterView {}
	class InnerCollectionViewCell: UICollectionViewCell { var color: UIColor? = nil }
	class InnerCollectionReusable: UICollectionViewCell { var s = "" }


	func testIdentifiersAreCorrect() {

		XCTAssertEqual( GlobalTableViewCell.identifier, "GlobalTableViewCell" )
		XCTAssertEqual( GlobalTableHeaderFooterView.identifier, "GlobalTableHeaderFooterView" )
		XCTAssertEqual( GlobalCollectionViewCell.identifier, "GlobalCollectionViewCell" )
		XCTAssertEqual( GlobalCollectionReusable.identifier, "GlobalCollectionReusable" )

		XCTAssertEqual( Enum.TableViewCell.identifier, "TableViewCell" )
		XCTAssertEqual( Enum.TableHeaderFooterView.identifier, "TableHeaderFooterView" )
		XCTAssertEqual( Enum.CollectionViewCell.identifier, "CollectionViewCell" )
		XCTAssertEqual( Enum.CollectionReusable.identifier, "CollectionReusable" )

		XCTAssertEqual( CellIdentifiersTests.InnerTableViewCell.identifier, "InnerTableViewCell" )
		XCTAssertEqual( CellIdentifiersTests.InnerTableHeaderFooterView.identifier, "InnerTableHeaderFooterView" )
		XCTAssertEqual( CellIdentifiersTests.InnerCollectionViewCell.identifier, "InnerCollectionViewCell" )
		XCTAssertEqual( CellIdentifiersTests.InnerCollectionReusable.identifier, "InnerCollectionReusable" )
	}
}
#endif
