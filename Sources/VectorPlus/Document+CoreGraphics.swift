import Foundation
import Swift2D
import SVG
import Graphics
#if canImport(CoreGraphics)
import CoreGraphics

public extension Document {
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
            let instructions = (try? p.instructions()) ?? []
            instructions.forEach { (i) in
                path.addInstruction(i, from: from, to: to)
            }
        }
        
        return path
    }
}
#endif
