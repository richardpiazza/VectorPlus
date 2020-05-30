import Foundation
import SVG

public extension Fill.Rule {
    var coreGraphicsDescription: String {
        switch self {
        case .evenOdd: return ".evenOdd"
        case .nonZero: return ".winding"
        }
    }
}
