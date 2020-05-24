import Foundation
import Swift2D

public extension VectorPoint {
    init(x: Float, y: Float, in rect: Rect) {
        self.init(point: Point(x: x, y: y), in: rect)
    }
    
    var coreGraphicsDescription: String {
        return String(format: "CGPoint(x: center.x \(x.sign.rawValue) (radius * %.5f), y: center.y \(y.sign.rawValue) (radius * %.5f))", x.multiplier, y.multiplier)
    }
}
