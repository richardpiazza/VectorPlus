import Foundation

enum VectorSign: String {
    case plus = "+"
    case minus = "-"
}

typealias VectorOffset = (sign: VectorSign, multiplier: Float)

/// A cartesian-based vector that describes the relationship of any particular `Point` to the _center_ of a `Rect`.
public struct VectorPoint {
    var x: VectorOffset
    var y: VectorOffset
    
    /// Returns the `CGPoint` in the desired output size
    func translate(to outputSize: Size) -> Point {
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

extension VectorPoint: CustomStringConvertible {
    public var description: String {
        return String(format: "CGPoint(x: center.x %@ (radius * %.5f), y: center.y %@ (radius * %.5f))", x.sign.rawValue, x.multiplier, y.sign.rawValue, y.multiplier)
    }
}
