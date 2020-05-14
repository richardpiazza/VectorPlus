import Foundation
import XMLCoder
import Core

/// A container element for grouping ([g](https://www.w3.org/TR/SVG11/struct.html#Groups)).
///
/// Grouping constructs, when used in conjunction with the ‘desc’ and ‘title’ elements, provide information
/// about document structure and semantics.
public struct Group: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
    
    /// Name of the element
    public var id: String?
    public var transform: String?
    public var groups: [Group]?
    public var paths: [Path]?
    public var polygons: [Polygon]?
    public var circles: [Circle]?
    public var rectangles: [Rectangle]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case transform
        case groups = "g"
        case paths = "path"
        case polygons = "polygon"
        case circles = "circle"
        case rectangles = "rect"
    }
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case CodingKeys.id, CodingKeys.transform:
            return .attribute
        default:
            return .element
        }
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.id, CodingKeys.transform:
            return .attribute
        default:
            return .element
        }
    }
    
    public init() {
    }
}

// MARK: - Transformable
extension Group: Transformable {
    public var transformations: [Transformation] {
        guard let value = transform, !value.isEmpty else {
            return []
        }
        
        let transforms = value.components(separatedBy: " ")
        return transforms.compactMap({ Transformation($0) })
    }
}

// MARK: - InstructionRepresentable
extension Group: InstructionRepresentable {
    public var instructions: [Instruction] {
        var output: [Instruction] = []
        
        if let circles = self.circles {
            circles.forEach { (circle) in
                output.append(contentsOf: circle.instructions)
            }
        }
        
        if let rectangles = self.rectangles {
            rectangles.forEach { (rectangle) in
                output.append(contentsOf: rectangle.instructions)
            }
        }
        
        if let polygons = self.polygons {
            polygons.forEach { (polygon) in
                output.append(contentsOf: polygon.instructions)
            }
        }
        
        if let paths = self.paths {
            paths.forEach { (path) in
                output.append(contentsOf: path.instructions)
            }
        }
        
        if let groups = self.groups {
            groups.forEach { (group) in
                output.append(contentsOf: group.instructions)
            }
        }
        
        return output
    }
}
