import Foundation
import ArgumentParser
import SVG
import Swift2D
import Templates
import ShellOut

struct Convert: ParsableCommand {
    
    enum Conversion: String, Codable, CaseIterable, ExpressibleByArgument {
        case absolute
        case symbols
        case uiKit = "uikit"
    }
    
    static var configuration: CommandConfiguration = {
        let discussion: String = """
        Parses an SVG document and creates a PNG rendered version of the instructions. Do to limitations,
        this command is only available when the `AppKit` framework is present.
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
    
    @Option(help: "The type of conversion to perform.")
    var conversion: Conversion
    
    mutating func validate() throws {
        guard !filename.isEmpty else {
            throw ValidationError("Filename not provided or empty.")
        }
    }
    
    func run() throws {
        let url = try FileManager.default.url(for: filename)
        let document = try Document.make(from: url)
        
        switch conversion {
        case .absolute:
            throw CocoaError(.featureUnsupported)
        case .symbols:
            guard let path = try document.allPaths().first else {
                throw CocoaError(.formatting)
            }
            
            let from = Rect(origin: .zero, size: document.originalSize)
            let to = Rect(origin: .zero, size: Size(width: 100, height: 100))
            let instructions = try path.instructions().map({ $0.translate(from: from, to: to) })
            let p = Path(instructions: instructions)
            let symbolsDoc = Document.appleSymbols(path: p)
            let data = try Document.encodeSymbols(symbolsDoc)
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
