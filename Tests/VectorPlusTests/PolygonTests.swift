import XCTest
import SwiftSVG
@testable import VectorPlus

final class PolygonTests: XCTestCase {
    
    static var allTests = [
        ("testInstructionRetreival", testInstructionRetreival),
    ]
    
    func testInstructionRetreival() throws {
        let points = "850,75 958,137.5 958,262.5 850,325 742,262.6 742,137.5"
        let polygon = SwiftSVG.Polygon(points: points)
        let instructions = try polygon.instructions()
        
        let expected: [Instruction] = [
            .move(x: 850.0, y: 75.0),
            .line(x: 958.0, y: 137.5),
            .line(x: 958.0, y: 262.5),
            .line(x: 850.0, y: 325.0),
            .line(x: 742.0, y: 262.6),
            .line(x: 742.0, y: 137.5),
            .close
        ]
        
        XCTAssertEqual(instructions, expected)
    }
}
