import Foundation

public protocol SubpathRepresentable {
    /// All instructions regrouped as individual subpaths
    ///
    /// A 'set' of instructions is determined using the following:
    /// * a `.move` instruction starts a subpath
    /// * a `.close` instruction terminates a subpath.
    ///
    /// If the first instruction encountered is not a `.move`, than an error is thrown.
    ///
    /// - returns: A collection of subpaths
    /// - throws: `Instruction.Error`
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
