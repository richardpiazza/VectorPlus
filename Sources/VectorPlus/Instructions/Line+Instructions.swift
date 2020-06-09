import Foundation
import SwiftSVG

public extension Line {
    
}

// MARK: - InstructionRepresentable
extension Line: InstructionRepresentable {
    public func instructions(clockwise: Bool) throws -> [Instruction] {
        return [
        .move(x: x1, y: y1),
        .line(x: x2, y: y2),
        .line(x: x1, y: y1),
        .close
        ]
    }
}

extension Line: PathRepresentable {
}
