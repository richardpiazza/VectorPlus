import Foundation
import Swift2D

public extension VectorPoint {
    init(x: Float, y: Float, in rect: Rect) {
        self.init(point: Point(x: x, y: y), in: rect)
    }
}
