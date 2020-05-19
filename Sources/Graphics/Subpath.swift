import Foundation
import Swift2D

/// A collection of instructions that make a complete shape.
///
/// Subpaths should:
/// * Begin (first) with `Instruction.move`
/// * End (last) with `Instruction.close`
public typealias Subpath = [Instruction]

#if canImport(CoreGraphics)
import CoreGraphics

public extension Subpath {
    func cgPath(originalSize: Size, outputSize: Size) -> CGPath {
        let path = CGMutablePath()
        forEach { (instruction) in
            path.addInstruction(instruction, originalSize: originalSize, outputSize: outputSize)
        }
        return path
    }
}

#endif
