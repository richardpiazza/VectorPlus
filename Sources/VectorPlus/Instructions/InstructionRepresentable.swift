import Foundation
import SwiftSVG

public protocol InstructionRepresentable {
    /// Returns a representation of the data as a set of `Instruction`s.
    ///
    /// - parameter clockwise: For elements that support directionality, this indicates the direction in which
    ///                        the resulting instructions will be drawn.
    func instructions(clockwise: Bool) throws -> [Instruction]
}

public extension InstructionRepresentable {
    /// Defaults to anti/counter clockwise instruction set (where applicable).
    func instructions() throws -> [Instruction] {
        return try instructions(clockwise: false)
    }
}

// MARK: - InstructionSetRepresentable
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
