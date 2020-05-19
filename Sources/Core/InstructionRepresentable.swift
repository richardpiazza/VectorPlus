import Foundation

public protocol InstructionRepresentable {
    func instructions() throws ->  [Instruction]
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
    func subpaths() throws -> [Subpath] {
        let instructions = try self.instructions()
        
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
        
        return subpaths
    }
}
