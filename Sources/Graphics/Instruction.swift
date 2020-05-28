import Foundation
import Swift2D
import SVG

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
    
    /// A **Rect** (rounded or not) element.
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
        /// Relative instructions are typically only used after another instruction
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
        case .translate(let Δx, let Δy):
            switch self {
            case .move(let x, let y):
                return .move(x: x + Δx, y: y + Δy)
            case .line(let x, let y):
                return .line(x: x + Δx, y: y + Δy)
            case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
                return .bezierCurve(x: x + Δx, y: y + Δy, cx1: cx1 + Δx, cy1: cy1 + Δy, cx2: cx2 + Δx, cy2: cy2 + Δy)
            case .quadraticCurve(let x, let y, let cx, let cy):
                return .quadraticCurve(x: x + Δx, y: y + Δy, cx: cx + Δx, cy: cy + Δy)
            case .circle(let x, let y, let r):
                return .circle(x: x + Δx, y: y + Δy, r: r)
            case .rectangle(let x, let y, let w, let h, let rx, let ry):
                return .rectangle(x: x + Δx, y: y + Δy, w: w, h: h, rx: rx, ry: ry)
            case .close:
                return .close
            }
        case .matrix:
            // TODO: determine what should happen here.
            return self
        }
    }
    
    func applying(transformations: [Transformation]) -> Instruction {
        var instruction = self
        
        transformations.forEach { (transformation) in
            instruction = instruction.applying(transformation: transformation)
        }
        
        return instruction
    }
    
    func translate(from: Rect, to: Rect) -> Instruction {
        switch self {
        case .move(let x, let y):
            let point = VectorPoint(x: x, y: y, in: from).translate(to: to)
            return .move(x: point.x, y: point.y)
        case .line(let x, let y):
            let point = VectorPoint(x: x, y: y, in: from).translate(to: to)
            return .line(x: point.x, y: point.y)
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            let point = VectorPoint(x: x, y: y, in: from).translate(to: to)
            let control1 = VectorPoint(x: cx1, y: cy1, in: from).translate(to: to)
            let control2 = VectorPoint(x: cx2, y: cy2, in: from).translate(to: to)
            return .bezierCurve(x: point.x, y: point.y, cx1: control1.x, cy1: control1.y, cx2: control2.x, cy2: control2.y)
        case .quadraticCurve(let x, let y, let cx, let cy):
            let point = VectorPoint(x: x, y: y, in: from).translate(to: to)
            let control = VectorPoint(x: cx, y: cy, in: from).translate(to: to)
            return .quadraticCurve(x: point.x, y: point.y, cx: control.x, cy: control.y)
        case .circle(let x, let y, let r):
            let point = VectorPoint(x: x, y: y, in: from).translate(to: to)
            let toRadius = (r / from.size.minRadius) * to.size.maxRadius
            return .circle(x: point.x, y: point.y, r: toRadius)
        case .rectangle(let x, let y, let w, let h, let rx, let ry):
            let point = VectorPoint(x: x, y: y, in: from).translate(to: to)
            let width = (w / from.size.minRadius) * to.size.maxRadius
            let height = (h / from.size.minRadius) * to.size.maxRadius
            let radiusX = (rx != nil) ? (rx! / w) * width : nil
            let radiusY = (ry != nil) ? (ry! / h) * height : nil
            return .rectangle(x: point.x, y: point.y, w: width, h: height, rx: radiusX, ry: radiusY)
        case .close:
            return .close
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
            return String(format: ".rectangle(x: %.5f, y: %.5f, w: %.5f, y: %.5f, rx: \(radiusX), ry: \(radiusY))", x, y, w, h)
        case .close:
            return ".close"
        }
    }
}

// MARK: - Equatable
extension Instruction: Equatable {}
