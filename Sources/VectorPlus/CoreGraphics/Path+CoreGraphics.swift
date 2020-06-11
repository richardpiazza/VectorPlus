import Foundation
import Swift2D
import SwiftSVG

public extension Path {
    func asCoreGraphicsDescription(variable: String = "path", originalSize: Size) throws -> String {
        var outputs: [String] = []
        let commands = (try? self.commands()) ?? []
        commands.forEach { (i) in
            let method = i.coreGraphicsDescription(originalSize: originalSize)
            let code = "\(variable)\(method)"
            outputs.append(code)
        }
        return outputs.joined(separator: "\n        ")
    }
}
