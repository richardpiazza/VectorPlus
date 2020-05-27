import Foundation
import XMLCoder

/// SVG basic shape that creates straight lines connecting several points.
///
/// Typically a polyline is used to create open shapes as the last point doesn't have to be connected to the first point.
/// For closed shapes see the `Polygon` element.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/polyline)
/// | [W3](https://www.w3.org/TR/SVG11/shapes.html#PolylineElement)
public struct Polyline: Codable, CoreAttributes, PresentationAttributes, StylingAttributes {
    
    public var points: String = ""
    
    // CoreAttributes
    public var id: String?
    
    // PresentationAttributes
    public var fill: String?
    public var fillOpacity: Float?
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
        case points
        case id
        case fill
        case fillOpacity = "fill-opacity"
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
    
    public init(points: String) {
        self.points = points
    }
}

// MARK: - CustomStringConvertible
extension Polyline: CustomStringConvertible {
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
        
        return "<polyline points=\"\(points)\" " + components.joined(separator: " ") + " />"
    }
}

// MARK: - DynamicNodeEncoding
extension Polyline: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Polyline: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}
