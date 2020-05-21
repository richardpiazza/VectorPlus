import Foundation
import Swift2D

public extension Rect {
    var coreGraphicsDescription: String {
        return String(format: "CGRect(origin: %@, size: %@)", origin.coreGraphicsDescription, size.coreGraphicsDescription)
    }
}
