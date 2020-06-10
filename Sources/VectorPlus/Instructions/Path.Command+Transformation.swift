import Foundation
import SwiftSVG
import Swift2D

public extension Path.Command {
    func translate(from: Rect, to: Rect) -> Path.Command {
        switch self {
        case .moveTo(let point):
            let _point = VectorPoint(point: point, in: from).translate(to: to)
            return .moveTo(point: _point)
        case .lineTo(let point):
            let _point = VectorPoint(point: point, in: from).translate(to: to)
            return .lineTo(point: _point)
        case .cubicBezierCurve(let cp1, let cp2, let point):
            let _cp1 = VectorPoint(point: cp1, in: from).translate(to: to)
            let _cp2 = VectorPoint(point: cp2, in: from).translate(to: to)
            let _point = VectorPoint(point: point, in: from).translate(to: to)
            return .cubicBezierCurve(cp1: _cp1, cp2: _cp2, point: _point)
        case .quadraticBezierCurve(let cp, let point):
            let _cp = VectorPoint(point: cp, in: from).translate(to: to)
            let _point = VectorPoint(point: point, in: from).translate(to: to)
            return .quadraticBezierCurve(cp: _cp, point: _point)
        case .closePath:
            return self
        }
    }
    
    func applying(transformations: [Transformation]) -> Path.Command {
        var command = self
        
        transformations.forEach { (transformation) in
            command = command.applying(transformation: transformation)
        }
        
        return command
    }
}
