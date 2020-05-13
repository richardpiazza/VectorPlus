import Foundation
import SVG

public extension Document {
    enum Template: String, Decodable, CaseIterable {
        case `struct`
        case uiimageview
    }
    
    func asTemplate(_ template: Template) throws -> String {
        switch template {
        case .struct:
            return try asFileTemplate()
        case .uiimageview:
            return try asImageViewSubclass()
        }
    }
    
    func asSubpaths() throws -> [[Instruction]] {
        var output: [[Instruction]] = []
        
        if let groups = self.groups {
            try groups.forEach { (group) in
                let subpaths = try group.asSubpaths()
                output.append(contentsOf: subpaths)
            }
        }
        
        if let paths = self.paths {
            try paths.forEach({ (path) in
                let subpaths = try path.asSubpaths()
                output.append(contentsOf: subpaths)
            })
        }
        
        return output
    }
}

private extension Document {
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
        
        let subpaths = try asSubpaths()
        
        subpaths.forEach { (path) in
            path.forEach { (instruction) in
                let method = instruction.coreGraphicsDescription(originalSize: originalSize)
                let code = String(format: "%@%@", variableName, method)
                outputs.append(code)
            }
        }
        
        return outputs.joined(separator: "\n        ")
    }
}
