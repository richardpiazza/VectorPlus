import Foundation
import Swift2D
import SwiftSVG
#if canImport(CoreGraphics)
import CoreGraphics

public extension SVG {
    func path(size: CGSize) -> CGPath {
        guard size.height > 0.0 && size.width > 0.0 else {
            return CGMutablePath()
        }
        
        guard let paths = try? allPaths() else {
            return CGMutablePath()
        }
        
        let from = Rect(origin: .zero, size: originalSize)
        let to = Rect(origin: .zero, size: size.size)
        
        let path = CGMutablePath()
        
        paths.forEach { (p) in
            let commands = (try? p.commands()) ?? []
            commands.forEach({
                path.addCommand($0, from: from, to: to)
            })
        }
        
        return path
    }
}
#endif
