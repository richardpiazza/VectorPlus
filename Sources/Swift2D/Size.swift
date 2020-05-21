import Foundation

/// A structure that contains width and height values.
public struct Size: Equatable {
    public var width: Float
    public var height: Float
    
    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
    
    public init(width: Int, height: Int) {
        self.width = Float(width)
        self.height = Float(height)
    }
}

public extension Size {
    static let zero: Size = Size(width: 0.0, height: 0.0)
    
    var xRadius: Float {
        return width / 2.0
    }
    
    var yRadius: Float {
        return height / 2.0
    }
    
    var maxRadius: Float {
        return max(xRadius, yRadius)
    }
    
    var minRadius: Float {
        return min(xRadius, yRadius)
    }
    
    var center: Point {
        return Point(x: xRadius, y: yRadius)
    }
}

// MARK: - CustomStringConvertible
extension Size: CustomStringConvertible {
    public var description: String {
        return String(format: "Size(width: %.5f, height: %.5f)", width, height)
    }
}

#if canImport(CoreGraphics)
import CoreGraphics

public extension Size {
    var cgSize: CGSize {
        return .init(width: CGFloat(width), height: CGFloat(height))
    }
}

public extension CGSize {
    init(_ size: Size) {
        self.init(width: CGFloat(size.width), height: CGFloat(size.height))
    }
    
    var size: Size {
        return Size(width: Float(width), height: Float(width))
    }
}

#endif
