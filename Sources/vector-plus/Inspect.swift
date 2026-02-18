import ArgumentParser
import Foundation
import SwiftSVG
import VectorPlus

struct Inspect: AsyncParsableCommand {

    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "inspect",
        abstract: "Parses an SVG file and displays the interpretation.",
        discussion: """
        Parses an SVG document and prints out the document description.
        """,
        helpNames: [.short, .long]
    )

    @Argument(help: "The relative or absolute path of the SVG file to be parsed.")
    var filename: String

    mutating func validate() throws {
        guard !filename.isEmpty else {
            throw ValidationError("Filename not provided or empty.")
        }
    }

    func run() async throws {
        let url = try FileManager.default.url(for: filename)
        let document = try SVG.make(from: url)

        print(document.description)
    }
}
