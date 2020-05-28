import Foundation
import Swift2D

public extension Size {
    var coreGraphicsDescription: String {
        return String(format: "CGSize(width: %.5f, height: %.5f)", width, height)
    }
}
