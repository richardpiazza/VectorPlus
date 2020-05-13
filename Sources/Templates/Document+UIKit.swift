import SVG
import Graphics

#if canImport(UIKit)
import UIKit

public extension Document {
    func path(sized size: CGSize, subpaths: [[Instruction]]) -> CGPath {
        guard size.height > 0.0 && size.width > 0.0 else {
            return CGMutablePath()
        }
        
        let mutablePath = CGMutablePath()
        subpaths.forEach { (path) in
            path.forEach { (instruction) in
                mutablePath.addInstruction(instruction, originalSize: originalSize, outputSize: size)
            }
        }
        
        return mutablePath
    }
    
    func image(sized size: CGSize, fillColor: UIColor) -> UIImage? {
        guard size.height > 0.0 && size.width > 0.0 else {
            return nil
        }
        
        let subpaths: [[Instruction]]
        do {
            subpaths = try asSubpaths()
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
        
        context.addPath(path(sized: size, subpaths: subpaths))
        context.setFillColor(fillColor.cgColor)
        context.fillPath()
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

#endif
