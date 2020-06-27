import SwiftColor

public extension Color {
    var coreGraphicsDescription: String {
        return "CGColor(srgbRed: \(red), green: \(green), blue: \(blue), alpha: \(alpha))"
    }
}
