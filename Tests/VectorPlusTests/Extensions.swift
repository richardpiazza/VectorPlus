import Swift2D
import SwiftSVG
@testable import VectorPlus
import XCTest

infix operator ~~
protocol RoughEquatability {
    static func ~~ (lhs: Self, rhs: Self) -> Bool
}

#if swift(>=5.3)
func XCTAssertRoughlyEqual<T: RoughEquatability>(_ expression1: @autoclosure () throws -> T, _ expression2: @autoclosure () throws -> T, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    let lhs: T
    let rhs: T
    do {
        lhs = try expression1()
        rhs = try expression2()
    } catch {
        XCTFail(error.localizedDescription, file: file, line: line)
        return
    }

    guard lhs ~~ rhs else {
        XCTFail(message(), file: file, line: line)
        return
    }
}
#else
func XCTAssertRoughlyEqual<T: RoughEquatability>(_ expression1: @autoclosure () throws -> T, _ expression2: @autoclosure () throws -> T, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    let lhs: T
    let rhs: T
    do {
        lhs = try expression1()
        rhs = try expression2()
    } catch {
        XCTFail(error.localizedDescription, file: file, line: line)
        return
    }

    guard lhs ~~ rhs else {
        XCTFail(message(), file: file, line: line)
        return
    }
}
#endif

extension Path.Command {
    func hasPrefix(_ prefix: Path.Command.Prefix) -> Bool {
        switch self {
        case .moveTo:
            prefix == .move
        case .lineTo:
            prefix == .line
        case .cubicBezierCurve:
            prefix == .cubicBezierCurve
        case .quadraticBezierCurve:
            prefix == .quadraticBezierCurve
        case .ellipticalArcCurve:
            prefix == .ellipticalArcCurve
        case .closePath:
            prefix == .close
        }
    }
}

extension Path.Command: RoughEquatability {
    static func ~~ (lhs: Path.Command, rhs: Path.Command) -> Bool {
        switch (lhs, rhs) {
        case (.moveTo(let lPoint), .moveTo(let rPoint)):
            lPoint ~~ rPoint
        case (.lineTo(let lPoint), .lineTo(let rPoint)):
            lPoint ~~ rPoint
        case (.cubicBezierCurve(let lcp1, let lcp2, let lpoint), .cubicBezierCurve(let rcp1, let rcp2, let rpoint)):
            (lcp1 ~~ rcp1) && (lcp2 ~~ rcp2) && (lpoint ~~ rpoint)
        case (.quadraticBezierCurve(let lcp, let lpoint), .quadraticBezierCurve(let rcp, let rpoint)):
            (lcp ~~ rcp) && (lpoint ~~ rpoint)
        case (.closePath, .closePath):
            true
        default:
            false
        }
    }
}

extension Double: RoughEquatability {
    static func ~~ (lhs: Double, rhs: Double) -> Bool {
        // CGFloat.abs is unavailable on some platforms
        Swift.abs(lhs - rhs) < 0.001
    }
}

extension Point: RoughEquatability {
    static func ~~ (lhs: Point, rhs: Point) -> Bool {
        (lhs.x ~~ rhs.x) && (lhs.y ~~ rhs.y)
    }
}

extension [Path.Command]: RoughEquatability {
    static func ~~ (lhs: [Element], rhs: [Element]) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }

        for (idx, i) in lhs.enumerated() {
            if !(i ~~ rhs[idx]) {
                return false
            }
        }

        return true
    }
}
