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
}

public extension Group {
    func asInstructionSet(using transformations: [Transformation] = []) throws -> InstructionSet {
        var include: [Instruction] = []
        var exclude: [Instruction] = []
        
        var transforms = transformations
        if let transformation = self.transformation {
            transforms.append(transformation)
        }
        
        if let circles = self.circles {
            for circle in circles {
                let instructions = circle.asInstructions(using: transformations)
                include.append(contentsOf: instructions)
            }
        }
        
        if let rectangles = self.rectangles {
            for rectangle in rectangles {
                let instructions = rectangle.asInstructions(using: transformations)
                include.append(contentsOf: instructions)
            }
        }
        
        var allPaths = paths ?? []
        
        if let polygons = self.polygons {
            let paths = polygons.map({ $0.asPath() })
            allPaths.append(contentsOf: paths)
        }
        
        let pathInstructionSets = try allPaths.asInstructionSet(using: transforms)
        include.append(contentsOf: pathInstructionSets.include)
        exclude.append(contentsOf: pathInstructionSets.exclude)
        
        if let groups = self.groups {
            try groups.forEach({
                let instructionSet = try $0.asInstructionSet(using: transforms)
                
                include.append(contentsOf: instructionSet.include)
                exclude.append(contentsOf: instructionSet.exclude)
            })
        }
        
        return (include, exclude)
    }
}
