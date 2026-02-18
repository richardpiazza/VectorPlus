import ArgumentParser
import Foundation

@main
struct Command: AsyncParsableCommand {

    private static var subcommands: [any ParsableCommand.Type] {
        var subcommands: [any ParsableCommand.Type] = []
        subcommands.append(Inspect.self)
        subcommands.append(Convert.self)
        #if canImport(AppKit)
        subcommands.append(Preview.self)
        subcommands.append(Render.self)
        #endif
        return subcommands
    }

    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "vectorplus",
        abstract: "A utility for manipulating SVG documents.",
        discussion: """

        """,
        version: "1.0.0",
        subcommands: subcommands,
        defaultSubcommand: Inspect.self,
        helpNames: [.short, .long]
    )
}
