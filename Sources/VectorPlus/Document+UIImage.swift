import Foundation
import Swift2D
import SVG
import Graphics
#if canImport(UIKit)
import UIKit

public extension Document {
    func uiImage(size: CGSize) -> UIImage? {
        guard size.height > 0.0 && size.width > 0.0 else {
            return nil
        }
        
        let from = Rect(origin: .zero, size: originalSize)
        let to = Rect(origin: .zero, size: size.size)
        
        let paths: [Path]
        do {
            paths = try self.allPaths()
        } catch {
            return nil
        }
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        paths.forEach { (path) in
            try? context.render(path: path, from: from, to: to)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func pngData(size: CGSize) -> Data? {
        return uiImage(size: size)?.pngData()
    }
}
#endif
