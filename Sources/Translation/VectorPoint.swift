import Foundation

#if canImport(CoreGraphics)
import CoreGraphics

enum VectorSign: String {
    case plus = "+"
    case minus = "-"
}

typealias VectorOffset = (sign: VectorSign, multiplier: CGFloat)

/// A cartesian-based vector that describes the relationship of any particular `CGPoint` to the 'center' of a `CGRect`.
struct VectorPoint {
    var x: VectorOffset
    var y: VectorOffset
}

extension VectorPoint: CustomStringConvertible {
    var description: String {
        return String(format: "CGPoint(x: center.x %@ (radius * %.5f), y: center.y %@ (radius * %.5f))", x.sign.rawValue, x.multiplier, y.sign.rawValue, y.multiplier)
    }
}

extension VectorPoint {
    /// Returns the CGPoint in given size
    func point(translatedTo outputSize: CGSize) -> CGPoint {
        let center = outputSize.center
        let radius = outputSize.minRadius
        
        switch (x.sign, y.sign) {
        case (.plus, .plus):
            return CGPoint(x: center.x + (radius * x.multiplier), y: center.y + (radius * y.multiplier))
        case (.plus, .minus):
            return CGPoint(x: center.x + (radius * x.multiplier), y: center.y - (radius * y.multiplier))
        case (.minus, .plus):
            return CGPoint(x: center.x - (radius * x.multiplier), y: center.y + (radius * y.multiplier))
        case (.minus, .minus):
            return CGPoint(x: center.x - (radius * x.multiplier), y: center.y - (radius * y.multiplier))
        }
    }
}

#endif
