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
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        let path = self.path(size: size)
        context.addPath(path)
        context.setFillColor(UIColor.black.cgColor)
        context.fillPath()
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
#endif


