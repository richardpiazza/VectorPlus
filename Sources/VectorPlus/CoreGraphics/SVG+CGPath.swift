import Foundation
import SwiftSVG
#if canImport(CoreGraphics)
import CoreGraphics

public extension SVG {
    func path(size: CGSize) -> CGPath {
        guard size.height > 0.0 && size.width > 0.0 else {
            return CGMutablePath()
        }
        
        guard let paths = try? subpaths() else {
            return CGMutablePath()
        }
        
        let from = CGRect(origin: .zero, size: originalSize)
        let to = CGRect(origin: .zero, size: size)
        
        let path = CGMutablePath()
        
        paths.forEach { (p) in
            let commands = (try? p.commands()) ?? []
            commands.enumerated().forEach { (idx, command) in
                let previous: CGPoint?
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
