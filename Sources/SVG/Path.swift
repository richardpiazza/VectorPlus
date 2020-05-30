import Foundation
import XMLCoder

/// Generic element to define a shape.
///
/// A path is defined by including a ‘path’ element in a SVG document which contains a **d="(path data)"**
/// attribute, where the **‘d’** attribute contains the moveto, line, curve (both cubic and quadratic Béziers),
/// arc and closepath instructions.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/path)
/// | [W3](https://www.w3.org/TR/SVG11/paths.html)
public struct Path: Codable, CoreAttributes, PresentationAttributes, StylingAttributes {
    
    /// The definition of the outline of a shape.
    public var data: String = ""
    
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
        case data = "d"
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
    
    public init(data: String) {
        self.data = data
    }
}

// MARK: - CustomStringConvertible
extension Path: CustomStringConvertible {
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
        
        return "<path d=\"\(data)\" " + components.joined(separator: " ") + " />"
    }
}

// MARK: - DynamicNodeEncoding
extension Path: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Path: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}
