import Foundation

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
    
    func applying(transformations: [Transformation]) -> Instruction {
        var points: [(x: Float, y: Float)] = []
        
        switch self {
        case .close:
            return self
        case .move(let x, let y), .line(let x, let y), .circle(let x, let y, _), .rectangle(let x, let y, _, _, _, _):
            points.append((x, y))
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            points.append((x, y))
            points.append((cx1, cy1))
            points.append((cx2, cy2))
        case .quadraticCurve(let x, let y, let cX, let cY):
            points.append((x, y))
            points.append((cX, cY))
        }
        
        for transform in transformations {
            switch transform {
            case .translate(let xOffset, let yOffset):
                let thePoints = points
                for i in 0..<thePoints.count {
                    points[i].x += xOffset
                    points[i].y += yOffset
                }
            }
        }
        
        switch self {
        case .move:
            return .move(x: points[0].x, y: points[0].y)
        case .line:
            return .line(x: points[0].x, y: points[0].y)
        case .bezierCurve:
            return .bezierCurve(x: points[0].x, y: points[0].y, cx1: points[1].x, cy1: points[1].y, cx2: points[2].x, cy2: points[2].y)
        case .quadraticCurve:
            return .quadraticCurve(x: points[0].x, y: points[0].y, cx: points[1].x, cy: points[1].y)
        case .circle(_, _, let r):
            return .circle(x: points[0].x, y: points[0].y, r: r)
        case .rectangle(_, _, let w, let h, let rx, let ry):
            return .rectangle(x: points[0].x, y: points[0].y, w: w, h: h, rx: rx, ry: ry)
        case .close:
            return self
        }
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
            return String(format: ".rectangle(x: %.5f, y: %.5f, w: %.5f, y: %.5f, rx: %@, ry: %@)", x, y, w, h, radiusX, radiusY)
        case .close:
            return ".close"
        }
    }
}

// MARK: - Equatable
extension Instruction: Equatable {}
