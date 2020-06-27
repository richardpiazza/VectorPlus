import SwiftSVG
import Swift2D
#if canImport(CoreGraphics)
import CoreGraphics

public extension CGMutablePath {
    /// Adds a `Path.Command` to a _CoreGraphics path_, using the provided rectangles to correctly scale the parameters.
    ///
    /// - parameter command: The `Path.Command` to append
    /// - parameter from: The `Rect` which originally had the instruction. This is typically the `Document.originalSize`.
    /// - parameter to: The `Rect` defining the new size.
    /// - parameter previousPoint: The last `Point`, used for Elliptical Arc calculations
    func addCommand(_ command: Path.Command, from: Rect, to: Rect, previousPoint: Point? = nil) {
        let translated = command.translate(from: from, to: to)
        switch translated {
        case .moveTo(let point):
            move(to: point.cgPoint)
        case .lineTo(let point):
            addLine(to: point.cgPoint)
        case .cubicBezierCurve(let cp1, let cp2, let point):
            addCurve(to: point.cgPoint, control1: cp1.cgPoint, control2: cp2.cgPoint)
        case .quadraticBezierCurve(let cp, let point):
            addQuadCurve(to: point.cgPoint, control: cp.cgPoint)
        case .ellipticalArcCurve(_, _, _, _, _, let point):
            guard let previousPoint = previousPoint else {
                addLine(to: point.cgPoint)
                return
            }
            
            do {
                let curves = try command.convertToCubicBezierCurves(with: previousPoint)
                curves.forEach { (curve) in
                    addCommand(curve, from: from, to: to)
                }
            } catch {
                print(error)
                addLine(to: point.cgPoint)
            }
        case .closePath:
            closeSubpath()
        }
    }
}

#endif
