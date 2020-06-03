import Foundation
import Swift2D
import SwiftSVG

internal extension Instruction {
    var lastControlPoint: Point? {
        switch self {
        case .bezierCurve(_, _, _, _, let cx2, let cy2):
            return Point(x: cx2, y: cy2)
        case .quadraticCurve(_, _, let cx, let cy):
            return Point(x: cx, y: cy)
        default:
            return nil
        }
    }
    
    /// A mirror representation of the last control point.
    ///
    /// Used when determining _smooth_ Cubic Bézier Curves.
    var lastControlPointMirror: Point? {
        guard let lastControlPoint = self.lastControlPoint else {
            return nil
        }
        
        let x = point.x + (point.x - lastControlPoint.x)
        let y = point.y + (point.y - lastControlPoint.y)
        
        return Point(x: x, y: y)
    }
    
    var isComplete: Bool {
        switch self {
        case .close:
            return true
        case .move(let x, let y), .line(let x, let y), .circle(let x, let y, _), .rectangle(let x, let y, _, _, _, _):
            if x.isNaN || y.isNaN {
                return false
            }
            
            return true
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            if x.isNaN || y.isNaN || cx1.isNaN || cy1.isNaN || cx2.isNaN || cy2.isNaN {
                return false
            }
            
            return true
        case .quadraticCurve(let x, let y, let cx, let cy):
            if x.isNaN || y.isNaN || cx.isNaN || cy.isNaN {
                return false
            }
            
            return true
        }
    }
    
    /// Adjusts the value contained at the specified argument position (i.e., x, y, cx2) by the specified amount.
    ///
    /// - parameter position: The index of the instructions values to adjust.
    /// - parameter value: The value to add to the existing value. (If the current value `.isNaN`, the supplied value is used.
    func adjustingArgument(at position: Int, by value: Float) throws -> Instruction {
        switch self {
        case .move(let x, let y):
            switch position {
            case 0:
                return .move(x: (x.isNaN) ? value : x + value, y: y)
            case 1:
                return .move(x: x, y: (y.isNaN) ? value : y + value)
            default:
                throw Error.invalidArgumentPosition
            }
        case .line(let x, let y):
            switch position {
            case 0:
                return .line(x: (x.isNaN) ? value : x + value, y: y)
            case 1:
                return .line(x: x, y: (y.isNaN) ? value : y + value)
            default:
                throw Error.invalidArgumentPosition
            }
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            switch position {
            case 0:
                return .bezierCurve(x: (x.isNaN) ? value : x + value, y: y, cx1: cx1, cy1: cy1, cx2: cx2, cy2: cy2)
            case 1:
                return .bezierCurve(x: x, y: (y.isNaN) ? value : y + value, cx1: cx1, cy1: cy1, cx2: cx2, cy2: cy2)
            case 2:
                return .bezierCurve(x: x, y: y, cx1: (cx1.isNaN) ? value : cx1 + value, cy1: cy1, cx2: cx2, cy2: cy2)
            case 3:
                return .bezierCurve(x: x, y: y, cx1: cx1, cy1: (cy1.isNaN) ? value : cy1 + value, cx2: cx2, cy2: cy2)
            case 4:
                return .bezierCurve(x: x, y: y, cx1: cx1, cy1: cy1, cx2: (cx2.isNaN) ? value : cx2 + value, cy2: cy2)
            case 5:
                return .bezierCurve(x: x, y: y, cx1: cx1, cy1: cy1, cx2: cx2, cy2: (cy2.isNaN) ? value : cy2 + value)
            default:
                throw Error.invalidArgumentPosition
            }
        case .quadraticCurve(let x, let y, let cx, let cy):
            switch position {
            case 0:
                return .quadraticCurve(x: (x.isNaN) ? value : x + value, y: y, cx: cx, cy: cy)
            case 1:
                return .quadraticCurve(x: x, y: (y.isNaN) ? value : y + value, cx: cx, cy: cy)
            case 2:
                return .quadraticCurve(x: x, y: y, cx: (cx.isNaN) ? value : cx + value, cy: cy)
            case 3:
                return .quadraticCurve(x: x, y: y, cx: cx, cy: (cy.isNaN) ? value : cy + value)
            default:
                throw Error.invalidArgumentPosition
            }
        case .circle:
            throw Error.invalidArgumentPosition
        case .rectangle:
            throw Error.invalidArgumentPosition
        case .close:
            throw Error.invalidArgumentPosition
        }
    }
    
    var pathData: String? {
        switch self {
        case .move(let x, let y):
            return String(format: "\(Prefix.move.stringValue)%.5f,%.5f", x, y)
        case .line(let x, let y):
            return String(format: "\(Prefix.line.stringValue)%.5f,%.5f", x, y)
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            return String(format: "\(Prefix.bezierCurve.stringValue)%.5f,%.5f %.5f,%.5f %.5f,%.5f", cx1, cy1, cx2, cy2, x, y)
        case .quadraticCurve(let x, let y, let cx, let cy):
            return String(format: "\(Prefix.quadraticCurve.stringValue)%.5f,%.5f %.5f,%.5f", cx, cy, x, y)
        case .close:
            return Prefix.close.stringValue
        default:
            return nil
        }
    }
    
    var polygonPoints: String? {
        switch self {
        case .move(let x, let y):
            return String(format: "%.5f,%.5f", x, y)
        case .line(let x, let y):
            return String(format: "%.5f,%.5f", x, y)
        default:
            return nil
        }
    }
}
