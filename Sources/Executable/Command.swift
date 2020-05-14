import Foundation
import ArgumentParser
import Core
import SVG
import Translation

extension Document.Template: ExpressibleByArgument { }

struct Command: ParsableCommand {
    
    @Argument(help: "The relative or absolute path of the SVG file to be parsed.")
    var filename: String
    
    @Flag(name: .shortAndLong, help: "Template style to generate.")
    var template: Document.Template?
    
    mutating func validate() throws {
        guard !filename.isEmpty else {
            throw ValidationError("Filename not provided or empty.")
        }
    }
    
    func run() throws {
        let fileManager = FileManager.default
        let directory = URL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)

        let fileURL: URL

        let argumentURL = URL(fileURLWithPath: filename)
        if fileManager.fileExists(atPath: argumentURL.path) {
            fileURL = argumentURL
        } else {
            fileURL = directory.appendingPathComponent(filename)
        }

        let svg = try Document.make(from: fileURL)
        let tmp = try svg.asTemplate(template ?? .struct)
        
        print(tmp)
    }
}
