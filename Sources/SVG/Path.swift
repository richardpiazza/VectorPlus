import Foundation
import XMLCoder

/// A [Path](https://www.w3.org/TR/SVG11/paths.html) represents the outline of a shape
///
/// A path is defined by including a ‘path’ element in a SVG document which contains a **d="(path data)"**
/// attribute, where the **‘d’** attribute contains the moveto, line, curve (both cubic and quadratic Béziers),
/// arc and closepath instructions.
public struct Path: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
    
    /// The definition of the outline of a shape.
    public var data: String = ""
    
    enum CodingKeys: String, CodingKey {
        case data = "d"
    }
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
    
    public init() {
        
    }
    
    public init(data: String) {
        self.data = data
    }
}

// MARK: - CustomStringConvertible
extension Path: CustomStringConvertible {
    public var description: String {
        return String(format: "<path d=\"%@\" />", data)
    }
}
