import Foundation

extension FileManager {
    func url(for filename: String) throws -> URL {
        // Absolute Path?
        let absoluteURL = URL(fileURLWithPath: filename)
        if fileExists(atPath: absoluteURL.path) {
            return absoluteURL
        }
        
        // Relative Path?
        let directory = URL(fileURLWithPath: currentDirectoryPath, isDirectory: true)
        let relativeURL = directory.appendingPathComponent(filename)
        if fileExists(atPath: relativeURL.path) {
            return relativeURL
        }
        
        throw CocoaError(.fileNoSuchFile)
    }
}
