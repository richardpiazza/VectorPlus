import Foundation
import SVG
import Graphics
#if canImport(UIKit)
import UIKit

public extension Document {
    func uiImage(size: CGSize) -> UIImage? {
        guard size.height > 0.0 && size.width > 0.0 else {
            return nil
        }
        
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
            try? context.render(path: path, originalSize: originalSize.cgSize, outputSize: size)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func pngData(size: CGSize) -> Data? {
        return uiImage(size: size)?.pngData()
    }
}
#endif


