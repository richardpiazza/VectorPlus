import SwiftSVG
import Swift2D
import SwiftColor
#if canImport(SwiftUI)
import SwiftUI

extension SwiftUI.Path {
    init(path: SwiftSVG.Path, originalSize: Size, outputSize: Size) {
        let from = Rect(origin: .zero, size: originalSize)
        let to = Rect(origin: .zero, size: outputSize)
        
        let mutablePath = CGMutablePath()
        let commands = (try? path.commands()) ?? []
        commands.enumerated().forEach({ (idx, command) in
            let previous: Point?
            if idx > 0 {
                previous = commands[idx - 1].point
            } else {
                previous = nil
            }
            
            mutablePath.addCommand(command, from: from, to: to, previousPoint: previous)
        })
        
        self.init(mutablePath)
    }
    
    @ViewBuilder func styling(fill: SwiftSVG.Fill? = nil, stroke: SwiftSVG.Stroke? = nil) -> some View {
        self
    }
//    @ViewBuilder func styling(fill: SwiftSVG.Fill? = nil, stroke: SwiftSVG.Stroke? = nil) -> some View {
//        switch (fill, stroke) {
//        case (.some(let fill), .some(let stroke)):
//            switch (fill.swiftColor, stroke.swiftColor) {
//
//            case (.some(let fillColor), .some(let strokeColor)):
//                self.fill(Color(fillColor.uiColor)).border(Color(strokeColor.uiColor))
//
//            case (.some(let fillColor), .none):
//                self.fill(Color(fillColor.uiColor))
//
//            case (.none, .some(let strokeColor)):
//                self.border(Color(strokeColor.uiColor))
//
//            default:
//                self
//            }
//        case (.some(let fill), .none):
//            switch (fill.swiftColor, fill.opacity) {
//
//            case (.some(let fillColor), .some(let opacity)):
//                self.fill(Color(fillColor.uiColor).opacity(Double(opacity)))
//
//            case (.some(let fillColor), .none):
//                self.fill(Color(fillColor.uiColor))
//
//            default:
//                self
//            }
//        case (.none, .some(let stroke)):
//            switch (stroke.swiftColor, stroke.opacity, stroke.width) {
//
//            case (.some(let strokeColor), .some(let opacity), .some(let width)):
//                self.border(Color(strokeColor.uiColor).opacity(Double(opacity)), width: CGFloat(width))
//
//            case (.some(let strokeColor), .none, .some(let width)):
//                self.border(Color(strokeColor.uiColor), width: CGFloat(width))
//
//            case (.some(let strokeColor), .some(let opacity), .none):
//                self.border(Color(strokeColor.uiColor).opacity(Double(opacity)))
//
//            default:
//                self
//            }
//        default:
//            self
//        }
//    }
}
#endif
