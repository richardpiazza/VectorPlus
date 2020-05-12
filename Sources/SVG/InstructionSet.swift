import Foundation

/// A paired collection of instructions.
///
/// This set can be used by `UIBezierPath` to draw one path (_include_) and subtract a portion of the path (_exclude_)
///
public typealias InstructionSet = (include: [Instruction], exclude: [Instruction])
