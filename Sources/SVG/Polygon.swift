import Foundation
import XMLCoder

public class Polygon: Codable, DynamicNodeEncoding, DynamicNodeDecoding {
    
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
}

public extension Polygon {
    func asPath() -> Path {
        let path = Path()
        
        guard !points.isEmpty else {
            return path
        }
        
        let components = points.components(separatedBy: " ")
        guard components.count > 0 else {
            return path
        }
        
        guard components.count % 2 == 0 else {
            return path
        }
        
        var index: Int = 0
        
        for (idx, component) in components.enumerated() {
            if idx == index {
                if index == 0 {
                    path.data.append(String(format: "%@%@", Instruction.Prefix.move.stringValue, component))
                } else {
                    path.data.append(String(format: "%@%@", Instruction.Prefix.line.stringValue, component))
                }
            } else {
                path.data.append(String(format: ",%@ ", component))
                index += 2
            }
        }
        
        path.data.append(Instruction.Prefix.close.stringValue)
        
        return path
    }
}
