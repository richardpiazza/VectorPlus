import Foundation
import SwiftColor

public extension Color {
    var coreGraphicsDescription: String {
        return String(format: "CGColor(srgbRed: %.3f, green: %.3f, blue: %.3f, alpha: %.3f)", red, green, blue, alpha)
    }
}
