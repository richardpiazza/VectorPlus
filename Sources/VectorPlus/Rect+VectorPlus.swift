import Swift2D

public extension Rect {
    var coreGraphicsDescription: String {
        return "CGRect(origin: \(origin.coreGraphicsDescription), size: \(size.coreGraphicsDescription))"
    }
}
