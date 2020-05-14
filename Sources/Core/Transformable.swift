import Foundation

public protocol Transformable {
    func applying(transformation: Transformation) -> Self
}
