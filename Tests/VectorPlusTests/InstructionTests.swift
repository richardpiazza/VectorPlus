import XCTest
@testable import SVG
@testable import Swift2D
@testable import Graphics

final class InstructionTests: XCTestCase {
    
    static var allTests = [
        ("testApplyingTranslateTransformation", testApplyingTranslateTransformation),
        ("testPathTranslateTransformation", testPathTranslateTransformation),
    ]
    
    func testApplyingTranslateTransformation() {
        let transformation = Transformation.translate(x: 10.0, y: 10.0)
        
        let move: Instruction = Instruction.move(x: 10.0, y: 10.0).applying(transformations: [transformation])
        let line: Instruction = Instruction.line(x: 20.0, y: 20.0).applying(transformations: [transformation])
        let circle: Instruction = Instruction.circle(x: 30.0, y: 30.0, r: 10.0).applying(transformations: [transformation])
        let rectangle: Instruction = Instruction.rectangle(x: 15.0, y: 15.0, w: 30.0, h: 30.0, rx: nil, ry: nil).applying(transformations: [transformation])
        let bezierCurve: Instruction = Instruction.bezierCurve(x: 100.0, y: 100.0, cx1: 0.0, cy1: 100.0, cx2: 100.0, cy2: 0.0).applying(transformations: [transformation])
        let quadraticCurve: Instruction = Instruction.quadraticCurve(x: 100.0, y: 100.0, cx: 0.0, cy: 50.0).applying(transformations: [transformation])
        let close: Instruction = Instruction.close.applying(transformations: [transformation])
        
        XCTAssertEqual(move.point, Point(x: 20.0, y: 20.0))
        XCTAssertEqual(line.point, Point(x: 30.0, y: 30.0))
        XCTAssertEqual(circle.point, Point(x: 40.0, y: 40.0))
        XCTAssertEqual(rectangle.point, Point(x: 25.0, y: 25.0))
        XCTAssertEqual(bezierCurve.point, Point(x: 110.0, y: 110.0))
        XCTAssertEqual(quadraticCurve.point, Point(x: 110.0, y: 110.0))
        XCTAssertEqual(close.point, .zero)
    }
    
    func testPathTranslateTransformation() throws {
        let path = Path(instructions: [
            .move(x: 10, y: 10),
            .line(x: 90, y: 10),
            .line(x: 90, y: 90),
            .line(x: 10, y: 90),
            .close
        ])
        
        let translate = Transformation.translate(x: -10.0, y: 10.0)
        let subpaths = try path.asPath(applying: [translate]).instructionSets()
        guard subpaths.count == 1 else {
            XCTFail()
            return
        }
        
        let subpath = subpaths[0]
        guard subpath.count == 5 else {
            XCTFail()
            return
        }
        
        if case let .move(x, y) = subpath[0] {
            XCTAssertEqual(x, 0.0)
            XCTAssertEqual(y, 20.0)
        } else {
            XCTFail()
            return
        }
        
        if case let .line(x, y) = subpath[1] {
            XCTAssertEqual(x, 80.0)
            XCTAssertEqual(y, 20.0)
        } else {
            XCTFail()
            return
        }
        
        if case let .line(x, y) = subpath[2] {
            XCTAssertEqual(x, 80.0)
            XCTAssertEqual(y, 100.0)
        } else {
            XCTFail()
            return
        }
        
        if case let .line(x, y) = subpath[3] {
            XCTAssertEqual(x, 0.0)
            XCTAssertEqual(y, 100.0)
        } else {
            XCTFail()
            return
        }
        
        if case .close = subpath[4] {
            
        } else {
            XCTFail()
            return
        }
    }
}
