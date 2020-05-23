import Foundation
import Swift2D

public extension VectorPoint {
    var coreGraphicsDescription: String {
        return String(format: "CGPoint(x: center.x \(x.sign.rawValue) (radius * %.5f), y: center.y \(y.sign.rawValue) (radius * %.5f))", x.multiplier, y.multiplier)
    }
}
