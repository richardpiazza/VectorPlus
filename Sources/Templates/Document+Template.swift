import Foundation
import SVG
import Graphics

public extension Document {
    enum Output: String, Decodable, CaseIterable {
        case `struct`
        case uiimageview
        case png
        case preview
    }
}

public extension Document {
    func asFileTemplate() throws -> String {
        let instructions = try asCoreGraphicsDescription()
        
        return fileTemplate
            .replacingOccurrences(of: "{{name}}", with: name)
            .replacingOccurrences(of: "{{instructions}}", with: instructions)
    }
    
    func asImageViewSubclass() throws -> String {
        let instructions = try asCoreGraphicsDescription()
        
        return imageViewSubclassTemplate
            .replacingOccurrences(of: "{{name}}", with: name)
            .replacingOccurrences(of: "{{width}}", with: String(format: "%.1f", originalSize.width))
            .replacingOccurrences(of: "{{height}}", with: String(format: "%.1f", originalSize.height))
            .replacingOccurrences(of: "{{instructions}}", with: instructions)
    }
    
    ///
    func asCoreGraphicsDescription(variableName: String = "path") throws -> String {
        var outputs: [String] = []
        
        let paths = try allPaths()
        paths.forEach { (p) in
            let instructions = (try? p.instructions()) ?? []
            instructions.forEach { (i) in
                let method = i.coreGraphicsDescription(originalSize: originalSize)
                let code = String(format: "%@%@", variableName, method)
                outputs.append(code)
            }
        }
        
        return outputs.joined(separator: "\n        ")
    }
}
