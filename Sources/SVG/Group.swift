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
    
    public var transformations: [Transformation] {
        let value = transform?.replacingOccurrences(of: " ", with: "") ?? ""
        guard !value.isEmpty else {
            return []
        }
        
        let values = value.split(separator: ")").map({ $0.appending(")") })
        return values.compactMap({ Transformation($0) })
    }
}

// MARK: - CustomStringConvertible
extension Group: CustomStringConvertible {
    public var description: String {
        var contents: String = ""
        let circles = self.circles?.compactMap({ $0.description }) ?? []
        circles.forEach({ contents.append("\n\($0)") })
        
        let rectangles = self.rectangles?.compactMap({ $0.description }) ?? []
        rectangles.forEach({ contents.append("\n\($0)") })
        
        let polygons = self.polygons?.compactMap({ $0.description }) ?? []
        polygons.forEach({ contents.append("\n\($0)") })
        
        let paths = self.paths?.compactMap({ $0.description }) ?? []
        paths.forEach({ contents.append("\n\($0)") })
        
        let groups = self.groups?.compactMap({ $0.description }) ?? []
        groups.forEach({ contents.append("\n\($0)") })
        
        return String(format: "<g id=\"%@\" transform=\"%@\">%@\n</g>", id ?? "", transform ?? "", contents)
    }
}

// MARK: - SubpathRepresentable
extension Group: SubpathRepresentable {
    public func subpaths() throws -> [Subpath] {
        var output: [Subpath] = []
        
        if let circles = self.circles {
            try circles.forEach({
                try output.append(contentsOf: $0.subpaths(applying: transformations))
            })
        }
        
        if let rectangles = self.rectangles {
            try rectangles.forEach({
                try output.append(contentsOf: $0.subpaths(applying: transformations))
            })
        }
        
        if let polygons = self.polygons {
            try polygons.forEach({
                try output.append(contentsOf: $0.subpaths(applying: transformations))
            })
        }
        
        if let paths = self.paths {
            try paths.forEach({
                try output.append(contentsOf: $0.subpaths(applying: transformations))
            })
        }
        
        if let groups = self.groups {
            try groups.forEach({
                try output.append(contentsOf: $0.subpaths(applying: transformations))
            })
        }
        
        return output
    }
}
