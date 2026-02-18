import Swift2D
import SwiftSVG
import Testing
@testable import VectorPlus

struct InstructionTranslationTests {

    @Test func translateLineFromRectToRect() {
        var from = Rect(x: 0, y: 0, width: 500, height: 500)
        var to = Rect(x: 0, y: 0, width: 100, height: 100)

        var commands: [Path.Command] = [
            .moveTo(point: Point(x: 250, y: 50)),
            .lineTo(point: Point(x: 450, y: 250)),
            .lineTo(point: Point(x: 250, y: 450)),
            .lineTo(point: Point(x: 50, y: 250)),
            .closePath,
        ]

        var translated = commands.map { $0.translate(from: from, to: to) }
        #expect(translated.count == 5)

        var expected: [Path.Command] = [
            .moveTo(point: Point(x: 50, y: 10)),
            .lineTo(point: Point(x: 90, y: 50)),
            .lineTo(point: Point(x: 50, y: 90)),
            .lineTo(point: Point(x: 10, y: 50)),
            .closePath,
        ]

        #expect(translated == expected)

        from = Rect(x: 0, y: 0, width: 100, height: 100)
        to = Rect(x: 0, y: 0, width: 500, height: 500)

        commands = [
            .moveTo(point: Point(x: 50, y: 10)),
            .lineTo(point: Point(x: 90, y: 50)),
            .lineTo(point: Point(x: 50, y: 90)),
            .lineTo(point: Point(x: 10, y: 50)),
            .closePath,
        ]

        translated = commands.map { $0.translate(from: from, to: to) }
        #expect(translated.count == 5)

        expected = [
            .moveTo(point: Point(x: 250, y: 50)),
            .lineTo(point: Point(x: 450, y: 250)),
            .lineTo(point: Point(x: 250, y: 450)),
            .lineTo(point: Point(x: 50, y: 250)),
            .closePath,
        ]

        #expect(translated == expected)
    }

    @Test func translateBezierCurveFromRectToRect() {
        var from = Rect(origin: .zero, size: Size(width: 100, height: 100))
        var to = Rect(origin: .zero, size: Size(width: 750, height: 750))

        var commands: [Path.Command] = [
            .moveTo(point: Point(x: 0, y: 20)),
            .cubicBezierCurve(cp1: Point(x: 60, y: 0), cp2: Point(x: 40, y: 100), point: Point(x: 100, y: 80)),
            .closePath,
        ]

        var translated = commands.map { $0.translate(from: from, to: to) }
        #expect(translated.count == 3)

        var expected: [Path.Command] = [
            .moveTo(point: Point(x: 0, y: 150)),
            .cubicBezierCurve(cp1: Point(x: 450, y: 0), cp2: Point(x: 300, y: 750), point: Point(x: 750, y: 600)),
            .closePath,
        ]

        #expect(translated == expected)

        to = Rect(origin: .zero, size: Size(width: 100, height: 100))
        from = Rect(origin: .zero, size: Size(width: 750, height: 750))

        commands = [
            .moveTo(point: Point(x: 0, y: 150)),
            .cubicBezierCurve(cp1: Point(x: 450, y: 0), cp2: Point(x: 300, y: 750), point: Point(x: 750, y: 600)),
            .closePath,
        ]

        translated = commands.map { $0.translate(from: from, to: to) }
        #expect(translated.count == 3)

        expected = [
            .moveTo(point: Point(x: 0, y: 20)),
            .cubicBezierCurve(cp1: Point(x: 60, y: 0), cp2: Point(x: 40, y: 100), point: Point(x: 100, y: 80)),
            .closePath,
        ]

        #expect(translated == expected)
    }

    @Test func translateQuadraticCurveFromRectToRect() {
        var from = Rect(origin: .zero, size: Size(width: 100, height: 100))
        var to = Rect(origin: .zero, size: Size(width: 170, height: 170))

        var commands: [Path.Command] = [
            .moveTo(point: Point(x: 20, y: 20)),
            .quadraticBezierCurve(cp: Point(x: 50, y: 90), point: Point(x: 80, y: 20)),
            .closePath,
        ]

        var translated = commands.map { $0.translate(from: from, to: to) }
        #expect(translated.count == 3)

        var expected: [Path.Command] = [
            .moveTo(point: Point(x: 34, y: 34)),
            .quadraticBezierCurve(cp: Point(x: 85, y: 153), point: Point(x: 136, y: 34)),
            .closePath,
        ]

        #expect(translated == expected)

        to = Rect(origin: .zero, size: Size(width: 100, height: 100))
        from = Rect(origin: .zero, size: Size(width: 170, height: 170))

        commands = [
            .moveTo(point: Point(x: 34, y: 34)),
            .quadraticBezierCurve(cp: Point(x: 85, y: 153), point: Point(x: 136, y: 34)),
            .closePath,
        ]

        translated = commands.map { $0.translate(from: from, to: to) }
        #expect(translated.count == 3)

        expected = [
            .moveTo(point: Point(x: 20, y: 20)),
            .quadraticBezierCurve(cp: Point(x: 50, y: 90), point: Point(x: 80, y: 20)),
            .closePath,
        ]

        #expect(translated == expected)
    }
}
