import Foundation
import Swift2D

public extension Document {
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
