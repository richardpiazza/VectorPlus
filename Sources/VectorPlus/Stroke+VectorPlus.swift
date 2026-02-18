import SwiftSVG
import SwiftColor

public extension Stroke {
    @available(*, deprecated, renamed: "pigment")
    var swiftColor: Pigment? { pigment }
    
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

public extension Stroke.LineCap {
    var coreGraphicsDescription: String {
        switch self {
        case .butt: return ".butt"
        case .round: return ".round"
        case .square: return ".square"
        }
    }
}

public extension Stroke.LineJoin {
    var coreGraphicsDescription: String {
        switch self {
        case .bevel: return ".bevel"
        case .arcs, .miter, .miterClip: return ".miter"
        case .round: return ".round"
        }
    }
}
