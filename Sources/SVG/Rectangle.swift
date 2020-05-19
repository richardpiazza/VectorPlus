import Foundation
import XMLCoder
import Core

/// Defines a rectangle ([Rect](https://www.w3.org/TR/SVG11/shapes.html#RectElement))
///
/// The values used for the x- and y-axis rounded corner radii are determined implicitly
/// if the ‘rx’ or ‘ry’ attributes (or both) are not specified, or are specified but with invalid values.
public struct Rectangle: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
    
    /// The x-axis coordinate of the side of the rectangle which
    /// has the smaller x-axis coordinate value.
    public var x: Float = 0.0
    /// The y-axis coordinate of the side of the rectangle which
    /// has the smaller y-axis coordinate value
    public var y: Float = 0.0
    /// The width of the rectangle.
    public var width: Float = 0.0
    /// The height of the rectangle.
    public var height: Float = 0.0
    /// For rounded rectangles, the x-axis radius of the ellipse used
    /// to round off the corners of the rectangle.
    public var rx: Float?
    /// For rounded rectangles, the y-axis radius of the ellipse used
    /// to round off the corners of the rectangle.
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
    
    public init(x: Float, y: Float, width: Float, height: Float, rx: Float? = nil, ry: Float? = nil) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rx = rx
        self.ry = ry
    }
    
    public init?(instructions: [Instruction]) {
        instructions.forEach { (instruction) in
            if case let .rectangle(x, y, width, height, rx, ry) = instruction {
                self.x = x
                self.y = y
                self.width = width
                self.height = height
                self.rx = rx
                self.ry = ry
                return
            }
        }
        
        return nil
    }
}

// MARK: - CustomStringConvertible
extension Rectangle: CustomStringConvertible {
    public var description: String {
        var desc = String(format: "<rect x=\"%.5f\" y=\"%.5f\" width=\"%.5f\" height=\"%.5f\"", x, y, width, height)
        if let rx = self.rx {
            desc.append(String(format: " rx=\"%.5f\"", rx))
        }
        if let ry = self.ry {
            desc.append(String(format: " ry=\"%.5f\"", ry))
        }
        desc.append(" />")
        return desc
    }
}

// MARK: - InstructionRepresentable
extension Rectangle: InstructionRepresentable {
    public func instructions() throws -> [Instruction] {
        return [
            .move(x: x, y: y),
            .rectangle(x: x, y: y, w: width, h: height, rx: rx, ry: ry),
            .close
        ]
    }
}

// MARK: - SubpathRepresentable
extension Rectangle: SubpathRepresentable {
}
