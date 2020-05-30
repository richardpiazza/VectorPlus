import Foundation
import XMLCoder

/// SVG basic shape used to create a line connecting two points.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/line)
/// | [W3](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/line)
public struct Line: Codable, CoreAttributes, PresentationAttributes, StylingAttributes {
    
    /// Defines the x-axis coordinate of the line starting point.
    public var x1: Float = 0.0
    /// Defines the x-axis coordinate of the line ending point.
    public var y1: Float = 0.0
    /// Defines the y-axis coordinate of the line starting point.
    public var x2: Float = 0.0
    /// Defines the y-axis coordinate of the line ending point.
    public var y2: Float = 0.0
    
    // CoreAttributes
    public var id: String?
    
    // PresentationAttributes
    public var fill: String?
    public var fillOpacity: Float?
    public var fillRule: Fill.Rule?
    public var stroke: String?
    public var strokeWidth: Float?
    public var strokeOpacity: Float?
    public var strokeLineCap: Stroke.LineCap?
    public var strokeLineJoin: Stroke.LineJoin?
    public var strokeMiterLimit: Float?
    public var transform: String?
    
    // StylingAttributes
    public var style: String?
    
    enum CodingKeys: String, CodingKey {
        case x1
        case y1
        case x2
        case y2
        case id
        case fill
        case fillOpacity = "fill-opacity"
        case fillRule = "fill-rule"
        case stroke
        case strokeWidth = "stroke-width"
        case strokeOpacity = "stroke-opacity"
        case strokeLineCap = "stroke-linecap"
        case strokeLineJoin = "stroke-linejoin"
        case strokeMiterLimit = "stroke-miterlimit"
        case transform
        case style
    }
    
    public init() {
    }
    
    public init(x1: Float, y1: Float, x2: Float, y2: Float) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }
}

// MARK: - CustomStringConvertible
extension Line: CustomStringConvertible {
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
        
        let desc = String(format: "<line x1=\"%.5f\", y1=\"%.5f\", x2=\"%.5f\", y2=\"%.5f\"", x1, y1, x2, y2)
        return desc + " " + components.joined(separator: " ") + " />"
    }
}

// MARK: - DynamicNodeEncoding
extension Line: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Line: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}
