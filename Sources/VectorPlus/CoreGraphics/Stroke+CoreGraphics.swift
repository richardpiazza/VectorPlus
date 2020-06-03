import Foundation
import SwiftSVG
import SwiftColor

public extension Stroke {
    var swiftColor: Color? {
        guard let color = self.color, !color.isEmpty else {
            return nil
        }
        
        return Color(color)
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

#if canImport(CoreGraphics)
import CoreGraphics

public extension Stroke.LineCap {
    var cgLineCap: CGLineCap {
        switch self {
        case .butt: return .butt
        case .round: return .round
        case .square: return .square
        }
    }
}

public extension Stroke.LineJoin {
    var cgLineJoin: CGLineJoin {
        switch self {
        case .bevel: return .bevel
        case .arcs, .miter, .miterClip: return .miter
        case .round: return .round
        }
    }
}

#endif
