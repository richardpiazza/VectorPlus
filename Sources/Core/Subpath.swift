import Foundation

/// A collection of instructions that make a complete shape.
///
/// Subpaths should:
/// * Begin (first) with `Instruction.move`
/// * End (last) with `Instruction.close`
public typealias Subpath = [Instruction]
