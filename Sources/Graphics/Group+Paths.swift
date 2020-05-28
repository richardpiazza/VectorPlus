import Foundation
import SVG

public extension Group {
    func allPaths(applying transformations: [Transformation]) throws -> [Path] {
        var modifications = transformations
        modifications.append(contentsOf: self.transformations)
        
        var output: [Path] = []
        
        if let circles = self.circles {
            try output.append(contentsOf: circles.compactMap({ try $0.asPath(applying: modifications) }))
        }
        
        if let rectangles = self.rectangles {
            try output.append(contentsOf: rectangles.compactMap({ try $0.asPath(applying: modifications) }))
        }
        
        if let polygons = self.polygons {
            try output.append(contentsOf: polygons.compactMap({ try $0.asPath(applying: modifications) }))
        }
        
        if let paths = self.paths {
            try output.append(contentsOf: paths.map({ try $0.asPath(applying: modifications) }))
        }
        
        if let groups = self.groups {
            try groups.forEach({
                try output.append(contentsOf: $0.allPaths(applying: modifications))
            })
        }
        
        return output
    }
}
