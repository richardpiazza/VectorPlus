import Foundation
import SVG
import Graphics
#if canImport(AppKit)
import AppKit

public extension Document {
    func nsImage(size: CGSize) -> NSImage? {
        guard size.height > 0.0 && size.width > 0.0 else {
            return nil
        }
        
        let paths: [Path]
        do {
            paths = try self.allPaths()
        } catch {
            return nil
        }
        
        let image = NSImage(size: size)
        image.lockFocusFlipped(true)
        
        if let context = NSGraphicsContext.current?.cgContext {
            paths.forEach { (path) in
                context.saveGState()
                
                let cgPath = CGMutablePath()
                
                let instructions = (try? path.instructions()) ?? []
                instructions.forEach { (instruction) in
                    cgPath.addInstruction(instruction, originalSize: originalSize, outputSize: size.size)
                }
                
                context.addPath(cgPath)
                
                switch (path.fillColor, path.strokeColor) {
                case (.some(let fillColor), .some(let strokeColor)):
                    if let opacity = path.fillOpacity, opacity != 0.0 {
                        let color = fillColor.nsColor.withAlphaComponent(CGFloat(opacity)).cgColor
                        context.setFillColor(color)
                        context.fillPath()
                    }
                    if let strokeWidth = path.strokeWidth {
                        let opacity = CGFloat(path.strokeOpacity ?? 1.0)
                        let color = strokeColor.nsColor.withAlphaComponent(opacity).cgColor
                        context.setLineWidth(CGFloat(strokeWidth))
                        context.setStrokeColor(color)
                        context.strokePath()
                    }
                case (.some(let fillColor), .none):
                    if let opacity = path.fillOpacity, opacity != 0.0 {
                        let color = fillColor.nsColor.withAlphaComponent(CGFloat(opacity)).cgColor
                        context.setFillColor(color)
                        context.fillPath()
                    }
                case (.none, .some(let strokeColor)):
                    if let strokeWidth = path.strokeWidth {
                        let opacity = CGFloat(path.strokeOpacity ?? 1.0)
                        let color = strokeColor.nsColor.withAlphaComponent(opacity).cgColor
                        context.setLineWidth(CGFloat(strokeWidth))
                        context.setStrokeColor(color)
                        context.strokePath()
                    }
                case (.none, .none):
                    context.setFillColor(NSColor.black.cgColor)
                    context.fillPath()
                }
                
                context.restoreGState()
            }
        }
        
        image.unlockFocus()
        return image
    }
    
    func pngData(sized size: CGSize) -> Data? {
        guard let data = nsImage(size: size)?.tiffRepresentation else {
            return nil
        }
        
        guard let representation = NSBitmapImageRep(data: data) else {
            return nil
        }
        
        guard let pngData = representation.representation(using: .png, properties: [:]) else {
            return nil
        }
        
        return pngData
    }
}
#endif
