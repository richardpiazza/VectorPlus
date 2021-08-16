import SwiftSVG
import Swift2D

extension SVG {
    static var df: SVG {
        let size = Size(width: 200, height: 200)
        var document = SVG(width: Int(size.width), height: Int(size.height))
        document.paths = [
            .circle(radius: size.minRadius),
            .star(radius: size.minRadius)
        ]
        return document
    }
}

private extension SwiftSVG.Path {
    static func circle(radius: Double) -> SwiftSVG.Path {
        let circle = Circle(x: radius, y: radius, r: radius)
        let commands = (try? circle.commands()) ?? []
        
        var path = Path(commands: commands)
        path.fillColor = "#4a525a"
        return path
    }
    
    static func star(radius: Double) -> SwiftSVG.Path {
        let star = Star(radius: radius)
        let commands = (try? star.commands()) ?? []
        
        var path = Path(commands: commands)
        path.fillColor = "#ffffff"
        return path
    }
}

private struct Star: DirectionalCommandRepresentable {
    
    let radius: Double
    
    init(radius: Double = 100.0) {
        self.radius = radius
    }
    
    func commands(clockwise: Bool) throws -> [SwiftSVG.Path.Command] {
        let from = Rect(origin: .zero, size: Size(width: 100.0, height: 100.0))
        let to = Rect(origin: .zero, size: Size(width: radius, height: radius))
        
        if clockwise {
            let commands: [SwiftSVG.Path.Command] = [
                .moveTo(point: Point(x: 100, y: 7)),
                .lineTo(point: Point(x: 121, y: 71)),
                .lineTo(point: Point(x: 188, y: 71)),
                .lineTo(point: Point(x: 135, y: 110)),
                .lineTo(point: Point(x: 155, y: 175)),
                .lineTo(point: Point(x: 100, y: 135)),
                .lineTo(point: Point(x: 45, y: 175)),
                .lineTo(point: Point(x: 66, y: 110)),
                .lineTo(point: Point(x: 12, y: 71)),
                .lineTo(point: Point(x: 79, y: 71)),
                .closePath
            ]
                
            return commands.map { $0.translate(from: from, to: to) }
        } else {
            let commands: [SwiftSVG.Path.Command] = [
                .moveTo(point: Point(x: 100, y: 7)),
                .lineTo(point: Point(x: 79, y: 71)),
                .lineTo(point: Point(x: 12, y: 71)),
                .lineTo(point: Point(x: 66, y: 110)),
                .lineTo(point: Point(x: 45, y: 175)),
                .lineTo(point: Point(x: 100, y: 135)),
                .lineTo(point: Point(x: 155, y: 175)),
                .lineTo(point: Point(x: 135, y: 110)),
                .lineTo(point: Point(x: 188, y: 71)),
                .lineTo(point: Point(x: 121, y: 71)),
                .closePath
            ]
                
            return commands.map { $0.translate(from: from, to: to) }
        }
    }
}
