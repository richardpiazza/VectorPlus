import Foundation

public protocol PresentationAttributes {
    var fill: String? { get set }
    var fillOpacity: Float? { get set }
    var stroke: String? { get set }
    var strokeWidth: Float? { get set }
    var strokeOpacity: Float? { get set }
    var transform: String? { get set }
}
