import Foundation
import Core
#if canImport(CoreGraphics)
import CoreGraphics

public extension CGMutablePath {
    func addInstruction(_ instruction: Instruction, originalSize: Size, outputSize: Size) {
        switch instruction {
        case .move(let x, let y):
            let point = Point(x: x, y: y).translate(from: originalSize, to: outputSize).cgPoint
            move(to: point)
            
        case .line(let x, let y):
            let point = Point(x: x, y: y).translate(from: originalSize, to: outputSize).cgPoint
            addLine(to: point)
            
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            let point = Point(x: x, y: y).translate(from: originalSize, to: outputSize).cgPoint
            let control1 = Point(x: cx1, y: cy1).translate(from: originalSize, to: outputSize).cgPoint
            let control2 = Point(x: cx2, y: cy2).translate(from: originalSize, to: outputSize).cgPoint
            addCurve(to: point, control1: control1, control2: control2)
            
        case .quadraticCurve(let x, let y, let cx, let cy):
            let point = Point(x: x, y: y).translate(from: originalSize, to: outputSize).cgPoint
            let control = Point(x: cx, y: cy).translate(from: originalSize, to: outputSize).cgPoint
            addQuadCurve(to: point, control: control)
            
        case .circle(let x, let y, let r):
            let point = Point(x: x, y: y).translate(from: originalSize, to: outputSize).cgPoint
            let designRadius = min(outputSize.width / 2.0, outputSize.height / 2.0)
            let cR = outputSize.maxRadius * (r / designRadius)
            addArc(center: point, radius: CGFloat(cR), startAngle: radians(0.0), endAngle: radians(360.0), clockwise: false)
            
        case .rectangle(let x, let y, let w, let h, let rx, let ry):
            let point = Point(x: x, y: y).translate(from: originalSize, to: outputSize).cgPoint
            
            let radiusX = rx ?? 0.0
            let radiusY = ry ?? radiusX
            let designRadius = min(outputSize.width / 2.0, outputSize.height / 2.0)
            
            let widthMultiplier = w / designRadius
            let heightMultiplier = h / designRadius
            
            let width = outputSize.maxRadius * widthMultiplier
            let height = outputSize.maxRadius * heightMultiplier
            let size = Size(width: width, height: height).cgSize
            
            let rect = CGRect(origin: point, size: size)
            
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
