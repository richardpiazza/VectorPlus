import SwiftSVG
import Swift2D

public extension Path {
    func asCoreGraphicsDescription(variable: String = "path", originalSize: Size) throws -> String {
        var outputs: [String] = []
        let commands = (try? self.commands()) ?? []
        commands.enumerated().forEach { (idx, command) in
            let previous: Point?
            if idx > 0 {
                previous = commands[idx - 1].previousPoint
            } else {
                previous = nil
            }
            
            let method = command.coreGraphicsDescription(originalSize: originalSize, previousPoint: previous)
            let code = "\(variable)\(method)"
            outputs.append(code)
        }
        return outputs.joined(separator: "\n        ")
    }
}

public extension Path.Command {
    var previousPoint: Point {
        switch self {
        case .moveTo(let point): return point
        case .lineTo(let point): return point
        case .cubicBezierCurve(_, _, let point): return point
        case .quadraticBezierCurve(_, let point): return point
        case .ellipticalArcCurve(_, _, _, _, _, let point): return point
        case .closePath: return .zero
        }
    }
}
