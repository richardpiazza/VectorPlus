import Foundation
import ArgumentParser
import SVG
import Graphics
import Templates
import ShellOut
#if canImport(AppKit)
import AppKit
#endif

extension Document.Output: ExpressibleByArgument { }

struct Command: ParsableCommand {
    
    @Argument(help: "The relative or absolute path of the SVG file to be parsed.")
    var filename: String
    
    @Flag(name: .shortAndLong, help: "Output style to generate.")
    var output: Document.Output?
    
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
        
        guard let output = self.output else {
            print(svg.description)
            return
        }
        
        switch output {
        case .struct:
            let value = try svg.asFileTemplate()
            print(value)
        case .uiimageview:
            let value = try svg.asImageViewSubclass()
            print(value)
        case .png:
            #if canImport(AppKit)
            if let value = svg.pngData(size: svg.outputSize.cgSize) {
                let image = directory.appendingPathComponent("image.png")
                try value.write(to: image)
                try shellOut(to: .openFile(at: image.lastPathComponent))
            }
            #endif
        case .preview:
            #if canImport(AppKit)
            if let value = svg.pngData(size: svg.outputSize.cgSize) {
                let app = NSApplication.shared
                let delegate = AppDelegate(data: value)
                app.delegate = delegate
                app.run()
            }
            #endif
        }
    }
}
