import Core

extension Instruction {
    /// The specific `CoreGraphics` command that is needed to execute the `Instruction`.
    ///
    /// It is assumed that all required transformations has been applied (_squaring_) before calling this method.
    ///
    /// - parameter originalSize: Supplied to correctly determine how to proportionally scale the instruction.
    func coreGraphicsDescription(originalSize: Size) -> String {
        switch self {
        case .move(let x, let y):
            let vector = Point(x: x, y: y).vectorPoint(from: originalSize)
            return String(format: ".move(to: %@)", vector.description)
        
        case .line(let x, let y):
            let vector = Point(x: x, y: y).vectorPoint(from: originalSize)
            return String(format: ".addLine(to: %@)", vector.description)
        
        case .bezierCurve(let x, let y, let cx1, let cy1, let cx2, let cy2):
            let pointVector = Point(x: x, y: y).vectorPoint(from: originalSize)
            let control1Vector = Point(x: cx1, y: cy1).vectorPoint(from: originalSize)
            let control2Vector = Point(x: cx2, y: cy2).vectorPoint(from: originalSize)
            return String(format: ".addCurve(to: %@, control1: %@, control2: %@)", pointVector.description, control1Vector.description, control2Vector.description)
        
        case .quadraticCurve(let x, let y, let cX, let cY):
            let pointVector = Point(x: x, y: y).vectorPoint(from: originalSize)
            let controlVector = Point(x: cX, y: cY).vectorPoint(from: originalSize)
            return String(format: ".addQuadCurve(to: %@, control: %@)", pointVector.description, controlVector.description)
        
        case .circle(let x, let y, let r):
            let vector = Point(x: x, y: y).vectorPoint(from: originalSize)
            let designRadius = originalSize.maxRadius
            let radiusMultiplier = r / designRadius
            let radius = String(format: "(radius * %.5f)", radiusMultiplier)
            return String(format: ".addArc(center: %@, radius: %@, startAngle: radians(0.0), endAngle: radians(360.0), clockwise: false)", vector.description, radius)
        
        case .rectangle(let x, let y, let w, let h, let rx, let ry):
            let radiusX = rx ?? 0.0
            let radiusY = ry ?? radiusX
            let designRadius = originalSize.maxRadius
            
            let widthMultiplier = w / designRadius
            let heightMultiplier = h / designRadius
            
            let vector = Point(x: x, y: y).vectorPoint(from: originalSize)
            
            let size = String(format: "CGSize(width: (radius * %.5f), height: (radius * %.5f))", widthMultiplier, heightMultiplier)
            let rect = String(format: "CGRect(origin: %@, size: %@)", vector.description, size)
            
            if radiusX > 0.0 || radiusY > 0.0 {
                return String(format: ".addRoundedRect(in: %@, cornerWidth: %.5f, cornerHeight: %.5f)", rect, radiusX, radiusY)
            } else {
                return String(format: ".addRect(%@)", rect)
            }
        
        case .close:
            return ".closeSubpath()"
        }
    }
}
