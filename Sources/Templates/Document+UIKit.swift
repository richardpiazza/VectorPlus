import CoreGraphics
import SVG
import Graphics

#if canImport(UIKit)
import UIKit

public extension Document {
    func path(sized size: CGSize, instructionSet: InstructionSet) -> CGPath {
        guard size.height > 0.0 && size.width > 0.0 else {
            return CGMutablePath()
        }
        
        let includedPath = CGMutablePath()
        for instruction in instructionSet.include {
            includedPath.addInstruction(instruction, originalSize: originalSize, outputSize: size)
        }
        
        let excludedPath = CGMutablePath()
        for instruction in instructionSet.exclude {
            excludedPath.addInstruction(instruction, originalSize: originalSize, outputSize: size)
        }
        
        let path: CGPath
        if excludedPath.isEmpty {
            path = includedPath
        } else {
            let bezierPath = UIBezierPath(cgPath: includedPath)
            bezierPath.append(UIBezierPath(cgPath: excludedPath))
            bezierPath.usesEvenOddFillRule = false
            
            path = bezierPath.cgPath
        }
        
        return path
    }
    
    func image(sized size: CGSize, fillColor: UIColor) -> UIImage? {
        guard size.height > 0.0 && size.width > 0.0 else {
            return nil
        }
        
        let instructionSet: InstructionSet
        do {
            instructionSet = try asInstructionSet()
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
        
        context.addPath(path(sized: size, instructionSet: instructionSet))
        context.setFillColor(fillColor.cgColor)
        context.fillPath()
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

#endif
