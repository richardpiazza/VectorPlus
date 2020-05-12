import Foundation
import XMLCoder

public final class Rectangle: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
    
    public var x: Float = 0.0
    public var y: Float = 0.0
    public var width: Float = 0.0
    public var height: Float = 0.0
    public var rx: Float?
    public var ry: Float?
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
        case width
        case height
        case rx
        case ry
    }
    
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
    
    public init() {
        
    }
    
    public init(x: Float, y: Float, width: Float, height: Float) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}

public extension Rectangle {
    var instruction: Instruction {
        return .rectangle(x: x, y: y, w: width, h: height, rx: rx, ry: ry)
    }
    
    var instructions: [Instruction] {
        return [.move(x: x, y: y), instruction, .close]
    }
    
    func asInstructions(using transformations: [Transformation]) -> [Instruction] {
        return instructions.map({ $0.applyingTransformations(transformations) })
    }
}
