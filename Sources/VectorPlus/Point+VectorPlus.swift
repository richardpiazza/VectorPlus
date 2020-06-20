import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public extension CGPoint {
    var coreGraphicsDescription: String {
        return "CGPoint(x: \(x), y: \(y))"
    }
}
