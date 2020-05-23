import Foundation
import SVG
import Graphics
import Swift2D

public extension Document {
    func asImageViewSubclass() throws -> String {
        let instructions = try asCoreGraphicsDescription()
        let renders = try asCGContextDescription()
        
        return imageViewSubclassTemplate
            .replacingOccurrences(of: "{{name}}", with: name)
            .replacingOccurrences(of: "{{width}}", with: String(format: "%.1f", originalSize.width))
            .replacingOccurrences(of: "{{height}}", with: String(format: "%.1f", originalSize.height))
            .replacingOccurrences(of: "{{instructions}}", with: instructions)
            .replacingOccurrences(of: "{{render}}", with: renders)
    }
}

private extension Document {
    func asCoreGraphicsDescription(variable: String = "path") throws -> String {
        return try allPaths().map({ try $0.asCoreGraphicsDescription(variable: variable, originalSize: originalSize) }).joined(separator: "\n        ")
    }
    
    func asCGContextDescription() throws -> String {
        var outputs: [String] = []
        
        let paths = try allPaths()
        try paths.forEach { (path) in
            let instructions = try path.asCoreGraphicsDescription(variable: "path", originalSize: originalSize)
            let fillColor = path.fillColor?.coreGraphicsDescription ?? "nil"
            let fillOpacity = (path.fillOpacity != nil) ? "\(path.fillOpacity!)" : "nil"
            let strokeColor = path.strokeColor?.coreGraphicsDescription ?? "nil"
            let strokeOpacity = (path.strokeOpacity != nil) ? "\(path.strokeOpacity!)" : "nil"
            let strokeWidth = (path.strokeWidth != nil) ? "\(path.strokeWidth!) * (size.width / width)" : "nil"
            
            outputs.append(contextTemplate
                .replacingOccurrences(of: "{{instructions}}", with: instructions)
                .replacingOccurrences(of: "{{fillColor}}", with: fillColor)
                .replacingOccurrences(of: "{{fillOpacity}}", with: fillOpacity)
                .replacingOccurrences(of: "{{strokeColor}}", with: strokeColor)
                .replacingOccurrences(of: "{{strokeOpacity}}", with: strokeOpacity)
                .replacingOccurrences(of: "{{strokeWidth}}", with: strokeWidth)
            )
        }
        
        return outputs.joined(separator: "\n        ")
    }
}

extension Path {
    func asCoreGraphicsDescription(variable: String = "path", originalSize: Size) throws -> String {
        var outputs: [String] = []
        let instructions = (try? self.instructions()) ?? []
        instructions.forEach { (i) in
            let method = i.coreGraphicsDescription(originalSize: originalSize)
            let code = "\(variable)\(method)"
            outputs.append(code)
        }
        return outputs.joined(separator: "\n        ")
    }
}
