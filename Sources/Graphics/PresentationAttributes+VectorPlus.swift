import Foundation
import SVG
import SwiftColor

public extension PresentationAttributes {
    var transformations: [Transformation] {
        let value = transform?.replacingOccurrences(of: " ", with: "") ?? ""
        guard !value.isEmpty else {
            return []
        }
        
        let values = value.split(separator: ")").map({ $0.appending(")") })
        return values.compactMap({ Transformation($0) })
    }
    
    var fillColor: Color? {
        guard let fill = self.fill, !fill.isEmpty else {
            return nil
        }
        
        return Color(fill)
    }
    
    var strokeColor: Color? {
        guard let stroke = self.stroke, !stroke.isEmpty else {
            return nil
        }
        
        return Color(stroke)
    }
}

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
