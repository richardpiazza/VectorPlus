import Foundation
import ArgumentParser
import ShellOut
import SwiftSVG
import VectorPlus

struct Inspect: ParsableCommand {
    
    static var configuration: CommandConfiguration = {
        let discussion: String = """
        Parses an SVG document and prints out the document description.
        """
        
        return CommandConfiguration(
            commandName: "inspect",
            abstract: "Parses an SVG file and displays the interpretation.",
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
    
    mutating func validate() throws {
        guard !filename.isEmpty else {
            throw ValidationError("Filename not provided or empty.")
        }
    }
    
    func run() throws {
        let url = try FileManager.default.url(for: filename)
        let document = try SVG.make(from: url)
        
        print(document.description)
    }
}
