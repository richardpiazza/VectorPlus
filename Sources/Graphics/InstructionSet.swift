import Foundation
import Swift2D

/// A collection of instructions that make a complete shape.
///
/// InstructionSets should:
/// * Begin (first) with `Instruction.move`
/// * End (last) with `Instruction.close`
public typealias InstructionSet = [Instruction]
