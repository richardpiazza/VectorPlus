import Foundation
import SVG
import Graphics

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
    
    func asInstructionSet() throws -> InstructionSet {
        var instructionSet = InstructionSet([], [])
        
        let transformations: [Transformation] = []
        
        if let groups = self.groups {
            for group in groups {
                let set = try group.asInstructionSet(using: transformations)
                instructionSet.include.append(contentsOf: set.include)
                instructionSet.exclude.append(contentsOf: set.exclude)
            }
        }
        
        if let paths = self.paths {
            let pathInstructionSets = try paths.asInstructionSet(using: transformations)
            instructionSet.include.append(contentsOf: pathInstructionSets.include)
            instructionSet.exclude.append(contentsOf: pathInstructionSets.exclude)
        }
        
        return instructionSet
    }
}

private extension Document {
    func asFileTemplate() throws -> String {
        let instructions = try asTemplateInstructions()
        
        return fileTemplate
            .replacingOccurrences(of: "{{name}}", with: name)
            .replacingOccurrences(of: "{{instructions}}", with: instructions.included)
            .replacingOccurrences(of: "{{exclusion_instructions}}", with: instructions.excluded)
    }
    
    func asImageViewSubclass() throws -> String {
        let instructions = try asTemplateInstructions()
        
        return imageViewSubclassTemplate
            .replacingOccurrences(of: "{{name}}", with: name)
            .replacingOccurrences(of: "{{width}}", with: String(format: "%.1f", originalSize.width))
            .replacingOccurrences(of: "{{height}}", with: String(format: "%.1f", originalSize.height))
            .replacingOccurrences(of: "{{instructions}}", with: instructions.included)
            .replacingOccurrences(of: "{{exclusion_instructions}}", with: instructions.excluded)
    }
    
    func asTemplateInstructions() throws -> (included: String, excluded: String) {
        let instructionSet = try asInstructionSet()
        
        let included = instructionSet.include.map { (vectorInstruction) -> String in
            let cgMethod = vectorInstruction.coreGraphicsDescription(originalSize: originalSize)
            return String(format: "includedPath%@", cgMethod)
        }
        
        let excluded = instructionSet.exclude.map { (vectorInstruction) -> String in
            let cgMethod = vectorInstruction.coreGraphicsDescription(originalSize: originalSize)
            return String(format: "excludedPath%@", cgMethod)
        }
        
        let includedMerged = included.joined(separator: "\n        ")
        let excludedMerged = excluded.joined(separator: "\n        ")
        
        return (includedMerged, excludedMerged)
    }
}
