import Foundation
import XMLCoder
import Core

/// The closed shape consisting of a set of connected straight line segments.
///
/// If an odd number of coordinates is provided, then the element is in error.
///
/// [Polygon Specification](https://www.w3.org/TR/SVG11/shapes.html#PolygonElement)
public class Polygon: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
    
    /// The points that make up the polygon.
    public var points: String = ""
    
    enum CodingKeys: String, CodingKey {
        case points
    }
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
    
    public init() {
    }
    
    public init(points: String) {
        self.points = points
    }
    
    public init(instructions: [Instruction]) {
        let pointsData = instructions.compactMap({ $0.polygonPoints })
        points = pointsData.joined(separator: " ")
    }
}

// MARK: - CustomStringConvertible
extension Polygon: CustomStringConvertible {
    public var description: String {
        let instructionData = instructions.map({ $0.description }).joined(separator: " ")
        return String(format: "<polygon points=\"%@\" />", instructionData)
    }
}

// MARK: - InstructionRepresentable
extension Polygon: InstructionRepresentable {
    public var instructions: [Instruction] {
        let pairs = points.components(separatedBy: " ")
        let components = pairs.flatMap({ $0.components(separatedBy: ",") })
        guard components.count > 0 else {
            return []
        }
        
        guard components.count % 2 == 0 else {
            // An odd number of components means that parsing probably failed
            return []
        }
        
        var instructions: [Instruction] = []
        
        var firstValue: Bool = true
        for (idx, component) in components.enumerated() {
            guard let value = Float(component) else {
                return instructions
            }
            
            if firstValue {
                if idx == 0 {
                    instructions.append(.move(x: value, y: .nan))
                } else {
                    instructions.append(.line(x: value, y: .nan))
                }
                firstValue = false
            } else {
                let count = instructions.count
                guard let modified = try? instructions.last?.adjusting(relativeValue: value, at: 1) else {
                    return instructions
                }
                
                instructions[count - 1] = modified
                firstValue = true
            }
        }
        
        instructions.append(.close)
        
        return instructions
    }
}
