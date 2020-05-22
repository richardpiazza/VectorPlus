import Foundation

public protocol PresentationAttributes {
    var fill: String? { get set }
    var fillOpacity: Float? { get set }
    var stroke: String? { get set }
    var strokeWidth: Float? { get set }
    var strokeOpacity: Float? { get set }
    var transform: String? { get set }
}

public extension PresentationAttributes {
    var presentationDescription: String {
        var attributes: [String] = []
        
        if let fill = self.fill {
            attributes.append("fill=\"\(fill)\"")
        }
        if let fillOpacity = self.fillOpacity {
            attributes.append("fill-opacity=\"\(fillOpacity)\"")
        }
        if let stroke = self.stroke {
            attributes.append("stroke=\"\(stroke)\"")
        }
        if let strokeWidth = self.strokeWidth {
            attributes.append("stroke-width=\"\(strokeWidth)\"")
        }
        if let strokeOpacity = self.strokeOpacity {
            attributes.append("stroke-opacity=\"\(strokeOpacity)\"")
        }
        if let transform = self.transform {
            attributes.append("transform=\"\(transform)\"")
        }
        
        return attributes.joined(separator: " ")
    }
}
