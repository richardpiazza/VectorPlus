import Foundation
import SVG
#if canImport(CoreGraphics)
import CoreGraphics

public extension CGContext {
    func render(path: Path, originalSize: CGSize, outputSize: CGSize) throws {
        saveGState()
        
        let cgPath = CGMutablePath()
        
        let instructions = (try? path.instructions()) ?? []
        instructions.forEach { (instruction) in
            cgPath.addInstruction(instruction, originalSize: originalSize.size, outputSize: outputSize.size)
        }
        
        addPath(cgPath)
        
        switch (path.cgFillColor, path.cgStrokeColor) {
        case (.some(let fillColor), .some(let strokeColor)):
            if let opacity = path.fillOpacity, opacity != 0.0 {
                let color = fillColor.copy(alpha: CGFloat(opacity)) ?? fillColor
                setFillColor(color)
                fillPath()
            }
            if let strokeWidth = path.strokeWidth {
                let opacity = CGFloat(path.strokeOpacity ?? 1.0)
                let color = strokeColor.copy(alpha: opacity) ?? strokeColor
                let lineWidth = CGFloat(strokeWidth) * (outputSize.width / originalSize.width)
                setLineWidth(lineWidth)
                setStrokeColor(color)
                strokePath()
            }
        case (.some(let fillColor), .none):
            if let opacity = path.fillOpacity, opacity != 0.0 {
                let color = fillColor.copy(alpha: CGFloat(opacity)) ?? fillColor
                setFillColor(color)
                fillPath()
            }
        case (.none, .some(let strokeColor)):
            if let strokeWidth = path.strokeWidth {
                let opacity = CGFloat(path.strokeOpacity ?? 1.0)
                let color = strokeColor.copy(alpha: opacity) ?? strokeColor
                let lineWidth = CGFloat(strokeWidth) * (outputSize.width / originalSize.width)
                setLineWidth(lineWidth)
                setStrokeColor(color)
                strokePath()
            }
        case (.none, .none):
            setFillColor(CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
            fillPath()
        }
        
        restoreGState()
    }
}

#endif
