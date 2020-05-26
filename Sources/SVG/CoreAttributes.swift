import Foundation

public protocol CoreAttributes {
    var id: String? { get set }
}

public extension CoreAttributes {
    var coreDescription: String {
        if let id = self.id {
            return "id=\"\(id)\""
        } else {
            return ""
        }
    }
}
