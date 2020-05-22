import Foundation
import SVG

// MARK: - InstructionSetRepresentable
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

public extension Group {
    func allPaths() throws -> [Path] {
        var output: [Path] = []
        
        if let circles = self.circles {
            try output.append(contentsOf: circles.compactMap({ try $0.asPath() }))
        }
        
        if let rectangles = self.rectangles {
            try output.append(contentsOf: rectangles.compactMap({ try $0.asPath() }))
        }
        
        if let polygons = self.polygons {
            try output.append(contentsOf: polygons.compactMap({ try $0.asPath() }))
        }
        
        if let paths = self.paths {
            output.append(contentsOf: paths)
        }
        
        if let groups = self.groups {
            try groups.forEach({
                try output.append(contentsOf: $0.allPaths())
            })
        }
        
        return output
    }
}
