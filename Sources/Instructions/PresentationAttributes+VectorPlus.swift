import Foundation
import SwiftSVG
import SwiftColor

public extension PresentationAttributes {
    var fillColor: Color? {
        guard let fill = self.fill?.color, !fill.isEmpty else {
            return nil
        }
        
        return Color(fill)
    }
    
    var strokeColor: Color? {
        guard let stroke = self.stroke?.color, !stroke.isEmpty else {
            return nil
        }
        
        return Color(stroke)
    }
}
