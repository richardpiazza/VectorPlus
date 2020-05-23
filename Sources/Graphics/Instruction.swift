import Foundation
import Swift2D

/// `Path` data  instructions.
///
/// The syntax of path data is concise in order to allow for minimal file size and efficient downloads, since many SVG files will be dominated by their path data.
/// One way that SVG attempts to minimize the size of path data is that all instructions are expressed as one character. See `Prefix`
///
public enum Instruction {
    /// The **"moveto"** command.
    ///
    /// The "moveto" commands (M or m) establish a new current point. The effect is as if the "pen" were lifted and moved to a new location.
    ///
    /// [https://www.w3.org/TR/SVG11/paths.html#PathDataMovetoCommands](https://www.w3.org/TR/SVG11/paths.html#PathDataMovetoCommands)
    case move(x: Float, y: Float)
    
    /// The **"lineto"** command.
    ///
    /// The various "lineto" commands draw straight lines from the current point to a new point:
    ///
    /// [https://www.w3.org/TR/SVG11/paths.html#PathDataLinetoCommands](https://www.w3.org/TR/SVG11/paths.html#PathDataLinetoCommands)
    case line(x: Float, y: Float)
    
    /// The **"Cubic Bézier"** command.
    ///
    /// Draws a cubic Bézier curve from the current point to (x,y) using (x1,y1) as the control point at the beginning of the curve and (x2,y2) as the control point at
    /// the end of the curve.
    ///
    /// [https://www.w3.org/TR/SVG11/paths.html#PathDataCubicBezierCommands](https://www.w3.org/TR/SVG11/paths.html#PathDataCubicBezierCommands)
    case bezierCurve(x: Float, y: Float, cx1: Float, cy1: Float, cx2: Float, cy2: Float)
    
    /// The **"Quadratic Bézier"** command.
    ///
    /// Draws a quadratic Bézier curve from the current point to (x,y) using (x1,y1) as the control point.
    ///
    /// [https://www.w3.org/TR/SVG11/paths.html#PathDataQuadraticBezierCommands](https://www.w3.org/TR/SVG11/paths.html#PathDataQuadraticBezierCommands)
    case quadraticCurve(x: Float, y: Float, cx: Float, cy: Float)
    
    /// A **Circle** element.
    ///
    case circle(x: Float, y: Float, r: Float)
    
    /// A **Rect** (rouned or not) element.
    ///
    case rectangle(x: Float, y: Float, w: Float, h: Float, rx: Float?, ry: Float?)
    
    /// The **"closepath"** command.
    ///
    /// The "closepath" (Z or z) ends the current subpath and causes an automatic straight line to be drawn from the current point to the initial point of the current
    /// subpath.
    ///
    /// [https://www.w3.org/TR/SVG11/paths.html#PathDataClosePathCommand](https://www.w3.org/TR/SVG11/paths.html#PathDataClosePathCommand)
    case close
    
    public enum Error: Swift.Error {
        case invalidInstructionPrefix
        case invalidComponentCount
        case invalidValueCount
        case invalidInstructionIndex
        case invalidArgumentPosition
        /// The previous instruction is missing/invalid
        ///
        /// Relative insructions are typically only used after another instruction
        case relativeInstruction
        /// The last control point is invalid.
        ///
        /// Either the instruction does include a control point, or the values were invalid.
        case controlPoint
    }
    
    public enum Prefix: Character, CaseIterable {
        case move = "M"
        case relativeMove = "m"
        case line = "L"
        case relativeLine = "l"
        case horizontalLine = "H"
        case relativeHorizontalLine = "h"
        case verticalLine = "V"
        case relativeVerticalLine = "v"
        case bezierCurve = "C"
        case relativeBezierCurve = "c"
        case smoothBezierCurve = "S"
        case relativeSmoothBezierCurve = "s"
        case quadraticCurve = "Q"
        case relativeQuadraticCurve = "q"
        case smoothQuadraticCurve = "T"
        case relativeSmoothQuadraticCurve = "t"
        case close = "Z"
        case relativeClose = "z"
        
        public var stringValue: String {
            return String(rawValue)
        }
        
        static var characterSet: CharacterSet {
            let characters = allCases.map({ $0.stringValue })
            return CharacterSet(charactersIn: characters.joined())
        }
    }
    
    public enum Positioning {
        case absolute
        case relative
    }
}

public extension Instruction {
    var x: Float {
        switch self {
        case .move(let x, _),
             .line(let x, _),
             .bezierCurve(let x, _, _, _, _, _),
             .quadraticCurve(let x, _, _, _),
             .circle(let x, _, _),
             .rectangle(let x, _, _, _, _, _):
            return x
        case .close:
            return 0.0
        }
    }
    
    var y: Float {
        switch self {
        case .move(_, let y),
             .line(_, let y),
             .bezierCurve(_, let y, _, _, _, _),
             .quadraticCurve(_, let y, _, _),
             .circle(_, let y, _),
             .rectangle(_, let y, _, _, _, _):
            return y
        case .close:
            return 0.0
        }
    }
    
    var point: Point {
        return Point(x: x, y: y)
    }
    
