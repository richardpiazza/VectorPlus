import Foundation

public protocol SubpathRepresentable {
    func subpaths() throws -> [Subpath]
}

public extension SubpathRepresentable {
    func subpaths(applying transformations: [Transformation]) throws -> [Subpath] {
        var output: [Subpath] = []
        
        let subpaths = try self.subpaths()
        
        subpaths.forEach { (subpath) in
            var set = Subpath()
            subpath.forEach { (instruction) in
                set.append(instruction.applying(transformations: transformations))
            }
            output.append(set)
        }
        
        return output
    }
}
