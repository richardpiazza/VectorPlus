import Foundation
import SVG
#if canImport(CoreGraphics)
import CoreGraphics

public extension PresentationAttributes {
    var cgFillColor: CGColor? {
        return fillColor?.cgColor
    }
    
    var cgStrokeColor: CGColor? {
        return strokeColor?.cgColor
    }
    
    var cgStrokeLineCap: CGLineCap? {
        guard let strokeLineCap = self.strokeLineCap else {
            return nil
        }
        
        switch strokeLineCap {
        case .butt:
            return .butt
        case .round:
            return .round
        case .square:
            return .square
        }
    }
    
    var cgStrokeLineJoin: CGLineJoin? {
        guard let strokeLineJoin = self.strokeLineJoin else {
            return nil
        }
        
        switch strokeLineJoin {
        case .bevel:
            return .bevel
        case .arcs, .miter, .miterClip:
            return .miter
        case .round:
            return .round
        }
    }
}
#endif
