import XCTest
import Swift2D
import SwiftSVG
@testable import VectorPlus

infix operator ~~
protocol RoughEquatability {
    static func ~~ (lhs: Self, rhs: Self) -> Bool
}

func XCTAssertRoughlyEqual<T>(_ expression1: @autoclosure () throws -> T, _ expression2: @autoclosure () throws -> T, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) where T : RoughEquatability {
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

extension Path.Command {
    func hasPrefix(_ prefix: Path.Command.Prefix) -> Bool {
        switch self {
        case .moveTo:
            return prefix == .move
        case .lineTo:
            return prefix == .line
        case .cubicBezierCurve:
            return prefix == .cubicBezierCurve
        case .quadraticBezierCurve:
            return prefix == .quadraticBezierCurve
        case .closePath:
            return prefix == .close
        }
    }
}

extension Path.Command: RoughEquatability {
    static func ~~ (lhs: Path.Command, rhs: Path.Command) -> Bool {
        switch (lhs, rhs) {
        case (.moveTo(let lPoint), .moveTo(let rPoint)):
            return lPoint ~~ rPoint
        case (.lineTo(let lPoint), .lineTo(let rPoint)):
            return lPoint ~~ rPoint
        case (.cubicBezierCurve(let lcp1, let lcp2, let lpoint), .cubicBezierCurve(let rcp1, let rcp2, let rpoint)):
            return (lcp1 ~~ rcp1) && (lcp2 ~~ rcp2) && (lpoint ~~ rpoint)
        case (.quadraticBezierCurve(let lcp, let lpoint), .quadraticBezierCurve(let rcp, let rpoint)):
            return (lcp ~~ rcp) && (lpoint ~~ rpoint)
        case (.closePath, .closePath):
            return true
        default:
            return false
        }
    }
}

extension Float: RoughEquatability {
    static func ~~ (lhs: Float, rhs: Float) -> Bool {
        return abs(lhs - rhs) < 0.001
    }
}

extension Point: RoughEquatability {
    static func ~~ (lhs: Point, rhs: Point) -> Bool {
        return (lhs.x ~~ rhs.x) && (lhs.y ~~ rhs.y)
    }
}

extension Array: RoughEquatability where Element == Path.Command {
    static func ~~ (lhs: Array<Element>, rhs: Array<Element>) -> Bool {
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
