import Foundation

public struct MediaManager {
    
    public static let shared: MediaManager = MediaManager()
    
    let fileManager: FileManager
    
    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    /// The root directory where **MiseEnPlace** stores media.
    public func supportDirectory() throws -> URL {
        let directory: URL
        
        #if os(Linux)
        directory = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        #elseif os(Windows)
        directory = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        #elseif os(tvOS)
        // The 'Application Support' directory is not available on tvOS.
        directory = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        #else
        directory = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        #endif
        
        return directory.appendingPathComponent("MiseEnPlace")
    }
    
    /// The directory for images relating to a specific type of `Multimedia`.
    public func imageDirectory(for multimedia: Multimedia) throws -> URL {
        let supportDirectory = try supportDirectory()
        
        var pathURL: URL
        
        switch type(of: self) {
        case is Ingredient.Type:
            pathURL = supportDirectory.appendingPathComponent("Images/Ingredient")
        case is Recipe.Type:
            pathURL = supportDirectory.appendingPathComponent("Images/Recipe")
        case is ProcedureElement.Type:
            pathURL = supportDirectory.appendingPathComponent("Images/ProcedureElement")
        default:
            pathURL = supportDirectory.appendingPathComponent("Images/Other")
        }
        
        if !fileManager.fileExists(atPath: pathURL.path) {
            try fileManager.createDirectory(at: pathURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathURL
    }
    
    /// Generate an 'image path' by copying the data at a specified `URL`.
    public func imagePath(for multimedia: Multimedia, copyingImageAtURL url: URL) throws -> String {
        guard fileManager.fileExists(atPath: url.path) else {
            throw CocoaError(.fileNoSuchFile)
        }
        
        let filename = url.lastPathComponent
        let localURL = try imageDirectory(for: multimedia).appendingPathComponent(filename)
        
        try fileManager.copyItem(at: url, to: localURL)
        
        return filename
    }
    
    /// Generate an 'image path' by writing the provided `Data` to the correct directory.
    public func imagePath(for multimedia: Multimedia, writingData data: Data, name: String = UUID().uuidString, ext: String = "png") throws -> String {
        let url = try imageDirectory(for: multimedia)
            .appendingPathComponent(name)
            .appendingPathExtension(ext)
        
        try data.write(to: url, options: .atomic)
        
        return url.lastPathComponent
    }
    
    /// The absolute local URL for a piece of media.
    public func imageURL(for multimedia: any Multimedia) throws -> URL? {
        guard let imagePath = multimedia.imagePath else {
            return nil
        }
        
        let imageDirectory = try imageDirectory(for: multimedia)
        
        return imageDirectory.appendingPathComponent(imagePath)
    }
    
    /// Bytes representing the multimedia.
    public func data(for multimedia: any Multimedia) throws -> Data? {
        guard let url = try imageURL(for: multimedia) else {
            return nil
        }
        
        return try Data(contentsOf: url)
    }
    
    /// Remove a local image for a specific `Multimedia` item.
    public func removeImage(for multimedia: Multimedia) throws {
        guard let url = try imageURL(for: multimedia) else {
            return
        }
        
        try fileManager.removeItem(atPath: url.path)
    }
}
