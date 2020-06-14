import Foundation
import Swift2D
import SwiftColor
import SwiftSVG
#if canImport(CoreGraphics)
import CoreGraphics

public extension CGContext {
    func render(path: Path, from: Rect, to: Rect) throws {
        saveGState()
        
        let cgPath = CGMutablePath()
        
        let commands = (try? path.commands()) ?? []
        commands.enumerated().forEach { (idx, command) in
            let previous: Point?
            if idx > 0 {
                previous = commands[idx - 1].previousPoint
            } else {
                previous = nil
            }
            
            cgPath.addCommand(command, from: from, to: to, previousPoint: previous)
        }
        
        if let fill = path.fill {
            let cgColor = Color(fill.color ?? "black").cgColor
            let color = cgColor.copy(alpha: CGFloat(fill.opacity ?? 1.0)) ?? cgColor
            let rule = fill.rule.cgFillRule
            
            setFillColor(color)
            addPath(cgPath)
            fillPath(using: rule)
        }
        
        if let stroke = path.stroke {
            let cgColor = Color(stroke.color ?? "black").cgColor
            let color = cgColor.copy(alpha: CGFloat(stroke.opacity ?? 1.0)) ?? cgColor
            let width = stroke.width ?? 1.0
            let lineWidth = CGFloat(width * (to.size.width / from.size.width))
            
            setLineWidth(lineWidth)
            setStrokeColor(color)
            setLineCap(stroke.lineCap.cgLineCap)
            setLineJoin(stroke.lineJoin.cgLineJoin)
            if let miterLimit = stroke.miterLimit, stroke.lineJoin == .miter {
                setMiterLimit(CGFloat(miterLimit))
            }
            addPath(cgPath)
            strokePath()
        }
        
        if path.fill == nil && path.stroke == nil {
            let color = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            setFillColor(color)
            addPath(cgPath)
            fillPath(using: path.fill?.rule.cgFillRule ?? .winding)
        }
        
        restoreGState()
    }
}

#endif
