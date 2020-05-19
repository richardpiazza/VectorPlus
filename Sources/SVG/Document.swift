import Foundation
import XMLCoder
import Core

/// SVG is a language for describing two-dimensional graphics in XML.
///
/// [https://www.w3.org/TR/SVG11/](https://www.w3.org/TR/SVG11/)
public struct Document: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
    
    public var viewBox: String?
    public var width: String?
    public var height: String?
    public var title: String?
    public var description: String?
    public var groups: [Group]?
    public var paths: [Path]?
    
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case viewBox
        case title
        case description = "desc"
        case groups = "g"
        case paths = "path"
    }
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case CodingKeys.width, CodingKeys.height, CodingKeys.viewBox:
            return .attribute
        default:
            return .element
        }
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.width, CodingKeys.height, CodingKeys.viewBox:
            return .attribute
        default:
            return .element
        }
    }
    
    public static func make(from url: URL) throws -> Document {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw CocoaError(.fileNoSuchFile)
        }
        
        let data = try Data(contentsOf: url)
        return try make(with: data)
    }
    
    public static func make(with data: Data, decoder: XMLDecoder = XMLDecoder()) throws -> Document {
        return try decoder.decode(Document.self, from: data)
    }
    
    public init() {
    }
    
    public init(width: Int, height: Int) {
        self.width = "\(width)px"
        self.height = "\(height)px"
        viewBox = "0 0 \(width) \(height)"
    }
}

public extension Document {
    var name: String {
        let name = title ?? "SVG Document"
        let newTitle = name.components(separatedBy: .punctuationCharacters).joined(separator: "_")
        return newTitle.replacingOccurrences(of: " ", with: "_")
    }
    
    /// Original size of the document image.
    ///
    /// Primarily uses the `viewBox` attribute, and will fallback to the 'pixelSize'
    var originalSize: Size {
        return (viewBoxSize ?? pixelSize) ?? .zero
    }
    
    /// Size of the design in a square 'viewBox'.
    ///
    /// All paths created by this framework are outputed in a 'square'.
    var outputSize: Size {
        let size = originalSize
        let maxDimension = max(size.width, size.height)
        return Size(width: maxDimension, height: maxDimension)
    }
}

// MARK: - SubpathRepresentable
extension Document: SubpathRepresentable {
    public func subpaths() throws -> [Subpath] {
        var output: [Subpath] = []
        
        if let paths = self.paths {
            try paths.forEach({
                try output.append(contentsOf: $0.subpaths())
            })
        }
        
        if let groups = self.groups {
            try groups.forEach({
                try output.append(contentsOf: $0.subpaths())
            })
        }
        
        return output
    }
}

// MARK: - Private
private extension Document {
    /// Size derived from the 'viewbox' document attribute
    var viewBoxSize: Size? {
        guard let viewBox = self.viewBox else {
            return nil
        }
        
        let components = viewBox.components(separatedBy: .whitespaces)
        guard components.count == 4 else {
            return nil
        }
        
        guard let width = Int(components[2]) else {
            return nil
        }
        
        guard let height = Int(components[3]) else {
            return nil
        }
        
        return Size(width: width, height: height)
    }
    
    /// Size derived from the 'width' & 'height' document attributes
    var pixelSize: Size? {
        guard let width = self.width, !width.isEmpty else {
            return nil
        }
        
        guard let height = self.height, !height.isEmpty else {
            return nil
        }
        
        let widthRawValue = width.replacingOccurrences(of: "px", with: "", options: .caseInsensitive, range: nil)
        let heightRawValue = height.replacingOccurrences(of: "px", with: "", options: .caseInsensitive, range: nil)
        
        guard let w = Int(widthRawValue), let h = Int(heightRawValue) else {
            return nil
        }
        
        return Size(width: w, height: h)
    }
}
