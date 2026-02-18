#if canImport(SwiftUI)
import SwiftColor
import SwiftUI

extension Color {
    static func make(_ color: Pigment) -> Color {
        Color(red: color.red, green: color.green, blue: color.blue).opacity(color.alpha)
    }
}
#endif
