import Foundation

public extension CGSize {
    var coreGraphicsDescription: String {
        return "CGSize(width: \(width), height: \(height))"
    }
}

extension CGSize {
    /// The horizontal radius (½ of `width`)
    var xRadius: CGFloat {
        return abs(width) / 2.0
    }
    
    /// The vertical radius (½ of `height`)
    var yRadius: CGFloat {
        return abs(height) / 2.0
    }
    
    /// The largest radius, out of `xRadius` & `yRadius`.
    var maxRadius: CGFloat {
        return max(xRadius, yRadius)
    }
    
    /// The smallest radius, out of `xRadius` & `yRadius`.
    var minRadius: CGFloat {
        return min(xRadius, yRadius)
    }
    
    /// The `Point` at which the `xRadius` & `yRadius` intersect.
    var center: CGPoint {
        return CGPoint(x: xRadius, y: yRadius)
    }
}
