import Foundation

public protocol PresentationAttributes {
    var fill: String? { get set }
    var fillOpacity: Float? { get set }
    var stroke: String? { get set }
    var strokeWidth: Float? { get set }
    var strokeOpacity: Float? { get set }
    var strokeLineCap: Stroke.LineCap? { get set }
    var strokeLineJoin: Stroke.LineJoin? { get set }
    var strokeMiterLimit: Float? { get set }
    var transform: String? { get set }
    
}

public extension PresentationAttributes {
    var presentationDescription: String {
        var attributes: [String] = []
        
        if let fill = self.fill {
            attributes.append("\(CodingKeys.fill.rawValue)=\"\(fill)\"")
        }
        if let fillOpacity = self.fillOpacity {
            attributes.append("\(CodingKeys.fillOpacity.rawValue)=\"\(fillOpacity)\"")
        }
        if let stroke = self.stroke {
            attributes.append("\(CodingKeys.stroke.rawValue)=\"\(stroke)\"")
        }
        if let strokeWidth = self.strokeWidth {
            attributes.append("\(CodingKeys.strokeWidth.rawValue)=\"\(strokeWidth)\"")
        }
        if let strokeOpacity = self.strokeOpacity {
            attributes.append("\(CodingKeys.strokeOpacity.rawValue)=\"\(strokeOpacity)\"")
        }
        if let strokeLineCap = self.strokeLineCap {
            attributes.append("\(CodingKeys.strokeLineCap.rawValue)=\"\(strokeLineCap.description)\"")
        }
        if let strokeLineJoin = self.strokeLineJoin {
            attributes.append("\(CodingKeys.strokeLineJoin.rawValue)=\"\(strokeLineJoin.description)\"")
        }
        if let strokeMiterLimit = self.strokeMiterLimit {
            attributes.append("\(CodingKeys.strokeMiterLimit.rawValue)=\"\(strokeMiterLimit)\"")
        }
        if let transform = self.transform {
            attributes.append("\(CodingKeys.transform.rawValue)=\"\(transform)\"")
        }
        
        return attributes.joined(separator: " ")
    }
    
    var transformations: [Transformation] {
        let value = transform?.replacingOccurrences(of: " ", with: "") ?? ""
        guard !value.isEmpty else {
            return []
        }
        
        let values = value.split(separator: ")").map({ $0.appending(")") })
        return values.compactMap({ Transformation($0) })
    }
}

fileprivate enum CodingKeys: String, CodingKey {
    case fill
    case fillOpacity = "fill-opacity"
    case stroke
    case strokeWidth = "stroke-width"
    case strokeOpacity = "stroke-opacity"
    case strokeLineCap = "stroke-linecap"
    case strokeLineJoin = "stroke-linejoin"
    case strokeMiterLimit = "stroke-miterlimit"
    case transform
}
