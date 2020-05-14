import Foundation

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

extension Size: CustomStringConvertible {
    public var description: String {
        return String(format: "CGSize(width: %.5f, height: %.5f)", width, height)
    }
}