    func applying(transformation: Transformation) -> Instruction {
        switch transformation {
        case .translate(let _x, let _y):
            switch self {
            case .move(let x, let y):
                return .move(x: x + _x, y: y + _y)
            case .line(let x, let y):
                return .line(x: x + _x, y: y + _y)
            case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
                return .bezierCurve(x: x + _x, y: y + _y, cx1: cx1 + _x, cy1: cy1 + _y, cx2: cx2 + _x, cy2: cy2 + _y)
            case .quadraticCurve(let x, let y, let cx, let cy):
                return .quadraticCurve(x: x + _x, y: y + _y, cx: cx + _x, cy: cy + _y)
            case .circle(let x, let y, let r):
                return .circle(x: x + _x, y: y + _y, r: r)
            case .rectangle(let x, let y, let w, let h, let rx, let ry):
                return .rectangle(x: x + _x, y: y + _y, w: w, h: h, rx: rx, ry: ry)
            case .close:
                return .close
            }
        }
    }
    
    func applying(transformations: [Transformation]) -> Instruction {
        var instruction = self
        
        transformations.forEach { (transformation) in
            instruction = instruction.applying(transformation: transformation)
        }
        
        return instruction
    }
}

// MARK: - CustomStringConvertible
extension Instruction: CustomStringConvertible {
    /// A description of the the instruction that can be used to _print-out_ the values in the form of the enumeration.
    public var description: String {
        switch self {
        case .move(let x, let y):
            return String(format: ".move(x: %.5f, y: %.5f)", x, y)
        case .line(let x, let y):
            return String(format: ".line(x: %.5f, y: %.5f)", x, y)
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            return String(format: ".bezierCurve(x: %.5f, y: %.5f, cx1: %.5f, cy1: %.5f, cx2: %.5f, cy2: %.5f)", x, y, cx1, cy1, cx2, cy2)
        case .quadraticCurve(let x, let y, let cX, let cY):
            return String(format: ".quadraticCurve(x: %.5f, y: %.5f, cx: %.5f, cy: %.5f)", x, y, cX, cY)
        case .circle(let x, let y, let r):
            return String(format: ".circle(x: %.5f, y: %.5f, r: %.5f", x, y, r)
        case .rectangle(let x, let y, let w, let h, let rx, let ry):
            let radiusX = (rx != nil) ? String(format: "%.5f", rx!) : "nil"
            let radiusY = (ry != nil) ? String(format: "%.5f", ry!) : "nil"
            return String(format: ".rectangle(x: %.5f, y: %.5f, w: %.5f, y: %.5f, rx: \(radiusX), ry: \(radiusY))", x, y, w, h)
        case .close:
            return ".close"
        }
    }
}

// MARK: - Equatable
extension Instruction: Equatable {}

public extension Instruction {
    /// The specific `CoreGraphics` command that is needed to execute the `Instruction`.
    ///
    /// It is assumed that all required transformations has been applied (_squaring_) before calling this method.
    ///
    /// - parameter originalSize: Supplied to correctly determine how to proportionally scale the instruction.
    func coreGraphicsDescription(originalSize: Size) -> String {
        let rect = Rect(origin: .zero, size: originalSize)
        
        switch self {
        case .move(let x, let y):
            let vector = VectorPoint(point: Point(x: x, y: y), in: rect)
            return ".move(to: \(vector.coreGraphicsDescription))"
        
        case .line(let x, let y):
            let vector = VectorPoint(point: Point(x: x, y: y), in: rect)
            return ".addLine(to: \(vector.coreGraphicsDescription))"
        
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            let pointVector = VectorPoint(point: Point(x: x, y: y), in: rect)
            let control1Vector = VectorPoint(point: Point(x: cx1, y: cy1), in: rect)
            let control2Vector = VectorPoint(point: Point(x: cx2, y: cy2), in: rect)
            return ".addCurve(to: \(pointVector.coreGraphicsDescription), control1: \(control1Vector.coreGraphicsDescription), control2: \(control2Vector.coreGraphicsDescription))"
        
        case .quadraticCurve(let x, let y, let cx, let cy):
            let pointVector = VectorPoint(point: Point(x: x, y: y), in: rect)
            let controlVector = VectorPoint(point: Point(x: cx, y: cy), in: rect)
            return ".addQuadCurve(to: \(pointVector.coreGraphicsDescription), control: \(controlVector.coreGraphicsDescription))"
        
        case .circle(let x, let y, let r):
            let vector = VectorPoint(point: Point(x: x, y: y), in: rect)
            let designRadius = originalSize.maxRadius
            let radiusMultiplier = r / designRadius
            let radius = String(format: "(radius * %.5f)", radiusMultiplier)
            return ".addArc(center: \(vector.coreGraphicsDescription), radius: \(radius), startAngle: radians(0.0), endAngle: radians(360.0), clockwise: false)"
        
        case .rectangle(let x, let y, let w, let h, let rx, let ry):
            let radiusX = rx ?? 0.0
            let radiusY = ry ?? radiusX
            let designRadius = originalSize.maxRadius
            
            let widthMultiplier = w / designRadius
            let heightMultiplier = h / designRadius
            
            let vector = VectorPoint(point: Point(x: x, y: y), in: rect)
            
            let size = String(format: "CGSize(width: (radius * %.5f), height: (radius * %.5f))", widthMultiplier, heightMultiplier)
            let rect = "CGRect(origin: \(vector.coreGraphicsDescription), size: \(size))"
            
            if radiusX > 0.0 || radiusY > 0.0 {
                let corners = String(format: "cornerWidth: %.5f, cornerHeight: %.5f", radiusX, radiusY)
                return ".addRoundedRect(in: \(rect), \(corners))"
            } else {
                return ".addRect(\(rect))"
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
