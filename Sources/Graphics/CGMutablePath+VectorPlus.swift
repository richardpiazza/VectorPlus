import Foundation
import Swift2D
#if canImport(CoreGraphics)
import CoreGraphics

public extension CGMutablePath {
    func addInstruction(_ instruction: Instruction, originalSize: Size, outputSize: Size) {
        let rect = Rect(origin: .zero, size: originalSize)
        
        switch instruction {
        case .move(let x, let y):
            let vector = VectorPoint(point: Point(x: x, y: y), in: rect)
            let point = vector.translate(to: outputSize)
            
            move(to: point.cgPoint)
            
        case .line(let x, let y):
            let vector = VectorPoint(point: Point(x: x, y: y), in: rect)
            let point = vector.translate(to: outputSize)
            
            addLine(to: point.cgPoint)
            
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            var vector = VectorPoint(point: Point(x: x, y: y), in: rect)
            let point = vector.translate(to: outputSize)
            
            vector = VectorPoint(point: Point(x: cx1, y: cy1), in: rect)
            let control1 = vector.translate(to: outputSize)
            
            vector = VectorPoint(point: Point(x: cx2, y: cy2), in: rect)
            let control2 = vector.translate(to: outputSize)
            
            addCurve(to: point.cgPoint, control1: control1.cgPoint, control2: control2.cgPoint)
            
        case .quadraticCurve(let x, let y, let cx, let cy):
            var vector = VectorPoint(point: Point(x: x, y: y), in: rect)
            let point = vector.translate(to: outputSize)
            
            vector = VectorPoint(point: Point(x: cx, y: cy), in: rect)
            let control = vector.translate(to: outputSize)
            
            addQuadCurve(to: point.cgPoint, control: control.cgPoint)
            
        case .circle(let x, let y, let r):
            let vector = VectorPoint(point: Point(x: x, y: y), in: rect)
            let point = vector.translate(to: outputSize)
            let designRadius = min(outputSize.width / 2.0, outputSize.height / 2.0)
            let cR = outputSize.maxRadius * (r / designRadius)
            
            addArc(center: point.cgPoint, radius: CGFloat(cR), startAngle: radians(0.0), endAngle: radians(360.0), clockwise: false)
            
        case .rectangle(let x, let y, let w, let h, let rx, let ry):
            let vector = VectorPoint(point: Point(x: x, y: y), in: rect)
            let point = vector.translate(to: outputSize)
            
            let radiusX = rx ?? 0.0
            let radiusY = ry ?? radiusX
            let designRadius = min(outputSize.width / 2.0, outputSize.height / 2.0)
            
            let widthMultiplier = w / designRadius
            let heightMultiplier = h / designRadius
            
            let width = outputSize.maxRadius * widthMultiplier
            let height = outputSize.maxRadius * heightMultiplier
            let size = Size(width: width, height: height).cgSize
            
            let rect = CGRect(origin: point.cgPoint, size: size)
            
            if radiusX > 0.0 || radiusY > 0.0 {
                addRoundedRect(in: rect, cornerWidth: CGFloat(radiusX), cornerHeight: CGFloat(radiusY))
            } else {
                addRect(rect)
            }
            
        case .close:
            closeSubpath()
        }
    }
}

fileprivate func radians(_ degree: Float) -> CGFloat {
    return CGFloat(degree) * (.pi / CGFloat(180))
}

#endif
