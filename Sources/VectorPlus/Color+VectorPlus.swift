import SwiftColor

public extension Pigment {
    var coreGraphicsDescription: String {
        return "CGColor(srgbRed: \(red), green: \(green), blue: \(blue), alpha: \(alpha))"
    }
}
