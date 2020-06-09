import Foundation
import SwiftSVG

public extension Polyline {
}

// MARK: - InstructionRepresentable
extension Polyline: InstructionRepresentable {
    public func instructions(clockwise: Bool) throws -> [Instruction] {
        let pairs = points.components(separatedBy: " ")
        let components = pairs.flatMap({ $0.components(separatedBy: ",") })
        let values = components.compactMap({ Float($0) })
        
        guard values.count > 2 else {
            // More than just a starting point is required.
            return []
        }
        
        guard values.count % 2 == 0 else {
            // An odd number of components means that parsing probably failed
            return []
        }
        
        var instructions: [Instruction] = []
        
        let move = values.prefix(upTo: 2)
        let segments = values.suffix(from: 2)
        
        instructions.append(.move(x: move[0], y: move[1]))
        
        var _value: Float = .nan
        segments.forEach { (value) in
            if _value.isNaN {
                _value = value
            } else {
                instructions.append(.line(x: _value, y: value))
                _value = .nan
            }
        }
        
        let reversedSegments = segments.dropLast(2).reversed()
        reversedSegments.forEach { (value) in
            if _value.isNaN {
                _value = value
            } else {
                instructions.append(.line(x: _value, y: value))
                _value = .nan
            }
        }
        
        instructions.append(.close)
        
        return instructions
    }
}

// MARK: - PathRepresentable
extension Polyline: PathRepresentable {
}
