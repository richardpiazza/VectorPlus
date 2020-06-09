import Foundation
import SwiftSVG

public extension SwiftSVG.Polygon {
    convenience init(instructions: [Instruction]) {
        self.init()
        let pointsData = instructions.compactMap({ $0.polygonPoints })
        points = pointsData.joined(separator: " ")
    }
}

// MARK: - InstructionRepresentable
extension SwiftSVG.Polygon: InstructionRepresentable {
    public func instructions(clockwise: Bool) throws -> [Instruction] {
        let pairs = points.components(separatedBy: " ")
        let components = pairs.flatMap({ $0.components(separatedBy: ",") })
        guard components.count > 0 else {
            return []
        }
        
        guard components.count % 2 == 0 else {
            // An odd number of components means that parsing probably failed
            return []
        }
        
        var instructions: [Instruction] = []
        
        var firstValue: Bool = true
        for (idx, component) in components.enumerated() {
            guard let value = Float(component) else {
                return instructions
            }
            
            if firstValue {
                if idx == 0 {
                    instructions.append(.move(x: value, y: .nan))
                } else {
                    instructions.append(.line(x: value, y: .nan))
                }
                firstValue = false
            } else {
                let count = instructions.count
                guard let modified = try? instructions.last?.adjustingArgument(at: 1, by: value) else {
                    return instructions
                }
                
                instructions[count - 1] = modified
                firstValue = true
            }
        }
        
        instructions.append(.close)
        
        return instructions
    }
}

// MARK: - PathRepresentable
extension SwiftSVG.Polygon: PathRepresentable {
}
