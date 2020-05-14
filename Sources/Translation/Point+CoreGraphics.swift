import Foundation
import Core
#if canImport(CoreGraphics)
import CoreGraphics

extension Point {
    var cgPoint: CGPoint {
        return .init(x: CGFloat(x), y: CGFloat(y))
    }
}

extension CGPoint {
    init(_ point: Point) {
        self.init(x: CGFloat(point.x), y: CGFloat(point.y))
    }
}

#endif
