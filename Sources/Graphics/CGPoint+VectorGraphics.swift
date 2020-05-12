import Foundation
import CoreGraphics
import GraphPoint
import SVG

extension CGPoint {
    init(x: Float, y: Float) {
        self.init(x: CGFloat(x), y: CGFloat(y))
    }
    
    /// Uses mathematical laws (trig) to determine where a specific point is in relation to the center of the design.
    ///
    /// This is necessary so that the resulting 'template' uses fractional multipliers to allow for any desired output size.
    ///
    /// - parameter originalSize: The original 'view box' size of the SVG
    func vectorPoint(translatedFrom originalSize: CGSize) -> VectorPoint {
        let radius = originalSize.maxRadius
        let contentRect = CGRect(origin: .zero, size: originalSize)
        let graphPoint = contentRect.graphPoint(for: self)
        
        let x: VectorOffset
        if graphPoint.x < 0 {
            x = (.minus, abs(graphPoint.x) / radius)
        } else {
            x = (.plus, graphPoint.x / radius)
        }
        
        let y: VectorOffset
        if graphPoint.y < 0 {
            y = (.plus, abs(graphPoint.y) / radius)
        } else {
            y = (.minus, graphPoint.y / radius)
        }
        
        return VectorPoint(x: x, y: y)
    }
}
