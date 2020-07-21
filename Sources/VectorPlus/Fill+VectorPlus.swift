import SwiftSVG
import SwiftColor

public extension Fill {
    var swiftColor: Color? {
        guard let color = self.color, !color.isEmpty else {
            return nil
        }
        
        let _color = Color(color)
        guard _color.alpha != 0.0 else {
            return nil
        }
        
        return _color
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
