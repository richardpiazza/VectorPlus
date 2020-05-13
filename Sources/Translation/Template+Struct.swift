import Foundation

internal let fileTemplate: String = """
#if canImport(UIKit)
import UIKit

public struct {{name}} {
    
    private static var pathCache: [String: CGPath] = [:]
    private static var imageCache: [String: UIImage] = [:]
    
    private static func key(for size: CGSize) -> String {
        return String(format: "%.3f,%.3f", size.width, size.height)
    }
    
    private static func key(for size: CGSize, color: UIColor) -> String {
        let sizeKey = key(for: size)
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(format: "%@,%.3f,%.3f,%.3f,%.3f", sizeKey, red, green, blue, alpha)
    }
    
    public static func path(sized size: CGSize) -> CGPath {
        let pathKey = key(for: size)
        
        if let path = pathCache[pathKey] {
            return path
        }
        
        let path = makePath(sized: size)
        pathCache[pathKey] = path
        
        return path
    }
    
    public static func image(sized size: CGSize, fillColor: UIColor) -> UIImage? {
        let imageKey = key(for: size, color: fillColor)
        
        if let image = imageCache[imageKey] {
            return image
        }
        
        guard let image = makeImage(sized: size, fillColor: fillColor) else {
            return nil
        }
        
        imageCache[imageKey] = image
        
        return image
    }
    
    private static func makePath(sized size: CGSize) -> CGPath {
        guard size.height > 0.0 && size.width > 0.0 else {
            return CGMutablePath()
        }
        
        let radius = min(size.width / 2.0, size.height / 2.0)
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        let path = CGMutablePath()
        {{instructions}}
        return path
    }
    
    private static func makeImage(sized size: CGSize, fillColor: UIColor) -> UIImage? {
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
        
        context.addPath(path(sized: size))
        context.setFillColor(fillColor.cgColor)
        context.fillPath()
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    private static func radians(_ degree: Float) -> CGFloat {
        return CGFloat(degree) * (.pi / CGFloat(180))
    }
}

#endif

"""
