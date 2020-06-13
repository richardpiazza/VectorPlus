import Foundation
import Swift2D
import SwiftSVG

public extension Path.Command {
    func coreGraphicsDescription(originalSize: Size) -> String {
        let rect = Rect(origin: .zero, size: originalSize)
        
        switch self {
        case .moveTo(let point):
            let _point = VectorPoint(point: point, in: rect)
            return ".move(to: \(_point.coreGraphicsDescription))"
        case .lineTo(let point):
            let _point = VectorPoint(point: point, in: rect)
            return ".addLine(to: \(_point.coreGraphicsDescription))"
        case .cubicBezierCurve(let cp1, let cp2, let point):
            let _cp1 = VectorPoint(point: cp1, in: rect)
            let _cp2 = VectorPoint(point: cp2, in: rect)
            let _point = VectorPoint(point: point, in: rect)
            return ".addCurve(to: \(_point.coreGraphicsDescription), control1: \(_cp1.coreGraphicsDescription), control2: \(_cp2.coreGraphicsDescription))"
        case .quadraticBezierCurve(let cp, let point):
            let _cp = VectorPoint(point: cp, in: rect)
            let _point = VectorPoint(point: point, in: rect)
            return ".addQuadCurve(to: \(_point.coreGraphicsDescription), control: \(_cp.coreGraphicsDescription))"
        case .ellipticalArcCurve:
            #warning("No Implementation (convert to Bezier)")
            return ""
        case .closePath:
            return ".closeSubpath()"
        }
    }
}
