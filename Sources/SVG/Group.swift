import Foundation
import XMLCoder

/// A container element for grouping together related graphics elements
///
/// A group of elements, as well as individual objects, can be given a name using the ‘id’ attribute.
///
/// [https://www.w3.org/TR/SVG11/struct.html#Groups](https://www.w3.org/TR/SVG11/struct.html#Groups)
public class Group: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
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

public extension Group {
    var transformation: Transformation? {
        guard let value = transform, !value.isEmpty else {
            return nil
        }
        
        return Transformation(value)
    }
    
    func asSubpaths(applying transformations: [Transformation]? = nil) throws -> [[Instruction]] {
        var output: [[Instruction]] = []
        
        var transforms = transformations ?? []
        if let transformation = self.transformation {
            transforms.append(transformation)
        }
        
        if let circles = self.circles {
            for circle in circles {
                let instructions = circle.asInstructions(using: transforms)
                output.append(instructions)
            }
        }
        
        if let rectangles = self.rectangles {
            for rectangle in rectangles {
                let instructions = rectangle.asInstructions(using: transforms)
                output.append(instructions)
            }
        }
        
        var allPaths = paths ?? []
        
        if let polygons = self.polygons {
            let paths = polygons.map({ $0.asPath() })
            allPaths.append(contentsOf: paths)
        }
        
        try allPaths.forEach { (path) in
            let subpath = try path.asSubpaths(applying: transforms)
            output.append(contentsOf: subpath)
        }
        
        if let groups = self.groups {
            try groups.forEach { (group) in
                let subpaths = try group.asSubpaths(applying: transforms)
                output.append(contentsOf: subpaths)
            }
        }
        
        return output
    }
}
