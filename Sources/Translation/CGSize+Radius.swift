#if canImport(CoreGraphics)
import CoreGraphics

public extension CGSize {
    var xRadius: CGFloat {
        return width / 2.0
    }
    
    var yRadius: CGFloat {
        return height / 2.0
    }
    
    var maxRadius: CGFloat {
        return max(xRadius, yRadius)
    }
    
    var minRadius: CGFloat {
        return min(xRadius, yRadius)
    }
    
    var center: CGPoint {
        return CGPoint(x: xRadius, y: yRadius)
    }
}

#endif
