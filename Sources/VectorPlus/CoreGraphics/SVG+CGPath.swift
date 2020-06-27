import SwiftSVG
import Swift2D
#if canImport(CoreGraphics)
import CoreGraphics

public extension SVG {
    func path(size: Size) -> CGPath {
        guard size.height > 0.0 && size.width > 0.0 else {
            return CGMutablePath()
        }
        
        guard let paths = try? subpaths() else {
            return CGMutablePath()
        }
        
        let from = Rect(origin: .zero, size: originalSize)
        let to = Rect(origin: .zero, size: size)
        
        let path = CGMutablePath()
        
        paths.forEach { (p) in
            let commands = (try? p.commands()) ?? []
            commands.enumerated().forEach { (idx, command) in
                let previous: Point?
                if idx > 0 {
                    previous = commands[idx - 1].previousPoint
                } else {
                    previous = nil
                }
                
                path.addCommand(command, from: from, to: to, previousPoint: previous)
            }
        }
        
        return path
    }
}
#endif
