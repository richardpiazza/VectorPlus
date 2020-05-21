import Foundation
import Swift2D

/// A collection of instructions that make a complete shape.
///
/// InstructionSets should:
/// * Begin (first) with `Instruction.move`
/// * End (last) with `Instruction.close`
public typealias InstructionSet = [Instruction]

#if canImport(CoreGraphics)
import CoreGraphics

public extension InstructionSet {
    func cgPath(originalSize: Size, outputSize: Size) -> CGPath {
        let path = CGMutablePath()
        forEach { (instruction) in
            path.addInstruction(instruction, originalSize: originalSize, outputSize: outputSize)
        }
        return path
    }
}

#endif
