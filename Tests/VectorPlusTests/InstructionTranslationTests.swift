import XCTest
import Swift2D
import SwiftSVG
@testable import VectorPlus

final class InstructionTranslationTests: XCTestCase {
    
    static var allTests = [
        ("testTranslateLineFromRectToRect", testTranslateLineFromRectToRect),
        ("testTranslateBezierCurveFromRectToRect", testTranslateBezierCurveFromRectToRect),
        ("testTranslateQuadraticCurveFromRectToRect", testTranslateQuadraticCurveFromRectToRect),
        ("testTranslateCircleFromRectToRect", testTranslateCircleFromRectToRect),
        ("testTranslateRectangleFromRectToRect", testTranslateRectangleFromRectToRect)
    ]
    
    func testTranslateLineFromRectToRect() {
        var from = Rect(x: 0, y: 0, width: 500, height: 500)
        var to = Rect(x: 0, y: 0, width: 100, height: 100)
        
        var instructions: [Instruction] = [
            .move(x: 250, y: 50),
            .line(x: 450, y: 250),
            .line(x: 250, y: 450),
            .line(x: 50, y: 250),
            .close
        ]
        
        var translated = instructions.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 5)
        
        if case let .move(x, y) = translated[0] {
            XCTAssertEqual(x, 50)
            XCTAssertEqual(y, 10)
        } else {
            XCTFail()
        }
        
        if case let .line(x, y) = translated[1] {
            XCTAssertEqual(x, 90)
            XCTAssertEqual(y, 50)
        } else {
            XCTFail()
        }
        
        if case let .line(x, y) = translated[2] {
            XCTAssertEqual(x, 50)
            XCTAssertEqual(y, 90)
        } else {
            XCTFail()
        }
        
        if case let .line(x, y) = translated[3] {
            XCTAssertEqual(x, 10)
            XCTAssertEqual(y, 50)
        } else {
            XCTFail()
        }
        
        if case .close = translated[4] {
            
        } else {
            XCTFail()
        }
        
        from = Rect(x: 0, y: 0, width: 100, height: 100)
        to = Rect(x: 0, y: 0, width: 500, height: 500)
        
        instructions = [
            .move(x: 50, y: 10),
            .line(x: 90, y: 50),
            .line(x: 50, y: 90),
            .line(x: 10, y: 50),
            .close
        ]
        
