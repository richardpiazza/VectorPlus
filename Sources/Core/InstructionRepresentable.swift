import Foundation

public protocol InstructionRepresentable {
    var instructions: [Instruction] { get }
}

public extension InstructionRepresentable {
    /// All instructions regrouped as individual subpaths
    ///
    /// A 'set' of instructions is determined using the following:
    /// * a `.move` instruction starts a subpath
    /// * a `.close` instruction terminates a subpath.
    ///
    /// If the first instruction encountered is not a `.move`, than an error is thrown.
    ///
    /// - returns: A collection of subpaths
    /// - throws: `Instruction.Error`
    func subpaths() throws -> [[Instruction]] {
        guard instructions.count > 0 else {
            return []
        }
        
        guard case .move = instructions.first else {
            throw Instruction.Error.invalidInstructionIndex
        }
        
        var subpaths: [[Instruction]] = []
        var index: Int = -1
        
        for instruction in instructions {

            switch instruction {
            case .move:
                subpaths.append([])
                index += 1
                fallthrough
            default:
                subpaths[index].append(instruction)
            }
        }
        
        guard let transformable = self as? TransformationRepresentable else {
            return subpaths
        }
        
        var transformedSubpaths: [[Instruction]] = []
        
        for subpath in subpaths {
            var path = [Instruction]()
            subpath.forEach { (instruction) in
                path.append(instruction.applying(transformations: transformable.transformations))
            }
            transformedSubpaths.append(path)
        }
        
        return transformedSubpaths
    }
    
    
    func subpaths(applying transformations: [Transformation]) throws -> [[Instruction]] {
        var output: [[Instruction]] = []
        
        var transforms = transformations
        if let transformable = self as? TransformationRepresentable {
            transforms.append(contentsOf: transformable.transformations)
        }
        
        let subpaths = try self.subpaths()
        subpaths.forEach { (subpath) in
            var set = [Instruction]()
            subpath.forEach { (instruction) in
                set.append(instruction.applying(transformations: transformations))
            }
            output.append(set)
        }
        
        return output
    }
}
