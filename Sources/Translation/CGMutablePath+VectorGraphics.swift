import Foundation
import SVG

#if canImport(CoreGraphics)
import CoreGraphics

public extension CGMutablePath {
    func addInstruction(_ instruction: Instruction, originalSize: CGSize, outputSize: CGSize) {
        switch instruction {
        case .move(let x, let y):
            let vector = CGPoint(x: x, y: y).vectorPoint(translatedFrom: originalSize)
            let point = vector.point(translatedTo: outputSize)
            move(to: point)
        case .line(let x, let y):
            let vector = CGPoint(x: x, y: y).vectorPoint(translatedFrom: originalSize)
            let point = vector.point(translatedTo: outputSize)
            addLine(to: point)
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            let vector = CGPoint(x: x, y: y).vectorPoint(translatedFrom: originalSize)
            let p = vector.point(translatedTo: outputSize)
            let control1 = CGPoint(x: CGFloat(cx1), y: CGFloat(cy1))
            let c1 = control1.vectorPoint(translatedFrom: originalSize).point(translatedTo: outputSize)
            let control2 = CGPoint(x: CGFloat(cx2), y: CGFloat(cy2))
            let c2 = control2.vectorPoint(translatedFrom: originalSize).point(translatedTo: outputSize)
            addCurve(to: p, control1: c1, control2: c2)
        case .quadraticCurve(let x, let y, let cx, let cy):
            let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
            let vector = point.vectorPoint(translatedFrom: originalSize)
            let p = vector.point(translatedTo: outputSize)
            let control = CGPoint(x: CGFloat(cx), y: CGFloat(cy))
            let c = control.vectorPoint(translatedFrom: originalSize).point(translatedTo: outputSize)
            addQuadCurve(to: p, control: c)
        case .circle(let x, let y, let r):
            let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
            let vector = point.vectorPoint(translatedFrom: originalSize)
            let p = vector.point(translatedTo: outputSize)
            let designRadius = min(outputSize.width / 2.0, outputSize.height / 2.0)
            let radiusMultiplier = CGFloat(r) / designRadius
            let cR = outputSize.maxRadius * radiusMultiplier
            addArc(center: p, radius: cR, startAngle: radians(0.0), endAngle: radians(360.0), clockwise: false)
        case .rectangle(let x, let y, let w, let h, let rx, let ry):
            let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
            let vector = point.vectorPoint(translatedFrom: originalSize)
            let p = vector.point(translatedTo: outputSize)
            
            let radiusX = rx ?? 0.0
            let radiusY = ry ?? radiusX
            let designRadius = min(outputSize.width / 2.0, outputSize.height / 2.0)
            
            let widthMultiplier = CGFloat(w) / designRadius
            let heightMultiplier = CGFloat(h) / designRadius
            
            let size = CGSize(width: (outputSize.maxRadius * widthMultiplier), height: (outputSize.maxRadius * heightMultiplier))
            let rect = CGRect(origin: p, size: size)
            
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
