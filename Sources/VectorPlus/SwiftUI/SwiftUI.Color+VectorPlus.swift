import SwiftColor
#if canImport(SwiftUI)
import SwiftUI

extension SwiftUI.Color {
    static func make(_ color: SwiftColor.Pigment) -> SwiftUI.Color {
        SwiftUI.Color(red: Double(color.red), green: Double(color.green), blue: Double(color.blue)).opacity(Double(color.alpha))
    }
}
#endif
