import SwiftColor
#if canImport(SwiftUI)
import SwiftUI

extension SwiftUI.Color {
    static func make(_ color: SwiftColor.Pigment) -> SwiftUI.Color {
        SwiftUI.Color(red: color.red, green: color.green, blue: color.blue).opacity(color.alpha)
    }
}
#endif
