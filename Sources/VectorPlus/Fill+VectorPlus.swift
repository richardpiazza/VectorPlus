import SwiftSVG
import SwiftColor

public extension Fill {
    @available(*, deprecated, renamed: "pigment")
    var swiftColor: Color? { pigment }
    
    var pigment: Pigment? {
        guard let color = self.color, !color.isEmpty else {
            return nil
        }
        
        let _color = Pigment(color)
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
