import XCTest
import Core
import SVG

final class InstructionTests: XCTestCase {
    
    static var allTests = [
        ("testApplyingTranslateTransformation", testApplyingTranslateTransformation),
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
}
