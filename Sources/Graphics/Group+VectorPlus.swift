import Foundation
import SVG

public extension Group {
    var transformations: [Transformation] {
        let value = transform?.replacingOccurrences(of: " ", with: "") ?? ""
        guard !value.isEmpty else {
            return []
        }
        
        let values = value.split(separator: ")").map({ $0.appending(")") })
        return values.compactMap({ Transformation($0) })
    }
}

// MARK: - SubpathRepresentable
extension Group: SubpathRepresentable {
    public func subpaths() throws -> [Subpath] {
        var output: [Subpath] = []
        
        if let circles = self.circles {
            try circles.forEach({
                try output.append(contentsOf: $0.subpaths(applying: transformations))
            })
        }
        
        if let rectangles = self.rectangles {
            try rectangles.forEach({
                try output.append(contentsOf: $0.subpaths(applying: transformations))
            })
        }
        
        if let polygons = self.polygons {
            try polygons.forEach({
                try output.append(contentsOf: $0.subpaths(applying: transformations))
            })
        }
        
        if let paths = self.paths {
            try paths.forEach({
                try output.append(contentsOf: $0.subpaths(applying: transformations))
            })
        }
        
        if let groups = self.groups {
            try groups.forEach({
                try output.append(contentsOf: $0.subpaths(applying: transformations))
            })
        }
        
        return output
    }
}
