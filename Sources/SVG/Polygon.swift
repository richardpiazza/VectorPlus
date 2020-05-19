import Foundation
import XMLCoder

/// The closed shape consisting of a set of connected straight line segments.
///
/// If an odd number of coordinates is provided, then the element is in error.
///
/// [Polygon Specification](https://www.w3.org/TR/SVG11/shapes.html#PolygonElement)
public class Polygon: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
    
    /// The points that make up the polygon.
    public var points: String = ""
    
    enum CodingKeys: String, CodingKey {
        case points
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
        return String(format: "<polygon points=\"%@\" />", points)
    }
}
