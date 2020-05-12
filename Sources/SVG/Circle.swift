import Foundation
import XMLCoder

public class Circle: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
    
    public var x: Float = 0.0
    public var y: Float = 0.0
    public var radius: Float = 0.0
    
    enum CodingKeys: String, CodingKey {
        case x = "cx"
        case y = "cy"
        case radius = "r"
    }
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
    
    public init() {
        
    }
    
    public init(x: Float, y: Float, r: Float) {
        self.x = x
        self.y = y
        radius = r
    }
}

public extension Circle {
    var instruction: Instruction {
        return .circle(x: x, y: y, r: radius)
    }
    
    var instructions: [Instruction] {
        return [.move(x: x, y: y), instruction, .close]
    }
    
    func asInstructions(using transformations: [Transformation]) -> [Instruction] {
        return instructions.map({ $0.applyingTransformations(transformations )})
    }
}
