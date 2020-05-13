import Foundation
import SVG

#if canImport(CoreGraphics)
import CoreGraphics

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

private extension CGRect {
    /// Translates a `CGPoint` to a cartesian-based `CGPoint`.
    ///
    /// - parameter point: A point within the instance `CGRect`
    /// - returns: Catesian coordinates for the supplied point.
    func graphPoint(for point: CGPoint) -> CGPoint {
        let graphOrigin = CGPoint(x: midX, y: midY)
        var graphPoint = CGPoint.zero
        
        if point.x < graphOrigin.x {
            graphPoint.x = -(graphOrigin.x - point.x)
        } else if point.x > graphOrigin.x {
            graphPoint.x = point.x - graphOrigin.x
        }
        
        if point.y > graphOrigin.y {
            graphPoint.y = -(point.y - graphOrigin.y)
        } else if point.y < graphOrigin.y {
            graphPoint.y = graphOrigin.y - point.y
        }
        
        return graphPoint
    }
}

#endif
