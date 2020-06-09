import Foundation
import SwiftSVG

public extension Circle {
    @available(*, deprecated)
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
    /// The _optimal_ offset for control points when representing a
    /// circle as 4 bezier curves.
    ///
    /// [Stack Overflow](https://stackoverflow.com/questions/1734745/how-to-create-circle-with-bézier-curves)
    public var controlPointOffset: Float {
        return (Float(4.0/3.0) * tan(Float.pi / 8.0)) * r
    }
    
    public func instructions(clockwise: Bool) throws -> [Instruction] {
        var instructions: [Instruction] = []
        
        let offset = controlPointOffset
        
        let zero = (x + r, y)
        let ninety = (x, y - r)
        let oneEighty = (x - r, y)
        let twoSeventy = (x, y + r)
        
        var cp1 = (Float(0.0), Float(0.0))
        var cp2 = (Float(0.0), Float(0.0))
        
        // Starting at degree 0 (the right most point)
        instructions.append(.move(x: zero.0, y: zero.1))
        
        if clockwise {
            cp1 = (zero.0, zero.1 + offset)
            cp2 = (twoSeventy.0 + offset, twoSeventy.1)
            instructions.append(.bezierCurve(x: twoSeventy.0, y: twoSeventy.1, cx1: cp1.0, cy1: cp1.1, cx2: cp2.0, cy2: cp2.1))
            
            cp1 = (twoSeventy.0 - offset, twoSeventy.1)
            cp2 = (oneEighty.0, oneEighty.1 + offset)
            instructions.append(.bezierCurve(x: oneEighty.0, y: oneEighty.1, cx1: cp1.0, cy1: cp1.1, cx2: cp2.0, cy2: cp2.1))
            
            cp1 = (oneEighty.0, oneEighty.1 - offset)
            cp2 = (ninety.0 - offset, ninety.1)
            instructions.append(.bezierCurve(x: ninety.0, y: ninety.1, cx1: cp1.0, cy1: cp1.1, cx2: cp2.0, cy2: cp2.1))
            
            cp1 = (ninety.0 + offset, ninety.1)
            cp2 = (zero.0, zero.1 - offset)
            instructions.append(.bezierCurve(x: zero.0, y: zero.1, cx1: cp1.0, cy1: cp1.1, cx2: cp2.0, cy2: cp2.1))
        } else {
            cp1 = (zero.0, zero.1 - offset)
            cp2 = (ninety.0 + offset, ninety.1)
            instructions.append(.bezierCurve(x: ninety.0, y: ninety.1, cx1: cp1.0, cy1: cp1.1, cx2: cp2.0, cy2: cp2.1))
            
            cp1 = (ninety.0 - offset, ninety.1)
            cp2 = (oneEighty.0, oneEighty.1 - offset)
            instructions.append(.bezierCurve(x: oneEighty.0, y: oneEighty.1, cx1: cp1.0, cy1: cp1.1, cx2: cp2.0, cy2: cp2.1))
            
            cp1 = (oneEighty.0, oneEighty.1 + offset)
            cp2 = (twoSeventy.0 - offset, twoSeventy.1)
            instructions.append(.bezierCurve(x: twoSeventy.0, y: twoSeventy.1, cx1: cp1.0, cy1: cp1.1, cx2: cp2.0, cy2: cp2.1))
            
            cp1 = (twoSeventy.0 + offset, twoSeventy.1)
            cp2 = (zero.0, zero.1 + offset)
            instructions.append(.bezierCurve(x: zero.0, y: zero.1, cx1: cp1.0, cy1: cp1.1, cx2: cp2.0, cy2: cp2.1))
        }
        
        instructions.append(.close)
        
        return instructions
    }
}

// MARK: - PathRepresentable
extension Circle: PathRepresentable {
}
