import Foundation
import Swift2D

public extension Instruction {
    /// The specific `CoreGraphics` command that is needed to execute the `Instruction`.
    ///
    /// It is assumed that all required transformations has been applied (_squaring_) before calling this method.
    ///
    /// - parameter originalSize: Supplied to correctly determine how to proportionally scale the instruction.
    func coreGraphicsDescription(originalSize: Size) -> String {
        switch self {
        case .move(let x, let y):
            let vector = Point(x: x, y: y).vectorPoint(from: originalSize)
            return String(format: ".move(to: %@)", vector.description)
        
        case .line(let x, let y):
            let vector = Point(x: x, y: y).vectorPoint(from: originalSize)
            return String(format: ".addLine(to: %@)", vector.description)
        
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            let pointVector = Point(x: x, y: y).vectorPoint(from: originalSize)
            let control1Vector = Point(x: cx1, y: cy1).vectorPoint(from: originalSize)
            let control2Vector = Point(x: cx2, y: cy2).vectorPoint(from: originalSize)
            return String(format: ".addCurve(to: %@, control1: %@, control2: %@)", pointVector.description, control1Vector.description, control2Vector.description)
        
        case .quadraticCurve(let x, let y, let cX, let cY):
            let pointVector = Point(x: x, y: y).vectorPoint(from: originalSize)
            let controlVector = Point(x: cX, y: cY).vectorPoint(from: originalSize)
            return String(format: ".addQuadCurve(to: %@, control: %@)", pointVector.description, controlVector.description)
        
        case .circle(let x, let y, let r):
            let vector = Point(x: x, y: y).vectorPoint(from: originalSize)
            let designRadius = originalSize.maxRadius
            let radiusMultiplier = r / designRadius
            let radius = String(format: "(radius * %.5f)", radiusMultiplier)
            return String(format: ".addArc(center: %@, radius: %@, startAngle: radians(0.0), endAngle: radians(360.0), clockwise: false)", vector.description, radius)
        
        case .rectangle(let x, let y, let w, let h, let rx, let ry):
            let radiusX = rx ?? 0.0
            let radiusY = ry ?? radiusX
            let designRadius = originalSize.maxRadius
            
            let widthMultiplier = w / designRadius
            let heightMultiplier = h / designRadius
            
            let vector = Point(x: x, y: y).vectorPoint(from: originalSize)
            
            let size = String(format: "CGSize(width: (radius * %.5f), height: (radius * %.5f))", widthMultiplier, heightMultiplier)
            let rect = String(format: "CGRect(origin: %@, size: %@)", vector.description, size)
            
            if radiusX > 0.0 || radiusY > 0.0 {
                return String(format: ".addRoundedRect(in: %@, cornerWidth: %.5f, cornerHeight: %.5f)", rect, radiusX, radiusY)
            } else {
                return String(format: ".addRect(%@)", rect)
            }
        
        case .close:
            return ".closeSubpath()"
        }
    }
}

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
    
    var pathData: String? {
        switch self {
        case .move(let x, let y):
            return String(format: "%@%.5f,%.5f", Prefix.move.stringValue, x, y)
        case .line(let x, let y):
            return String(format: "%@%.5f,%.5f", Prefix.line.stringValue, x, y)
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            return String(format: "%@%.5f,%.5f %.5f,%.5f %.5f,%.5f", Prefix.bezierCurve.stringValue, cx1, cy1, cx2, cy2, x, y)
        case .quadraticCurve(let x, let y, let cx, let cy):
            return String(format: "%@%.5f,%.5f %.5f,%.5f", Prefix.quadraticCurve.stringValue, cx, cy, x, y)
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
