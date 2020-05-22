import Foundation
import SVG

public protocol InstructionRepresentable {
    func instructions() throws ->  [Instruction]
}

// MARK: - InstructionSetRepresentable
public extension InstructionRepresentable {
    func instructionSets() throws -> [InstructionSet] {
        let instructions = try self.instructions()
        
        guard instructions.count > 0 else {
            return []
        }
        
        guard case .move = instructions.first else {
            throw Instruction.Error.invalidInstructionIndex
        }
        
        var subpaths: [[Instruction]] = []
        var index: Int = -1
        
        for instruction in instructions {
            switch instruction {
            case .move:
                subpaths.append([])
                index += 1
                fallthrough
            default:
                subpaths[index].append(instruction)
            }
        }
        
        return subpaths
    }
    
    func asPath() throws -> Path {
        var path = Path(instructions: try instructions())
        if let attributes = self as? PresentationAttributes {
            path.fill = attributes.fill
            path.fillOpacity = attributes.fillOpacity
            path.stroke = attributes.stroke
            path.strokeWidth = attributes.strokeWidth
            path.strokeOpacity = attributes.strokeOpacity
            path.transform = attributes.transform
        }
        return path
    }
}
