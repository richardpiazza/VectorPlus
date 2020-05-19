import Foundation

/// A [Transform](https://www.w3.org/TR/SVG11/coords.html#TransformAttribute) is a modification that should be
/// applied to a path or instruction. 
///
/// If a list of transforms is provided, then the net effect is as if each transform had been specified separately in the order provided.
///
/// For example,
/// ```
/// <g transform="translate(-10,-20) scale(2) rotate(45) translate(5,10)">
///   <!-- graphics elements go here -->
/// </g>
/// ```
/// is functionally equivalent to:
/// ```
/// <g transform="translate(-10,-20)">
///   <g transform="scale(2)">
///     <g transform="rotate(45)">
///       <g transform="translate(5,10)">
///         <!-- graphics elements go here -->
///       </g>
///     </g>
///   </g>
/// </g>
/// ```
///
/// The ‘transform’ attribute is applied to an element before processing any other coordinate or length values supplied for that element.
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
