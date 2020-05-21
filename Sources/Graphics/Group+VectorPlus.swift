import Foundation
import SVG

// MARK: - SubpathRepresentable
extension Group: InstructionSetRepresentable {
    public func instructionSets() throws -> [InstructionSet] {
        var output: [InstructionSet] = []
        
        if let circles = self.circles {
            try circles.forEach({
                try output.append(contentsOf: $0.instructionSets(applying: transformations))
            })
        }
        
        if let rectangles = self.rectangles {
            try rectangles.forEach({
                try output.append(contentsOf: $0.instructionSets(applying: transformations))
            })
        }
        
        if let polygons = self.polygons {
            try polygons.forEach({
                try output.append(contentsOf: $0.instructionSets(applying: transformations))
            })
        }
        
        if let paths = self.paths {
            try paths.forEach({
                try output.append(contentsOf: $0.instructionSets(applying: transformations))
            })
        }
        
        if let groups = self.groups {
            try groups.forEach({
                try output.append(contentsOf: $0.instructionSets(applying: transformations))
            })
        }
        
        return output
    }
}
