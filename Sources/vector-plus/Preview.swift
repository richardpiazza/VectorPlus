#if canImport(AppKit)
import ArgumentParser
import AppKit
import Foundation
import Swift2D
import SwiftSVG
import VectorPlus

struct Preview: AsyncParsableCommand {
    
    static let configuration: CommandConfiguration = CommandConfiguration(
        commandName: "preview",
        abstract: "Preview the interpretation of an SVG document",
        discussion:  """
        Parses an SVG document displaying the results in an Application window. Do to limitations,
        this command is only available when the `AppKit` framework is present.
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
        
        guard let data = document.pngData(size: Size(width: 400, height: 400)) else {
            throw ValidationError("Invalid PNG data.")
        }

        await MainActor.run {
            let app = NSApplication.shared
            let delegate = AppDelegate(data: data)
            app.delegate = delegate
            app.run()
        }
    }
}

@MainActor
private class AppDelegate: NSObject, NSApplicationDelegate {

    let data: Data
    let window: NSWindow

    init(data: Data) {
        self.data = data

        let size = NSSize(width: 400, height: 400)

        let contentRect: NSRect
        if let frame = NSScreen.main?.visibleFrame {
            let x = (frame.size.width / 2.0) - (size.width / 2.0)
            let y = (frame.size.height / 2.0) - (size.height / 2.0)
            contentRect = NSRect(origin: NSPoint(x: x, y: y), size: size)
        } else {
            contentRect = NSRect(origin: NSPoint(x: 200, y: 200), size: size)
        }

        let styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        window = NSWindow(contentRect: contentRect, styleMask: styleMask, backing: .buffered, defer: false, screen: nil)

        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        window.makeKey()
        window.orderFrontRegardless()

        let imageView = NSImageView(frame: window.contentView!.bounds)
        window.contentView?.addSubview(imageView)
        imageView.autoresizingMask = [.height, .width]

        DispatchQueue.global(qos: .background).async {
            if let image = NSImage(data: self.data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
#endif
