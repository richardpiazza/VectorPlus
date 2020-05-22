import Foundation
import SVG

public protocol PathRepresentable: InstructionRepresentable, PresentationAttributes {
    
}

public extension PathRepresentable {
    func asPath(applying transformations: [Transformation]) throws -> Path {
        var modifications = transformations
        modifications.append(contentsOf: self.transformations)
        
        let instructions = try self.instructions().map({ $0.applying(transformations: modifications) })
        
        var path = Path(instructions: instructions)
        path.fill = fill
        path.fillOpacity = fillOpacity
        path.stroke = stroke
        path.strokeOpacity = strokeOpacity
        path.strokeWidth = strokeWidth
        
        return path
    }
}
