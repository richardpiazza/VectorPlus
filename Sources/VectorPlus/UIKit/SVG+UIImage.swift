import SwiftSVG
import Swift2D
#if canImport(UIKit)
import UIKit

public extension SVG {
    func uiImage(size: Size) -> UIImage? {
        guard size.height > 0.0 && size.width > 0.0 else {
            return nil
        }
        
        let from = Rect(origin: .zero, size: originalSize)
        let to = Rect(origin: .zero, size: size)
        
        let paths: [Path]
        do {
            paths = try self.subpaths()
        } catch {
            return nil
        }
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(size), false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        paths.forEach { (path) in
            try? context.render(path: path, from: from, to: to)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func pngData(size: Size) -> Data? {
        return uiImage(size: size)?.pngData()
    }
}
#endif
