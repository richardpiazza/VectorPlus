import Foundation
import Core

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
    
    func adjusting(relativeValue: Float, at argumentPosition: Int) throws -> Instruction {
        switch self {
        case .move(let x, let y):
            switch argumentPosition {
            case 0:
                return .move(x: (x.isNaN) ? relativeValue : x + relativeValue, y: y)
            case 1:
                return .move(x: x, y: (y.isNaN) ? relativeValue : y + relativeValue)
            default:
                throw Error.invalidArgumentPosition
            }
        case .line(let x, let y):
            switch argumentPosition {
            case 0:
                return .line(x: (x.isNaN) ? relativeValue : x + relativeValue, y: y)
            case 1:
                return .line(x: x, y: (y.isNaN) ? relativeValue : y + relativeValue)
            default:
                throw Error.invalidArgumentPosition
            }
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            switch argumentPosition {
            case 0:
                return .bezierCurve(x: (x.isNaN) ? relativeValue : x + relativeValue, y: y, cx1: cx1, cy1: cy1, cx2: cx2, cy2: cy2)
            case 1:
                return .bezierCurve(x: x, y: (y.isNaN) ? relativeValue : y + relativeValue, cx1: cx1, cy1: cy1, cx2: cx2, cy2: cy2)
            case 2:
                return .bezierCurve(x: x, y: y, cx1: (cx1.isNaN) ? relativeValue : cx1 + relativeValue, cy1: cy1, cx2: cx2, cy2: cy2)
            case 3:
                return .bezierCurve(x: x, y: y, cx1: cx1, cy1: (cy1.isNaN) ? relativeValue : cy1 + relativeValue, cx2: cx2, cy2: cy2)
            case 4:
                return .bezierCurve(x: x, y: y, cx1: cx1, cy1: cy1, cx2: (cx2.isNaN) ? relativeValue : cx2 + relativeValue, cy2: cy2)
            case 5:
                return .bezierCurve(x: x, y: y, cx1: cx1, cy1: cy1, cx2: cx2, cy2: (cy2.isNaN) ? relativeValue : cy2 + relativeValue)
            default:
                throw Error.invalidArgumentPosition
            }
        case .quadraticCurve(let x, let y, let cx, let cy):
            switch argumentPosition {
            case 0:
                return .quadraticCurve(x: (x.isNaN) ? relativeValue : x + relativeValue, y: y, cx: cx, cy: cy)
            case 1:
                return .quadraticCurve(x: x, y: (y.isNaN) ? relativeValue : y + relativeValue, cx: cx, cy: cy)
            case 2:
                return .quadraticCurve(x: x, y: y, cx: (cx.isNaN) ? relativeValue : cx + relativeValue, cy: cy)
            case 3:
                return .quadraticCurve(x: x, y: y, cx: cx, cy: (cy.isNaN) ? relativeValue : cy + relativeValue)
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
}
