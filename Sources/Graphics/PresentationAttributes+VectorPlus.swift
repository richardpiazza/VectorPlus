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

#if canImport(AppKit)
import AppKit

public extension PresentationAttributes {
    var cgFillColor: CGColor? {
        return fillColor?.cgColor
    }
    
    var cgStrokeColor: CGColor? {
        return strokeColor?.cgColor
    }
}
#elseif canImport(UIKit)
import UIKit

public extension PresentationAttributes {
    var cgFillColor: CGColor? {
        return fillColor?.cgColor
    }
    
    var cgStrokeColor: CGColor? {
        return strokeColor?.cgColor
    }
}
#endif
