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
        // TODO: If rx is greater than half of ‘width’, then set rx to half of ‘width’.
        // TODO: If ry is greater than half of ‘height’, then set ry to half of ‘height’.
        
        var instructions: [Instruction] = []
        
        switch (rx, ry) {
        case (.some(let radiusX), .some(let radiusY)) where radiusX != radiusY:
            // use Cubic Bezier to form rounded rects
            // TODO: The Control Points Are Wrong
            instructions.append(.move(x: x + radiusX, y: y))
            instructions.append(.line(x: (x + width) - radiusX, y: y - radiusY))
            instructions.append(.bezierCurve(x: x + width, y: y + radiusY, cx1: x + width, cy1: y, cx2: x + width, cy2: y))
            instructions.append(.line(x: x + width, y: y + height - radiusY))
            instructions.append(.bezierCurve(x: x + width - radiusX, y: y + height, cx1: x + width, cy1: y + height, cx2: x + width, cy2: y + height))
            instructions.append(.line(x: x + radiusX, y: y + height))
            instructions.append(.bezierCurve(x: x, y: y + height - radiusY, cx1: x, cy1: y + height, cx2: x, cy2: y + height))
            instructions.append(.line(x: x, y: y + radiusY))
            instructions.append(.bezierCurve(x: x + radiusX, y: y, cx1: x, cy1: y, cx2: x, cy2: y))
            instructions.append(.close)
        case (.some(let radius), .none), (.none, .some(let radius)), (.some(let radius), _):
            // use Quadratic to form rounded rects
            instructions.append(.move(x: x + radius, y: y))
            instructions.append(.line(x: (x + width) - radius, y: y))
            instructions.append(.quadraticCurve(x: x + width, y: y + radius, cx: x + width, cy: y))
            instructions.append(.line(x: x + width, y: (y + height) - radius))
            instructions.append(.quadraticCurve(x: x + width - radius, y: y + height, cx: x + width, cy: y + height))
            instructions.append(.line(x: x + radius, y: y + height))
            instructions.append(.quadraticCurve(x: x, y: y + height - radius, cx: x, cy: y + height))
            instructions.append(.line(x: x, y: y + radius))
            instructions.append(.quadraticCurve(x: x + radius, y: y, cx: x, cy: y))
            instructions.append(.close)
        case (.none, .none):
            // draw three line segments.
            instructions.append(.move(x: x, y: y))
            instructions.append(.line(x: x + width, y: y))
            instructions.append(.line(x: x + width, y: y + height))
            instructions.append(.line(x: x, y: y + height))
            instructions.append(.close)
        }
        
        return instructions
    }
}

// MARK: - PathRepresentable
extension Rectangle: PathRepresentable {
}
