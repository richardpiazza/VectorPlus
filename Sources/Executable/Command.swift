import Foundation
import ArgumentParser
import SVG
import Swift2D
import Graphics
import Templates
import ShellOut
#if canImport(AppKit)
import AppKit
#endif

struct Command: ParsableCommand {
    
    @Argument(help: "The relative or absolute path of the SVG file to be parsed.")
    var filename: String
    
    @Flag(name: .long, help: "Outputs a 'UIImageView' subclass that supports dynamic resizing")
    var `class`: Bool
    
    @Flag(name: .long, help: "Generates an Apple Symbols SVG document.")
    var symbols: Bool
    
    #if canImport(AppKit)
    @Flag(name: .long, help: "Writes a png image to input file path.")
    var png: Bool
    
    @Option(name: .long, help: "Image size when --png is used.")
    var size: Float?
    
    @Flag(name: .long, help: "Generates a preview window.")
    var preview: Bool
    #endif
    
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
        
        if `class` {
            let value = try svg.asImageViewSubclass()
            print(value)
        }
        
        if symbols {
            if let path = try svg.allPaths().first {
                let from = Rect(origin: .zero, size: svg.originalSize)
                let to = Rect(origin: .zero, size: Size(width: 100, height: 100))
                let instructions = try path.instructions().map({ $0.translate(from: from, to: to) })
                let p = Path(instructions: instructions)
                let symbolsDoc = Document.appleSymbols(path: p)
                let data = try Document.encodeSymbols(symbolsDoc)
                let outputURL = fileURL.deletingPathExtension().appendingPathExtension("symbols.svg")
                try data.write(to: outputURL)
            }
        }
        
        #if canImport(AppKit)
        if `class` == false && (png == false && preview == false) {
            print(svg.description)
            return
        }
        #else
        print(svg.description)
        return
        #endif
        
        #if canImport(AppKit)
        let outputSize: CGSize
        if let size = self.size {
            outputSize = CGSize(width: CGFloat(size), height: CGFloat(size))
        } else {
            outputSize = svg.outputSize.cgSize
        }
        
        guard let data = svg.pngData(size: outputSize) else {
            return
        }
        
        if png {
            let outputURL = fileURL.deletingPathExtension().appendingPathExtension("\(Int(outputSize.width))pt.png")
            try data.write(to: outputURL)
            try shellOut(to: .openFile(at: outputURL.absoluteString))
        }
        
        if preview {
            let app = NSApplication.shared
            let delegate = AppDelegate(data: data)
            app.delegate = delegate
            app.run()
        }
        #endif
    }
}
