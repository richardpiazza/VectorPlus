import Foundation

public protocol InstructionRepresentable {
    func instructions() throws ->  [Instruction]
}

// MARK: - SubpathRepresentable
public extension InstructionRepresentable {
    func instructionSets() throws -> [InstructionSet] {
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
