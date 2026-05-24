#if canImport(SwiftUI)
import Swift2D
import SwiftSVG
import SwiftUI

public struct SVGView: View {
    let svg: SVG
    private var paths: [SwiftSVG.Path] { svg.paths ?? [] }
    private var content: [(Int, SwiftSVG.Path)] { Array(zip(paths.indices, paths)) }

    public init(svg: SVG) {
        self.svg = svg
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(content, id: \.0) { index, path in
                    SwiftUI.Path(path: path, originalSize: svg.originalSize, outputSize: Size(geometry.size))
                        .styling(fill: path.fill, stroke: path.stroke)
                }
            }
        }
    }
}

struct PathSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SVGView(svg: .df)
    }
}
#endif
