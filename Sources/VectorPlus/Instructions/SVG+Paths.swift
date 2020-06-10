import Foundation
import SwiftSVG
import Swift2D

public extension SVG {
    var name: String {
        let name = title ?? "SVG Document"
        let newTitle = name.components(separatedBy: .punctuationCharacters).joined(separator: "_")
        return newTitle.replacingOccurrences(of: " ", with: "_")
    }
}

public extension SVG {
    func allPaths() throws -> [Path] {
        var output: [Path] = []
        
        if let paths = self.paths {
            try output.append(contentsOf: paths.map({ try $0.asPath(applying: []) }))
        }
        
        if let groups = self.groups {
            try groups.forEach({
                try output.append(contentsOf: $0.allPaths(applying: []))
            })
        }
        
        return output
    }
    
    func masterPath() throws -> Path {
        let paths = try allPaths()
        let commands = try paths.flatMap({ try $0.commands() })
        return Path(commands: commands)
    }
}
