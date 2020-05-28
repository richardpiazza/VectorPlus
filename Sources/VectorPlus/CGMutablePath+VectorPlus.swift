import Foundation
import Swift2D
import Graphics
#if canImport(CoreGraphics)
import CoreGraphics

public extension CGMutablePath {
    /// Adds an instruction to the _path_, using the provided rectangles to correctly scale the parameters.
    ///
    /// - parameter instruction: The `Instruction` to append
    /// - parameter from: The `Rect` which originally had the instruction. This is typically the `Document.originalSize`.
    /// - parameter to: The `Rect` defining the new size.
    func addInstruction(_ instruction: Instruction, from: Rect, to: Rect) {
        let translatedInstruction = instruction.translate(from: from, to: to)
        switch translatedInstruction {
        case .move(let x, let y):
            move(to: Point(x: x, y: y).cgPoint)
        case .line(let x, let y):
            addLine(to: Point(x: x, y: y).cgPoint)
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            addCurve(to: Point(x: x, y: y).cgPoint, control1: Point(x: cx1, y: cy1).cgPoint, control2: Point(x: cx2, y: cy2).cgPoint)
        case .quadraticCurve(let x, let y, let cx, let cy):
            addQuadCurve(to: Point(x: x, y: y).cgPoint, control: Point(x: cx, y: cy).cgPoint)
        case .circle(let x, let y, let r):
            addArc(center: Point(x: x, y: y).cgPoint, radius: CGFloat(r), startAngle: radians(0.0), endAngle: radians(360.0), clockwise: false)
        case .rectangle(let x, let y, let w, let h, let rx, let ry):
            let rect = Rect(x: x, y: y, width: w, height: h)
            switch (rx, ry) {
            case (.none, .none):
                addRect(rect.cgRect)
            default:
                addRoundedRect(in: rect.cgRect, cornerWidth: CGFloat(rx ?? 0.0), cornerHeight: CGFloat(ry ?? 0.0))
            }
        case .close:
            closeSubpath()
        }
    }
}

/// Convert the supplied degree to  radians.
fileprivate func radians(_ degree: Float) -> CGFloat {
    return CGFloat(degree) * (.pi / CGFloat(180))
}

#endif
