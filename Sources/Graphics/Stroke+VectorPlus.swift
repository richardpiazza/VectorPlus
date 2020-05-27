import Foundation
import SVG

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
