import Foundation

/// A modification that should be applied to a path or command.
///
/// [https://www.w3.org/TR/SVG11/coords.html#TransformAttribute](https://www.w3.org/TR/SVG11/coords.html#TransformAttribute)
public enum Transformation {
    /// Specifies a 'translation' (offset)
    ///
    /// [https://www.w3.org/TR/SVG11/coords.html#TranslationDefined](https://www.w3.org/TR/SVG11/coords.html#TranslationDefined)
    case translate(x: Float, y: Float)
    
    public enum Prefix: String, CaseIterable {
        case translate
    }
    
    /// Initializes a new `Transformation` with a raw SVG transformation string.
    public init?(_ string: String) {
        var prefix: Prefix? = nil
        for p in Prefix.allCases {
            if string.lowercased().hasPrefix(p.rawValue) {
                prefix = p
                break
            }
        }
        
        guard let transformationPrefix = prefix else {
            return nil
        }
        
        switch transformationPrefix {
        case .translate:
            guard let start = string.firstIndex(of: "(") else {
                return nil
            }
            
            guard let stop = string.lastIndex(of: ")") else {
                return nil
            }
            
            var components = String(string[start...stop])
            components = components.replacingOccurrences(of: "(", with: "")
            components = components.replacingOccurrences(of: ")", with: "")
            
            let values = components.components(separatedBy: ",")
            guard values.count > 1 else {
                return nil
            }
            
            let x = Float(values[0].trimmingCharacters(in: .whitespaces)) ?? 0.0
            let y = Float(values[1].trimmingCharacters(in: .whitespaces)) ?? 0.0
            
            self = .translate(x: x, y: y)
            return
        }
    }
}
