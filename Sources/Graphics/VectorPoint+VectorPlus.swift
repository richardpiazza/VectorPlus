import Foundation
import Swift2D

public extension VectorPoint {
    var coreGraphicsDescription: String {
        return String(format: "CGPoint(x: center.x %@ (radius * %.5f), y: center.y %@ (radius * %.5f))", x.sign.rawValue, x.multiplier, y.sign.rawValue, y.multiplier)
    }
}
