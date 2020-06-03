import Foundation
import SwiftSVG

public extension Circle {
    convenience init(instructions: [Instruction]) throws {
        self.init()
        
        instructions.forEach { (instruction) in
            if case let .circle(x, y, r) = instruction {
                self.x = x
                self.y = y
                self.r = r
                return
            }
        }
        
        throw CocoaError(.formatting)
    }
}

// MARK: - InstructionRepresentable
extension Circle: InstructionRepresentable {
    public func instructions() throws -> [Instruction] {
        return [
            .move(x: x, y: y),
            .circle(x: x, y: y, r: r),
            .close
        ]
    }
}

// MARK: - PathRepresentable
extension Circle: PathRepresentable {
}
