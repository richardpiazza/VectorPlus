import Foundation
import ArgumentParser
import ShellOut
import SwiftSVG
import Swift2D
import VectorPlus
#if canImport(AppKit)
import AppKit

struct Render: ParsableCommand {
    
    static var configuration: CommandConfiguration = {
        let discussion: String = """
        Parses an SVG document and creates a PNG rendered version of the instructions. Do to limitations,
        this command is only available when the `AppKit` framework is present.
        """
        
        return CommandConfiguration(
            commandName: "render",
            abstract: "Renders an SVG document to a PNG file",
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
    
    @Option(help: "The horizontal and vertical output size.")
    var size: Double?
    
    mutating func validate() throws {
        guard !filename.isEmpty else {
            throw ValidationError("Filename not provided or empty.")
        }
    }
    
    func run() throws {
        let url = try FileManager.default.url(for: filename)
        let document = try SVG.make(from: url)
        
        let outputSize: Size
        if let size = self.size {
            outputSize = Size(width: size, height: size)
        } else {
            outputSize = document.outputSize
        }
        
        guard let data = document.pngData(size: outputSize) else {
            throw ValidationError("Invalid PNG data.")
        }
        
        let outputURL = url.deletingPathExtension().appendingPathExtension("\(Int(outputSize.width))pt.png")
        try data.write(to: outputURL)
        try shellOut(to: .openFile(at: outputURL.absoluteString))
    }
}

#endif
