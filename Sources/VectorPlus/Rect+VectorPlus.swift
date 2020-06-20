import Foundation

public extension CGRect {
    var coreGraphicsDescription: String {
        return "CGRect(origin: \(origin.coreGraphicsDescription), size: \(size.coreGraphicsDescription))"
    }
}
