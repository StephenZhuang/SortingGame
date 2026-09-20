import XCTest
@testable import SortingGame

final class BottleArrayTests: XCTestCase {
    func testBottleArrayInitialization() {
        let bottles = [
            Bottle(id: 0, colorIndex: 0, shapeIndex: 0),
            Bottle(id: 1, colorIndex: 1, shapeIndex: 1),
            Bottle(id: 2, colorIndex: 2, shapeIndex: 2)
        ]
        let array = BottleArray(bottles: bottles)
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(array.bottles, bottles)
    }

    func testSwapBottles() {
        let bottles = [
            Bottle(id: 0, colorIndex: 0, shapeIndex: 0),
            Bottle(id: 1, colorIndex: 1, shapeIndex: 1),
            Bottle(id: 2, colorIndex: 2, shapeIndex: 2)
        ]
        var array = BottleArray(bottles: bottles)
        array.swap(from: 0, to: 2)

        XCTAssertEqual(array.bottles[0].id, 2)
        XCTAssertEqual(array.bottles[2].id, 0)
    }

    func testCountCorrectPositions() {
        let target = BottleArray(bottles: [
            Bottle(id: 0, colorIndex: 0, shapeIndex: 0),
            Bottle(id: 1, colorIndex: 1, shapeIndex: 1),
            Bottle(id: 2, colorIndex: 2, shapeIndex: 2)
        ])
        let guess = BottleArray(bottles: [
            Bottle(id: 2, colorIndex: 2, shapeIndex: 2),
            Bottle(id: 1, colorIndex: 1, shapeIndex: 1),
            Bottle(id: 0, colorIndex: 0, shapeIndex: 0)
        ])

        XCTAssertEqual(target.countCorrectPositions(compareTo: guess), 1)
    }

    func testIsFullyCorrect() {
        let target = BottleArray(bottles: [
            Bottle(id: 0, colorIndex: 0, shapeIndex: 0),
            Bottle(id: 1, colorIndex: 1, shapeIndex: 1)
        ])
        let correct = BottleArray(bottles: [
            Bottle(id: 0, colorIndex: 0, shapeIndex: 0),
            Bottle(id: 1, colorIndex: 1, shapeIndex: 1)
        ])
        let incorrect = BottleArray(bottles: [
            Bottle(id: 1, colorIndex: 1, shapeIndex: 1),
            Bottle(id: 0, colorIndex: 0, shapeIndex: 0)
        ])

        XCTAssertTrue(target.isFullyCorrect(compareTo: correct))
        XCTAssertFalse(target.isFullyCorrect(compareTo: incorrect))
    }
}
