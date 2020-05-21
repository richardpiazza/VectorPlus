import Foundation

/// A structure that contains the location and dimensions of a rectangle.
public struct Rect: Equatable {
    public var origin: Point
    public var size: Size
    
    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    public init(x: Float, y: Float, width: Float, height: Float) {
        origin = Point(x: x, y: y)
        size = Size(width: width, height: height)
    }
}

extension Rect: CustomStringConvertible {
    public var description: String {
        return String(format: "Rect(origin: %@, size: %@)", origin.description, size.description)
    }
}

public extension Rect {
    var cartesianOrigin: Point {
        return Point(x: size.width / 2.0, y: size.height / 2.0)
    }
    
    /// Translaste the provided point within the `Rect` from using the top-left
    /// as the _origin_, to using the center as the _origin_.
    ///
    /// For example: Given `Rect(x: 0, y: 0, width: 100, height: 100)`, the point
    /// `Point(x: 25, y: 25)` would translate to `Point(x: -25, y: 25)`.
    func cartesianPoint(for point: Point) -> Point {
        let origin = cartesianOrigin
        var cartesianPoint = Point(x: 0, y: 0)
        
        if point.x < origin.x {
            cartesianPoint.x = -(origin.x - point.x)
        } else if point.x > origin.x {
            cartesianPoint.x = point.x - origin.x
        }
        
        if point.y > origin.y {
            cartesianPoint.y = -(point.y - origin.y)
        } else if point.y < origin.y {
            cartesianPoint.y = origin.y - point.y
        }
        
        return cartesianPoint
    }
}
