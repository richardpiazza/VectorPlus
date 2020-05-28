import Foundation
import SVG
import SwiftColor

public extension PresentationAttributes {
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
