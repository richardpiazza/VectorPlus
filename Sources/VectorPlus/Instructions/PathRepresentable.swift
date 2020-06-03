import Foundation
import SwiftSVG

public protocol PathRepresentable: InstructionRepresentable, PresentationAttributes {
    
}

public extension PathRepresentable {
    /// When a `Path` is accessed on an element, the path that is returned should have the supplied transformations
    /// applied.
    ///
    /// For instance, if
    /// * a `Path.data` contains relative elements,
    /// * and `transformations` contains a `.translate`
    ///
    /// Than the path created will not only use 'absolute' instructions, but those instructions will be modified to
    /// include the required transformation.
    func asPath(applying transformations: [Transformation]) throws -> Path {
        var modifications = transformations
        modifications.append(contentsOf: self.transformations)
        
        let instructions = try self.instructions().map({ $0.applying(transformations: modifications) })
        
        let path = Path(instructions: instructions)
        path.fillColor = fillColor
        path.fillOpacity = fillOpacity
        path.strokeColor = strokeColor
        path.strokeOpacity = strokeOpacity
        path.strokeWidth = strokeWidth
        
        return path
    }
}