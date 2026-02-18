#if canImport(SwiftUI)
import Swift2D
import SwiftColor
import SwiftSVG
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
        switch (fill, stroke) {
        case (.some(let fill), .some(let stroke)):
            switch (fill.pigment, stroke.pigment) {

            case (.some(let fillColor), .some(let strokeColor)):
                self.fill(SwiftUI.Color.make(fillColor)).border(SwiftUI.Color.make(strokeColor))

            case (.some(let fillColor), .none):
                self.fill(SwiftUI.Color.make(fillColor))

            case (.none, .some(let strokeColor)):
                self.border(SwiftUI.Color.make(strokeColor))

            default:
                self
            }
        case (.some(let fill), .none):
            switch (fill.pigment, fill.opacity) {

            case (.some(let fillColor), _):
                self.fill(SwiftUI.Color.make(fillColor))

            default:
                self
            }
        case (.none, .some(let stroke)):
            switch (stroke.pigment, stroke.opacity, stroke.width) {

            case (.some(let strokeColor), _, .some(let width)):
                self.border(SwiftUI.Color.make(strokeColor), width: CGFloat(width))

            case (.some(let strokeColor), _, .none):
                self.border(SwiftUI.Color.make(strokeColor))

            default:
                self
            }
        default:
            self
        }
    }
}
#endif
