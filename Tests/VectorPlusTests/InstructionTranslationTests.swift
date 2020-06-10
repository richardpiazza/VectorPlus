import XCTest
import Swift2D
import SwiftSVG
@testable import VectorPlus

final class InstructionTranslationTests: XCTestCase {
    
    static var allTests = [
        ("testTranslateLineFromRectToRect", testTranslateLineFromRectToRect),
        ("testTranslateBezierCurveFromRectToRect", testTranslateBezierCurveFromRectToRect),
        ("testTranslateQuadraticCurveFromRectToRect", testTranslateQuadraticCurveFromRectToRect),
    ]
    
    func testTranslateLineFromRectToRect() {
        var from = Rect(x: 0, y: 0, width: 500, height: 500)
        var to = Rect(x: 0, y: 0, width: 100, height: 100)
        
        var commands: [Path.Command] = [
            .moveTo(point: Point(x: 250, y: 50)),
            .lineTo(point: Point(x: 450, y: 250)),
            .lineTo(point: Point(x: 250, y: 450)),
            .lineTo(point: Point(x: 50, y: 250)),
            .closePath
        ]
        
        var translated = commands.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 5)
        
        var expected: [Path.Command] = [
            .moveTo(point: Point(x: 50, y: 10)),
            .lineTo(point: Point(x: 90, y: 50)),
            .lineTo(point: Point(x: 50, y: 90)),
            .lineTo(point: Point(x: 10, y: 50)),
            .closePath
        ]
        
        XCTAssertEqual(translated, expected)
        
        from = Rect(x: 0, y: 0, width: 100, height: 100)
        to = Rect(x: 0, y: 0, width: 500, height: 500)
        
        commands = [
            .moveTo(point: Point(x: 50, y: 10)),
            .lineTo(point: Point(x: 90, y: 50)),
            .lineTo(point: Point(x: 50, y: 90)),
            .lineTo(point: Point(x: 10, y: 50)),
            .closePath
        ]
        
        translated = commands.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 5)
        
        expected = [
            .moveTo(point: Point(x: 250, y: 50)),
            .lineTo(point: Point(x: 450, y: 250)),
            .lineTo(point: Point(x: 250, y: 450)),
            .lineTo(point: Point(x: 50, y: 250)),
            .closePath
        ]
        
        XCTAssertEqual(translated, expected)
    }
    
    func testTranslateBezierCurveFromRectToRect() {
        var from = Rect(origin: .zero, size: Size(width: 100, height: 100))
        var to = Rect(origin: .zero, size: Size(width: 750, height: 750))
        
        var commands: [Path.Command] = [
            .moveTo(point: Point(x: 0, y: 20)),
            .cubicBezierCurve(cp1: .init(x: 60, y: 0), cp2: .init(x: 40, y: 100), point: .init(x: 100, y: 80)),
            .closePath
        ]
        
        var translated = commands.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        var expected: [Path.Command] = [
            .moveTo(point: Point(x: 0, y: 150)),
            .cubicBezierCurve(cp1: .init(x: 450, y: 0), cp2: .init(x: 300, y: 750), point: .init(x: 750, y: 600)),
            .closePath
        ]
        
        XCTAssertRoughlyEqual(translated, expected)
        
        to = Rect(origin: .zero, size: Size(width: 100, height: 100))
        from = Rect(origin: .zero, size: Size(width: 750, height: 750))
        
        commands = [
            .moveTo(point: Point(x: 0, y: 150)),
            .cubicBezierCurve(cp1: .init(x: 450, y: 0), cp2: .init(x: 300, y: 750), point: .init(x: 750, y: 600)),
            .closePath
        ]
        
        translated = commands.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        expected = [
            .moveTo(point: Point(x: 0, y: 20)),
            .cubicBezierCurve(cp1: .init(x: 60, y: 0), cp2: .init(x: 40, y: 100), point: .init(x: 100, y: 80)),
            .closePath
        ]
        
        XCTAssertRoughlyEqual(translated, expected)
    }
    
    func testTranslateQuadraticCurveFromRectToRect() {
        var from = Rect(origin: .zero, size: Size(width: 100, height: 100))
        var to = Rect(origin: .zero, size: Size(width: 170, height: 170))
        
        var commands: [Path.Command] = [
            .moveTo(point: .init(x: 20, y: 20)),
            .quadraticBezierCurve(cp: .init(x: 50, y: 90), point: .init(x: 80, y: 20)),
            .closePath
        ]
        
        var translated = commands.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        var expected: [Path.Command] = [
            .moveTo(point: .init(x: 34, y: 34)),
            .quadraticBezierCurve(cp: .init(x: 85, y: 153), point: .init(x: 136, y: 34)),
            .closePath
        ]
        
        XCTAssertRoughlyEqual(translated, expected)
        
        to = Rect(origin: .zero, size: Size(width: 100, height: 100))
        from = Rect(origin: .zero, size: Size(width: 170, height: 170))
        
        commands = [
            .moveTo(point: .init(x: 34, y: 34)),
            .quadraticBezierCurve(cp: .init(x: 85, y: 153), point: .init(x: 136, y: 34)),
            .closePath
        ]
        
        translated = commands.map({ $0.translate(from: from, to: to) })
        XCTAssertEqual(translated.count, 3)
        
        expected = [
            .moveTo(point: .init(x: 20, y: 20)),
            .quadraticBezierCurve(cp: .init(x: 50, y: 90), point: .init(x: 80, y: 20)),
            .closePath
        ]
        
        XCTAssertRoughlyEqual(translated, expected)
    }
}
