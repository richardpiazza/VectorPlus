import Foundation

public struct Point {
    public var x: Float
    public var y: Float
    
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}

public extension Point {
    static let nan: Point = Point(x: .nan, y: .nan)
    static let zero: Point = Point(x: 0.0, y: 0.0)
    
    func vectorPoint(from originalSize: Size) -> VectorPoint {
        let radius = originalSize.maxRadius
        let rect = Rect(origin: .zero, size: originalSize)
        let cartesianPoint = rect.cartesianPoint(for: self)
        
        let xOffset: VectorOffset
        if cartesianPoint.x < 0 {
            xOffset = (.minus, abs(cartesianPoint.x) / radius)
        } else {
            xOffset = (.plus, cartesianPoint.x / radius)
        }
        
        let yOffset: VectorOffset
        if cartesianPoint.y < 0 {
            yOffset = (.plus, abs(cartesianPoint.y) / radius)
        } else {
            yOffset = (.minus, cartesianPoint.y / radius)
        }
        
        return VectorPoint(x: xOffset, y: yOffset)
    }
    
    /// Shortcut that first uses `vectorPoint(from:)` to generate a `VectorPoint`, which
    /// than calls `translate(to:)`.
    func translate(from originalSize: Size, to outputSize: Size) -> Point {
        return vectorPoint(from: originalSize).translate(to: outputSize)
    }
}

extension Point: CustomStringConvertible {
    public var description: String {
        return String(format: "CGPoint(x: %.5f, y: %.5f)", x, y)
    }
}
