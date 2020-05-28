import Foundation
import Swift2D

public extension Point {
    var coreGraphicsDescription: String {
        return String(format: "CGPoint(x: %.5f, y: %.5f)", x, y)
    }
}
