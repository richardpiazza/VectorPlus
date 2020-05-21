import Foundation

public protocol InstructionSetRepresentable {
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
    func instructionSets() throws -> [InstructionSet]
}

public extension InstructionSetRepresentable {
    func instructionSets(applying transformations: [Transformation]) throws -> [InstructionSet] {
        var output: [InstructionSet] = []
        
        let subpaths = try self.instructionSets()
        
        subpaths.forEach { (subpath) in
            var set = InstructionSet()
            subpath.forEach { (instruction) in
                set.append(instruction.applying(transformations: transformations))
            }
            output.append(set)
        }
        
        return output
    }
}
