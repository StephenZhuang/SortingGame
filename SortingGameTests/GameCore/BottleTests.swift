import XCTest
@testable import SortingGame

final class BottleTests: XCTestCase {
    func testBottleInitialization() {
        let bottle = Bottle(id: 1, colorIndex: 0, shapeIndex: 0)
        XCTAssertEqual(bottle.id, 1)
        XCTAssertEqual(bottle.colorIndex, 0)
        XCTAssertEqual(bottle.shapeIndex, 0)
    }

    func testBottleEquality() {
        let bottle1 = Bottle(id: 1, colorIndex: 0, shapeIndex: 0)
        let bottle2 = Bottle(id: 1, colorIndex: 0, shapeIndex: 0)
        XCTAssertEqual(bottle1, bottle2)
    }
}
