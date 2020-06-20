import Foundation
import SwiftSVG
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public extension Path {
    func asCoreGraphicsDescription(variable: String = "path", originalSize: CGSize) throws -> String {
        var outputs: [String] = []
        let commands = (try? self.commands()) ?? []
        commands.enumerated().forEach { (idx, command) in
            let previous: CGPoint?
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

extension Path.Command {
    var previousPoint: CGPoint {
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
