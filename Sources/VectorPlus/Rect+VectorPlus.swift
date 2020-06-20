import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public extension CGRect {
    var coreGraphicsDescription: String {
        return "CGRect(origin: \(origin.coreGraphicsDescription), size: \(size.coreGraphicsDescription))"
    }
}
