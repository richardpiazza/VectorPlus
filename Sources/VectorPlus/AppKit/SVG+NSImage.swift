import Foundation
import Swift2D
import SwiftSVG
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension SVG {
    func nsImage(size: CGSize) -> NSImage? {
        guard size.height > 0.0 && size.width > 0.0 else {
            return nil
        }
        
        let from = Rect(origin: .zero, size: originalSize)
        let to = Rect(origin: .zero, size: size.size)
        
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
                try? context.render(path: path, from: from, to: to)
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