        translated = instructions.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 5)
        
        if case let .move(x, y) = translated[0] {
            XCTAssertEqual(x, 250)
            XCTAssertEqual(y, 50)
        } else {
            XCTFail()
        }
        
        if case let .line(x, y) = translated[1] {
            XCTAssertEqual(x, 450)
            XCTAssertEqual(y, 250)
        } else {
            XCTFail()
        }
        
        if case let .line(x, y) = translated[2] {
            XCTAssertEqual(x, 250)
            XCTAssertEqual(y, 450)
        } else {
            XCTFail()
        }
        
        if case let .line(x, y) = translated[3] {
            XCTAssertEqual(x, 50)
            XCTAssertEqual(y, 250)
        } else {
            XCTFail()
        }
        
        if case .close = translated[4] {
            
        } else {
            XCTFail()
        }
    }
    
    func testTranslateBezierCurveFromRectToRect() {
        var from = Rect(origin: .zero, size: Size(width: 100, height: 100))
        var to = Rect(origin: .zero, size: Size(width: 750, height: 750))
        
        var instructions: [Instruction] = [
            .move(x: 0, y: 20),
            .bezierCurve(x: 100, y: 80, cx1: 60, cy1: 0, cx2: 40, cy2: 100),
            .close
        ]
        
        var translated = instructions.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        if case let .move(x, y) = translated[0] {
            XCTAssertEqual(x, 0)
            XCTAssertEqual(y, 150, accuracy: 0.1)
        } else {
            XCTFail()
        }
        
        if case let .bezierCurve(x, y, cx1, cy1, cx2, cy2) = translated[1] {
            XCTAssertEqual(x, 750)
            XCTAssertEqual(y, 600)
            XCTAssertEqual(cx1, 450)
            XCTAssertEqual(cy1, 0)
            XCTAssertEqual(cx2, 300)
            XCTAssertEqual(cy2, 750)
        } else {
            XCTFail()
        }
        
        if case .close = translated[2] {
        } else {
            XCTFail()
        }
        
        to = Rect(origin: .zero, size: Size(width: 100, height: 100))
        from = Rect(origin: .zero, size: Size(width: 750, height: 750))
        
        instructions = [
            .move(x: 0, y: 150),
            .bezierCurve(x: 750, y: 600, cx1: 450, cy1: 0, cx2: 300, cy2: 750),
            .close
        ]
        
        translated = instructions.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        if case let .move(x, y) = translated[0] {
            XCTAssertEqual(x, 0)
            XCTAssertEqual(y, 20, accuracy: 0.1)
        } else {
            XCTFail()
        }
        
        if case let .bezierCurve(x, y, cx1, cy1, cx2, cy2) = translated[1] {
            XCTAssertEqual(x, 100)
            XCTAssertEqual(y, 80)
            XCTAssertEqual(cx1, 60)
            XCTAssertEqual(cy1, 0)
            XCTAssertEqual(cx2, 40)
            XCTAssertEqual(cy2, 100)
        } else {
            XCTFail()
        }
        
        if case .close = translated[2] {
        } else {
            XCTFail()
        }
    }
    
    func testTranslateQuadraticCurveFromRectToRect() {
        var from = Rect(origin: .zero, size: Size(width: 100, height: 100))
        var to = Rect(origin: .zero, size: Size(width: 170, height: 170))
        
        var instructions: [Instruction] = [
            .move(x: 20, y: 20),
            .quadraticCurve(x: 80, y: 20, cx: 50, cy: 90),
            .close
        ]
        
        var translated = instructions.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        if case let .move(x, y) = translated[0] {
            XCTAssertEqual(x, 34, accuracy: 0.1)
            XCTAssertEqual(y, 34, accuracy: 0.1)
        } else {
            XCTFail()
        }
        
        if case let .quadraticCurve(x, y, cx, cy) = translated[1] {
            XCTAssertEqual(x, 136)
            XCTAssertEqual(y, 34, accuracy: 0.1)
            XCTAssertEqual(cx, 85)
            XCTAssertEqual(cy, 153)
        } else {
            XCTFail()
        }
        
        if case .close = translated[2] {
        } else {
            XCTFail()
        }
        
        to = Rect(origin: .zero, size: Size(width: 100, height: 100))
        from = Rect(origin: .zero, size: Size(width: 170, height: 170))
        
        instructions = [
            .move(x: 34, y: 34),
            .quadraticCurve(x: 136, y: 34, cx: 85, cy: 153),
            .close
        ]
        
        translated = instructions.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        if case let .move(x, y) = translated[0] {
            XCTAssertEqual(x, 20, accuracy: 0.1)
            XCTAssertEqual(y, 20, accuracy: 0.1)
        } else {
            XCTFail()
        }
        
        if case let .quadraticCurve(x, y, cx, cy) = translated[1] {
            XCTAssertEqual(x, 80)
            XCTAssertEqual(y, 20, accuracy: 0.1)
            XCTAssertEqual(cx, 50)
            XCTAssertEqual(cy, 90)
        } else {
            XCTFail()
        }
        
        if case .close = translated[2] {
        } else {
            XCTFail()
        }
    }
    
    func testTranslateCircleFromRectToRect() {
        var from = Rect(origin: .zero, size: Size(width: 100, height: 100))
        var to = Rect(origin: .zero, size: Size(width: 275, height: 275))
        
        var instructions: [Instruction] = [
            .move(x: 45, y: 50),
            .circle(x: 45, y: 50, r: 40),
            .close
        ]
        
        var translated = instructions.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        if case let .circle(x, y, r) = translated[1] {
            XCTAssertEqual(x, 123.75, accuracy: 0.1)
            XCTAssertEqual(y, 137.5, accuracy: 0.1)
            XCTAssertEqual(r, 110, accuracy: 0.1)
        } else {
            XCTFail()
        }
        
        to = Rect(origin: .zero, size: Size(width: 100, height: 100))
        from = Rect(origin: .zero, size: Size(width: 275, height: 275))
        
        instructions = [
            .move(x: 123.75, y: 137.5),
            .circle(x: 123.75, y: 137.5, r: 110),
            .close
        ]
        
        translated = instructions.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        if case let .circle(x, y, r) = translated[1] {
            XCTAssertEqual(x, 45, accuracy: 0.1)
            XCTAssertEqual(y, 50, accuracy: 0.1)
            XCTAssertEqual(r, 40, accuracy: 0.1)
        } else {
            XCTFail()
        }
    }
    
    func testTranslateRectangleFromRectToRect() {
        var from = Rect(origin: .zero, size: Size(width: 100, height: 100))
        var to = Rect(origin: .zero, size: Size(width: 654, height: 654))
        
        var instructions: [Instruction] = [
            .move(x: 56.5, y: 60),
            .rectangle(x: 56.5, y: 60.0, w: 31.25, h: 22.4, rx: 4.6, ry: 8.4),
            .close
        ]
        
        var translated = instructions.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        if case let .rectangle(x, y, w, h, rx, ry) = translated[1] {
            XCTAssertEqual(x, 369.51, accuracy: 0.1)
            XCTAssertEqual(y, 392.4, accuracy: 0.1)
            XCTAssertEqual(w, 204.375, accuracy: 0.1)
            XCTAssertEqual(h, 146.496, accuracy: 0.1)
            XCTAssertNotNil(rx)
            XCTAssertNotNil(ry)
            XCTAssertEqual(rx!, 30.084, accuracy: 0.1)
            XCTAssertEqual(ry!, 54.936, accuracy: 0.1)
        } else {
            XCTFail()
        }
        
        to = Rect(origin: .zero, size: Size(width: 100, height: 100))
        from = Rect(origin: .zero, size: Size(width: 654, height: 654))
        
        instructions = [
            .move(x: 369.51, y: 392.4),
            .rectangle(x: 369.51, y: 392.4, w: 204.375, h: 146.496, rx: 30.084, ry: 54.936),
            .close
        ]
        
        translated = instructions.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        if case let .rectangle(x, y, w, h, rx, ry) = translated[1] {
            XCTAssertEqual(x, 56.5, accuracy: 0.1)
            XCTAssertEqual(y, 60.0, accuracy: 0.1)
            XCTAssertEqual(w, 31.25, accuracy: 0.1)
            XCTAssertEqual(h, 22.4, accuracy: 0.1)
            XCTAssertNotNil(rx)
            XCTAssertNotNil(ry)
            XCTAssertEqual(rx!, 4.6, accuracy: 0.1)
            XCTAssertEqual(ry!, 8.4, accuracy: 0.1)
        } else {
            XCTFail()
        }
    }
}
