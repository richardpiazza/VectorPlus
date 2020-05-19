import Core
#if canImport(CoreGraphics)
import CoreGraphics

extension Subpath {
    func cgPath(originalSize: Size, outputSize: Size) -> CGPath {
        let path = CGMutablePath()
        forEach { (instruction) in
            path.addInstruction(instruction, originalSize: originalSize, outputSize: outputSize)
        }
        return path
    }
}

#endif
