import Foundation

/// A cartesian-based vector that describes the relationship of any particular `Point` to the _center_ of a `Rect`.
public struct VectorPoint {
    public enum Sign: String {
        case plus = "+"
        case minus = "-"
    }
    
    public typealias Offset = (sign: Sign, multiplier: Float)
    
    public var x: Offset
    public var y: Offset
    
    /// Returns the `CGPoint` in the desired output size
    public func translate(to outputSize: Size) -> Point {
        let center = outputSize.center
        let radius = outputSize.minRadius
        
        switch (x.sign, y.sign) {
        case (.plus, .plus):
            return Point(x: center.x + (radius * x.multiplier), y: center.y + (radius * y.multiplier))
        case (.plus, .minus):
            return Point(x: center.x + (radius * x.multiplier), y: center.y - (radius * y.multiplier))
        case (.minus, .plus):
            return Point(x: center.x - (radius * x.multiplier), y: center.y + (radius * y.multiplier))
        case (.minus, .minus):
            return Point(x: center.x - (radius * x.multiplier), y: center.y - (radius * y.multiplier))
        }
    }
}

// MARK: - CustomStringConvertible
extension VectorPoint: CustomStringConvertible {
    public var description: String {
        return String(format: "VectorPoint(x: (%@, %.5f), y: (%@, %.5f))", x.sign.rawValue, x.multiplier, y.sign.rawValue, y.multiplier)
    }
}
