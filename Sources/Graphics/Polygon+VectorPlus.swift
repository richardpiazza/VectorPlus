import Foundation
import SVG

public extension SVG.Polygon {
    convenience init(instructions: [Instruction]) {
        self.init()
        let pointsData = instructions.compactMap({ $0.polygonPoints })
        points = pointsData.joined(separator: " ")
    }
}

// MARK: - InstructionRepresentable
extension SVG.Polygon: InstructionRepresentable {
    public func instructions() throws -> [Instruction] {
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
                guard let modified = try? instructions.last?.adjusting(relativeValue: value, at: 1) else {
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

// MARK: - SubpathRepresentable
extension SVG.Polygon: SubpathRepresentable {
}
