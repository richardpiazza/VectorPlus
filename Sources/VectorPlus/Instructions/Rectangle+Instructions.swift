import Foundation
import SwiftSVG

public extension Rectangle {
    @available(*, deprecated)
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
    public func instructions(clockwise: Bool) throws -> [Instruction] {
        // TODO: If rx is greater than half of ‘width’, then set rx to half of ‘width’.
        // TODO: If ry is greater than half of ‘height’, then set ry to half of ‘height’.
        
        var instructions: [Instruction] = []
        
        switch (rx, ry) {
        case (.some(let radiusX), .some(let radiusY)) where radiusX != radiusY:
            // use Bezier Curve to form rounded corners
            // TODO: Verify that the control points are right
            
            instructions.append(.move(x: x + radiusX, y: y))
            
            if clockwise {
                instructions.append(.line(x: (x + width) - radiusX, y: y))
                instructions.append(.bezierCurve(x: x + width, y: y + radiusY, cx1: x + width, cy1: y, cx2: x + width, cy2: y))
                instructions.append(.line(x: x + width, y: y + height - radiusY))
                instructions.append(.bezierCurve(x: x + width - radiusX, y: y + height, cx1: x + width, cy1: y + height, cx2: x + width, cy2: y + height))
                instructions.append(.line(x: x + radiusX, y: y + height))
                instructions.append(.bezierCurve(x: x, y: y + height - radiusY, cx1: x, cy1: y + height, cx2: x, cy2: y + height))
                instructions.append(.line(x: x, y: y + radiusY))
                instructions.append(.bezierCurve(x: x + radiusX, y: y, cx1: x, cy1: y, cx2: x, cy2: y))
            } else {
                instructions.append(.bezierCurve(x: x, y: y + radiusY, cx1: x, cy1: y, cx2: x, cy2: y))
                instructions.append(.line(x: x, y: y + height - radiusY))
                instructions.append(.bezierCurve(x: x + radiusY, y: y + height, cx1: x, cy1: y + height, cx2: x, cy2: y + height))
                instructions.append(.line(x: x + width - radiusX, y: y + height))
                instructions.append(.bezierCurve(x: x + width, y: y + height - radiusY, cx1: x + width, cy1: y + height, cx2: x + width, cy2: y + height))
                instructions.append(.line(x: x + width, y: y + radiusY))
                instructions.append(.bezierCurve(x: x + width - radiusX, y: y, cx1: x + width, cy1: y, cx2: x + width, cy2: y))
            }
        case (.some(let radius), .none), (.none, .some(let radius)), (.some(let radius), _):
            // use Quadratic Curve to form rounded corners
            
            instructions.append(.move(x: x + radius, y: y))
            
            if clockwise {
                instructions.append(.line(x: (x + width) - radius, y: y))
                instructions.append(.quadraticCurve(x: x + width, y: y + radius, cx: x + width, cy: y))
                instructions.append(.line(x: x + width, y: (y + height) - radius))
                instructions.append(.quadraticCurve(x: x + width - radius, y: y + height, cx: x + width, cy: y + height))
                instructions.append(.line(x: x + radius, y: y + height))
                instructions.append(.quadraticCurve(x: x, y: y + height - radius, cx: x, cy: y + height))
                instructions.append(.line(x: x, y: y + radius))
                instructions.append(.quadraticCurve(x: x + radius, y: y, cx: x, cy: y))
            } else {
                instructions.append(.quadraticCurve(x: x, y: y + radius, cx: x, cy: y))
                instructions.append(.line(x: x, y: y + radius))
                instructions.append(.quadraticCurve(x: x + radius, y: y, cx: x, cy: y + height))
                instructions.append(.line(x: x + width - radius, y: y + height))
                instructions.append(.quadraticCurve(x: x + width, y: y + height - radius, cx: x + width, cy: y + height))
                instructions.append(.line(x: x + width, y: y + radius))
                instructions.append(.quadraticCurve(x: x - radius, y: y, cx: x + width, cy: y))
            }
        case (.none, .none):
            // draw three line segments.
            instructions.append(.move(x: x, y: y))
            
            if clockwise {
                instructions.append(.line(x: x + width, y: y))
                instructions.append(.line(x: x + width, y: y + height))
                instructions.append(.line(x: x, y: y + height))
            } else {
                instructions.append(.line(x: x, y: y + height))
                instructions.append(.line(x: x + width, y: y + height))
                instructions.append(.line(x: x + width, y: y))
            }
        }
        
        instructions.append(.close)
        
        return instructions
    }
}

// MARK: - PathRepresentable
extension Rectangle: PathRepresentable {
}
