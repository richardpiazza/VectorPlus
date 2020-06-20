import Foundation
import SwiftSVG
import SwiftColor

public extension Fill {
    var swiftColor: Color? {
        guard let color = self.color, !color.isEmpty else {
            return nil
        }
        
        return Color(color)
    }
}

public extension Fill.Rule {
    var coreGraphicsDescription: String {
        switch self {
        case .evenOdd: return ".evenOdd"
        case .nonZero: return ".winding"
        }
    }
}
