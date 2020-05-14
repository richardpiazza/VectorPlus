import Foundation
import Core
#if canImport(CoreGraphics)
import CoreGraphics

extension Size {
    var cgSize: CGSize {
        return .init(width: CGFloat(width), height: CGFloat(height))
    }
}

extension CGSize {
    init(_ size: Size) {
        self.init(width: CGFloat(size.width), height: CGFloat(size.height))
    }
    
    var size: Size {
        return Size(width: Float(width), height: Float(width))
    }
}

#endif
