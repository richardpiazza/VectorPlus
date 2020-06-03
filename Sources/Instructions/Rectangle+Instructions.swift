import Foundation
import SwiftSVG

public extension Rectangle {
    convenience init(instructions: [Instruction]) throws {
        self.init()
        instructions.forEach { (instruction) in
            if case let .rectangle(x, y, width, height, rx, ry) = instruction {
                self.x = x
                self.y = y
                self.width = width
                self.height = height
                self.rx = rx
                self.ry = ry
                return
            }
        }
        
        throw CocoaError(.formatting)
    }
}

// MARK: - InstructionRepresentable
extension Rectangle: InstructionRepresentable {
    public func instructions() throws -> [Instruction] {
        return [
            .move(x: x, y: y),
            .rectangle(x: x, y: y, w: width, h: height, rx: rx, ry: ry),
            .close
        ]
    }
}

// MARK: - PathRepresentable
extension Rectangle: PathRepresentable {
}
