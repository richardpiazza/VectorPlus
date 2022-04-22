import Foundation
import ArgumentParser

struct Command: ParsableCommand {

    static var configuration: CommandConfiguration = {
        let discussion: String = """
        
        """
        
        var subcommands: [ParsableCommand.Type] = []
        subcommands.append(Inspect.self)
        subcommands.append(Convert.self)
        #if canImport(AppKit)
        subcommands.append(Preview.self)
        subcommands.append(Render.self)
        #endif
        
        return CommandConfiguration(
            commandName: "vectorplus",
            abstract: "A utility for manipulating SVG documents.",
            usage: nil,
            discussion: discussion,
            version: "1.0.0",
            shouldDisplay: true,
            subcommands: subcommands,
            defaultSubcommand: Inspect.self,
            helpNames: [.short, .long]
        )
    }()
    
}

Command.main()
