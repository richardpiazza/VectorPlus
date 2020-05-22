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
                try? context.render(path: path, originalSize: originalSize.cgSize, outputSize: size)
            }
        }
        
        image.unlockFocus()
        return image
    }
    
    func pngData(size: CGSize) -> Data? {
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
