import Foundation
import Swift2D
import Graphics

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
