import Foundation
import ArgumentParser
import Swift2D
import ShellOut
import SwiftSVG
import VectorPlus

struct Convert: ParsableCommand {
    
    enum Conversion: String, Codable, CaseIterable, ExpressibleByArgument {
        case absolute
        case symbols
        case uiKit = "uikit"
    }
    
    static var configuration: CommandConfiguration = {
        let discussion: String = """
        Parses an SVG document and creates a PNG rendered version of the instructions.

        Supported conversion options are:
        * absolute: Translates all elements to 'absolute' paths.
        * symbols: Generates an Apple Symbols compatible SVG.
        * uikit: A UIImageView subclass that supports dynamic sizing.
        """
        
        return CommandConfiguration(
            commandName: "convert",
            abstract: "Transforms an SVG file to a specific output",
            discussion: discussion,
            version: "",
            shouldDisplay: true,
            subcommands: [],
            defaultSubcommand: nil,
            helpNames: [.short, .long]
        )
    }()
    
    @Argument(help: "The relative or absolute path of the SVG file to be parsed.")
    var filename: String
    
    @Option(name: [.customShort("t"), .customLong("type")], help: "The type of conversion to perform. [absolute, symbols, uikit]")
    var conversion: Conversion
    
    mutating func validate() throws {
        guard !filename.isEmpty else {
            throw ValidationError("Filename not provided or empty.")
        }
    }
    
    func run() throws {
        let url = try FileManager.default.url(for: filename)
        let document = try SVG.make(from: url)
        
        switch conversion {
        case .absolute:
            let absolute = try document.usingAbsolutePaths()
            let data = try SVG.encodeDocument(absolute)
            let outputURL = url.deletingPathExtension().appendingPathExtension("absolute.svg")
            try data.write(to: outputURL)
        case .symbols:
            let path = try document.coalescedPath()
            
            let from = Rect(origin: .zero, size: document.originalSize)
            let to = Rect(origin: .zero, size: Size(width: 100, height: 100))
            let commands = try path.commands().map({ $0.translate(from: from, to: to) })
            let p = Path(commands: commands)
            let symbolsDoc = SVG.appleSymbols(path: p)
            let data = try SVG.encodeDocument(symbolsDoc)
            let outputURL = url.deletingPathExtension().appendingPathExtension("symbols.svg")
            try data.write(to: outputURL)
            
        case .uiKit:
            let value = try document.asImageViewSubclass()
            guard let data = value.data(using: .utf8) else {
                throw CocoaError(.coderInvalidValue)
            }
            
            let outputURL = url.deletingPathExtension().appendingPathExtension("swift")
            try data.write(to: outputURL)
        }
    }
}

extension SVG {
    func usingAbsolutePaths() throws -> SVG {
        let svg = self
        svg.groups = nil
        svg.paths = []
        
        if let elements = self.paths {
            let _elements = try elements.compactMap({ try $0.path(applying: []) })
            try _elements.map({ try $0.commands() }).forEach { (commands) in
                svg.paths?.append(Path(commands: commands))
            }
        }
        
        if let elements = self.groups {
            let _groups = try elements.compactMap({ try $0.usingAbsolutePaths() })
            svg.groups = _groups
        }
        
        return svg
    }
}

extension Group {
    func usingAbsolutePaths(applying transformations: [Transformation] = []) throws -> Group {
        let group = self
        group.circles = nil
        group.lines = nil
        group.polygons = nil
        group.polylines = nil
        group.groups = nil
        group.paths = []
        
        var _transformations = transformations
        _transformations.append(contentsOf: self.transformations)
        
        if let elements = self.circles {
            let _elements = try elements.compactMap({ try $0.path(applying: _transformations) })
            try _elements.map({ try $0.commands() }).forEach { (commands) in
                group.paths?.append(Path(commands: commands))
            }
        }
        
        if let elements = self.rectangles {
            let _elements = try elements.compactMap({ try $0.path(applying: _transformations) })
            try _elements.map({ try $0.commands() }).forEach { (commands) in
                group.paths?.append(Path(commands: commands))
            }
        }
        
        if let elements = self.polygons {
            let _elements = try elements.compactMap({ try $0.path(applying: _transformations) })
            try _elements.map({ try $0.commands() }).forEach { (commands) in
                group.paths?.append(Path(commands: commands))
            }
        }
        
        if let elements = self.polylines {
            let _elements = try elements.compactMap({ try $0.path(applying: _transformations) })
            try _elements.map({ try $0.commands() }).forEach { (commands) in
                group.paths?.append(Path(commands: commands))
            }
        }
        
        if let elements = self.paths {
            let _elements = try elements.compactMap({ try $0.path(applying: _transformations) })
            try _elements.map({ try $0.commands() }).forEach { (commands) in
                group.paths?.append(Path(commands: commands))
            }
        }
        
        if let elements = self.groups {
            let _groups = try elements.compactMap({ try $0.usingAbsolutePaths(applying: _transformations) })
            group.groups = _groups
        }
        
        return group
    }
}
