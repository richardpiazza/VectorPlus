import Foundation
import Swift2D
import SVG
#if canImport(CoreGraphics)
import CoreGraphics

public extension CGContext {
    func render(path: Path, from: Rect, to: Rect) throws {
        saveGState()
        
        let cgPath = CGMutablePath()
        
        let instructions = (try? path.instructions()) ?? []
        instructions.forEach { (instruction) in
            cgPath.addInstruction(instruction, from: from, to: to)
        }
        
        switch (path.cgFillColor, path.cgStrokeColor) {
        case (.some(let fillColor), .some(let strokeColor)):
            if let opacity = path.fillOpacity, opacity != 0.0 {
                let color = fillColor.copy(alpha: CGFloat(opacity)) ?? fillColor
                setFillColor(color)
                addPath(cgPath)
                fillPath(using: path.cgFillRule)
            } else {
                // If opacity is not defined, assume 1.0
                setFillColor(fillColor)
                addPath(cgPath)
                fillPath(using: path.cgFillRule)
            }
            if let strokeWidth = path.strokeWidth {
                let opacity = CGFloat(path.strokeOpacity ?? 1.0)
                let color = strokeColor.copy(alpha: opacity) ?? strokeColor
                let lineWidth = CGFloat(strokeWidth * (to.size.width / from.size.width))
                setLineWidth(lineWidth)
                setStrokeColor(color)
                if let lineCap = path.cgStrokeLineCap {
                    setLineCap(lineCap)
                }
                if let lineJoin = path.cgStrokeLineJoin {
                    setLineJoin(lineJoin)
                    if let miterLimit = path.strokeMiterLimit, lineJoin == .miter {
                        setMiterLimit(CGFloat(miterLimit))
                    }
                }
                addPath(cgPath)
                strokePath()
            }
        case (.some(let fillColor), .none):
            if let opacity = path.fillOpacity, opacity != 0.0 {
                let color = fillColor.copy(alpha: CGFloat(opacity)) ?? fillColor
                setFillColor(color)
                addPath(cgPath)
                fillPath(using: path.cgFillRule)
            } else {
                // If opacity is not defined, assume 1.0
                setFillColor(fillColor)
                addPath(cgPath)
                fillPath(using: path.cgFillRule)
            }
        case (.none, .some(let strokeColor)):
            if let strokeWidth = path.strokeWidth {
                let opacity = CGFloat(path.strokeOpacity ?? 1.0)
                let color = strokeColor.copy(alpha: opacity) ?? strokeColor
                let lineWidth = CGFloat(strokeWidth * (to.size.width / from.size.width))
                setLineWidth(lineWidth)
                setStrokeColor(color)
                if let lineCap = path.cgStrokeLineCap {
                    setLineCap(lineCap)
                }
                if let lineJoin = path.cgStrokeLineJoin {
                    setLineJoin(lineJoin)
                    if let miterLimit = path.strokeMiterLimit, lineJoin == .miter {
                        setMiterLimit(CGFloat(miterLimit))
                    }
                }
                addPath(cgPath)
                strokePath()
            }
        case (.none, .none):
            setFillColor(CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
            addPath(cgPath)
            fillPath(using: path.cgFillRule)
        }
        
        restoreGState()
    }
}

#endif
