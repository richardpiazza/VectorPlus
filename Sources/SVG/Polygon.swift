import Foundation
import XMLCoder

/// The closed shape consisting of a set of connected straight line segments.
///
/// If an odd number of coordinates is provided, then the element is in error.
///
/// [Polygon Specification](https://www.w3.org/TR/SVG11/shapes.html#PolygonElement)
public class Polygon: Codable, PresentationAttributes, DynamicNodeEncoding, DynamicNodeDecoding {
    
    /// The points that make up the polygon.
    public var points: String = ""
    public var fill: String?
    public var fillOpacity: Float?
    public var stroke: String?
    public var strokeWidth: Float?
    public var strokeOpacity: Float?
    public var transform: String?
    
    enum CodingKeys: String, CodingKey {
        case points
        case fill
        case fillOpacity = "fill-opacity"
        case stroke
        case strokeWidth = "stroke-width"
        case strokeOpacity = "stroke-opacity"
        case transform
    }
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
    
    public init() {
    }
    
    public init(points: String) {
        self.points = points
    }
}

// MARK: - CustomStringConvertible
extension Polygon: CustomStringConvertible {
    public var description: String {
        var desc = "<polygon points=\"\(points)\""
        if !presentationDescription.isEmpty {
            desc.append(" \(presentationDescription)")
        }
        desc.append(" />")
        return desc
    }
}
