import Foundation
import XMLCoder

/// A container used to group other SVG elements.
///
/// Grouping constructs, when used in conjunction with the ‘desc’ and ‘title’ elements, provide information
/// about document structure and semantics.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/g)
/// | [W3](https://www.w3.org/TR/SVG11/struct.html#Groups)
public struct Group: Codable, CoreAttributes, PresentationAttributes, StylingAttributes {
    
    public var circles: [Circle]?
    public var groups: [Group]?
    public var lines: [Line]?
    public var paths: [Path]?
    public var polygons: [Polygon]?
    public var polylines: [Polyline]?
    public var rectangles: [Rectangle]?
    public var texts: [Text]?
    
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
        case circles = "circle"
        case groups = "g"
        case lines = "line"
        case paths = "path"
        case polylines = "polyline"
        case polygons = "polygon"
        case rectangles = "rect"
        case texts = "text"
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
}

// MARK: - CustomStringConvertible
extension Group: CustomStringConvertible {
    public var description: String {
        var contents: String = ""
        
        let circles = self.circles?.compactMap({ $0.description }) ?? []
        circles.forEach({ contents.append("\n\($0)") })
        
        let groups = self.groups?.compactMap({ $0.description }) ?? []
        groups.forEach({ contents.append("\n\($0)") })
        
        let lines = self.lines?.compactMap({ $0.description }) ?? []
        lines.forEach({ contents.append("\n\($0)") })
        
        let paths = self.paths?.compactMap({ $0.description }) ?? []
        paths.forEach({ contents.append("\n\($0)") })
        
        let polylines = self.polylines?.compactMap({ $0.description }) ?? []
        polylines.forEach({ contents.append("\n\($0)") })
        
        let polygons = self.polygons?.compactMap({ $0.description }) ?? []
        polygons.forEach({ contents.append("\n\($0)") })
        
        let rectangles = self.rectangles?.compactMap({ $0.description }) ?? []
        rectangles.forEach({ contents.append("\n\($0)") })
        
        let texts = self.texts?.compactMap({ $0.description }) ?? []
        texts.forEach({ contents.append("\n\($0)") })
        
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
        
        return "<g " + components.joined(separator: " ") + ">\(contents)\n</g>"
    }
}

// MARK: - DynamicNodeEncoding
extension Group: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let codingKey = key as? CodingKeys else {
            return .attribute
        }
        
        switch codingKey {
        case .circles, .groups, .lines, .paths, .polylines, .polygons, .rectangles, .texts:
            return .element
        default:
            return .attribute
        }
    }
}

// MARK: - DynamicNodeDecoding
extension Group: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        guard let codingKey = key as? CodingKeys else {
            return .attribute
        }
        
        switch codingKey {
        case .circles, .groups, .lines, .paths, .polylines, .polygons, .rectangles, .texts:
            return .element
        default:
            return .attribute
        }
    }
}
