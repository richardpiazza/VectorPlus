import XCTest
import SwiftSVG
@testable import VectorPlus

final class CircleTests: XCTestCase {
    
    static var allTests = [
        ("testInstructions", testInstructions),
    ]
    
    func testInstructions() throws {
        let circle = Circle(x: 50, y: 50, r: 50)
        let offset = circle.controlPointOffset
        let instructions = try circle.instructions()
        XCTAssertEqual(instructions.count, 6)
        
        if case let .move(x, y) = instructions[0] {
            XCTAssertEqual(x, 100)
            XCTAssertEqual(y, 50)
        } else {
            XCTFail()
            return
        }
        
        if case let .bezierCurve(x, y, cx1, cy1, cx2, cy2) = instructions[1] {
            XCTAssertEqual(x, 50)
            XCTAssertEqual(y, 0)
            XCTAssertEqual(cx1, 100)
            XCTAssertEqual(cy1, 50 - offset)
            XCTAssertEqual(cx2, 50 + offset)
            XCTAssertEqual(cy2, 0)
        } else {
            XCTFail()
            return
        }
    }
}
