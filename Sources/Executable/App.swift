#if canImport(AppKit)
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
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
