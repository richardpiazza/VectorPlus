import Foundation
import XMLCoder
import Core

/// Defines a [Circle](https://www.w3.org/TR/SVG11/shapes.html#CircleElement).
///
/// The arc of a ‘circle’ element begins at the "3 o'clock" point on the radius and progresses towards the
/// "9 o'clock" point. The starting point and direction of the arc are affected by the user space transform
/// in the same manner as the geometry of the element.
public struct Circle: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
    
    /// The x-axis coordinate of the center of the circle.
    public var x: Float = 0.0
    /// The y-axis coordinate of the center of the circle.
    public var y: Float = 0.0
    /// The radius of the circle.
    public var r: Float = 0.0
    
    enum CodingKeys: String, CodingKey {
        case x = "cx"
        case y = "cy"
        case r = "r"
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
        self.r = r
    }
    
    public init?(instructions: [Instruction]) {
        instructions.forEach { (instruction) in
            if case let .circle(x, y, r) = instruction {
                self.x = x
                self.y = y
                self.r = r
                return
            }
        }
        
        return nil
    }
}

// MARK: - CustomStringConvertible
extension Circle: CustomStringConvertible {
    public var description: String {
        return String(format: "<circle cx=\"%.5f\" cy=\"%.5f\" r=\"%.5f\" />", x, y, r)
    }
}

// MARK: - InstructionRepresentable
extension Circle: InstructionRepresentable {
    public func instructions() throws -> [Instruction] {
        return [
            .move(x: x, y: y),
            .circle(x: x, y: y, r: r),
            .close
        ]
    }
}

// MARK: - SubpathRepresentable
extension Circle: SubpathRepresentable {
}
