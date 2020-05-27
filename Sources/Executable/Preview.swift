import Foundation
import ArgumentParser
import SVG
import Templates
#if canImport(AppKit)
import AppKit

struct Preview: ParsableCommand {
    
    static var configuration: CommandConfiguration = {
        let discussion: String = """
        Parses an SVG document displaying the results in an Application window. Do to limitations,
        this command is only available when the `AppKit` framework is present.
        """
        
        return CommandConfiguration(
            commandName: "preview",
            abstract: "Preview the interpretation of an SVG document",
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
        let document = try Document.make(from: url)
        
        guard let data = document.pngData(size: document.originalSize.cgSize) else {
            throw ValidationError("Invalid PNG data.")
        }
        
        let app = NSApplication.shared
        let delegate = AppDelegate(data: data)
        app.delegate = delegate
        app.run()
    }
}

#endif
