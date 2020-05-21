import Foundation
import SVG
import Graphics
#if canImport(UIKit)
import UIKit

public extension Document {
    func path(sized size: CGSize, instructionSets: [InstructionSet]) -> CGPath {
        guard size.height > 0.0 && size.width > 0.0 else {
            return CGMutablePath()
        }
        
        let mutablePath = CGMutablePath()
        instructionSets.forEach { (path) in
            mutablePath.addPath(path.cgPath(originalSize: originalSize, outputSize: size.size))
        }
        
        return mutablePath
    }
    
    func image(sized size: CGSize, fillColor: UIColor) -> UIImage? {
        guard size.height > 0.0 && size.width > 0.0 else {
            return nil
        }
        
        guard let instructionSets = try? instructionSets() else {
            return nil
        }
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.addPath(path(sized: size, instructionSets: instructionSets))
        context.setFillColor(fillColor.cgColor)
        context.fillPath()
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

#endif
