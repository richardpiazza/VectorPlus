import Foundation
import XMLCoder

/// Basic shape, used to draw circles based on a center point and a radius.
///
/// The arc of a ‘circle’ element begins at the "3 o'clock" point on the radius and progresses towards the
/// "9 o'clock" point. The starting point and direction of the arc are affected by the user space transform
/// in the same manner as the geometry of the element.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/circle)
/// | [W3](https://www.w3.org/TR/SVG11/shapes.html#CircleElement)
public struct Circle: Codable, CoreAttributes, PresentationAttributes, StylingAttributes {
    
    /// The x-axis coordinate of the center of the circle.
    public var x: Float = 0.0
    /// The y-axis coordinate of the center of the circle.
    public var y: Float = 0.0
    /// The radius of the circle.
    public var r: Float = 0.0
    
    // CoreAttributes
    public var id: String?
    
    // PresentationAttributes
    public var fill: String?
    public var fillOpacity: Float?
    public var stroke: String?
    public var strokeWidth: Float?
    public var strokeOpacity: Float?
    public var transform: String?
    
    // StylingAttributes
    public var style: String?
    
    enum CodingKeys: String, CodingKey {
        case x = "cx"
        case y = "cy"
        case r = "r"
        case id
        case fill
        case fillOpacity = "fill-opacity"
        case stroke
        case strokeWidth = "stroke-width"
        case strokeOpacity = "stroke-opacity"
        case transform
        case style
    }
    
    public init() {
    }
    
    public init(x: Float, y: Float, r: Float) {
        self.x = x
        self.y = y
        self.r = r
    }
}

// MARK: - CustomStringConvertible
extension Circle: CustomStringConvertible {
    public var description: String {
        var components: [String] = []
        if !coreDescription.isEmpty {
            components.append(coreDescription)
        }
        if !presentationDescription.isEmpty {
            components.append(presentationDescription)
        }
        if !stylingDescription.isEmpty {
            components.append(stylingDescription)
        }
        
        let desc = String(format: "<circle cx=\"%.5f\" cy=\"%.5f\" r=\"%.5f\"", x, y, r)
        return desc + " " + components.joined(separator: " ") + " />"
    }
}

// MARK: - DynamicNodeEncoding
extension Circle: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Circle: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}
