import Foundation
import SVG
import Swift2D

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
    /// All paths created by this framework are outputted in a 'square'.
    var outputSize: Size {
        let size = originalSize
        let maxDimension = max(size.width, size.height)
        return Size(width: maxDimension, height: maxDimension)
    }
    
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

public extension Document {
    func allPaths() throws -> [Path] {
        var output: [Path] = []
        
        if let paths = self.paths {
            try output.append(contentsOf: paths.map({ try $0.asPath(applying: []) }))
        }
        
        if let groups = self.groups {
            try groups.forEach({
                try output.append(contentsOf: $0.allPaths(applying: []))
            })
        }
        
        return output
    }
}

#if canImport(CoreGraphics)
import CoreGraphics

public extension Document {
    func path(size: CGSize) -> CGPath {
        guard size.height > 0.0 && size.width > 0.0 else {
            return CGMutablePath()
        }
        
        guard let paths = try? allPaths() else {
            return CGMutablePath()
        }
        
        let from = Rect(origin: .zero, size: originalSize)
        let to = Rect(origin: .zero, size: size.size)
        
        let path = CGMutablePath()
        
        paths.forEach { (p) in
            let instructions = (try? p.instructions()) ?? []
            instructions.forEach { (i) in
                path.addInstruction(i, from: from, to: to)
            }
        }
        
        return path
    }
}
#endif
