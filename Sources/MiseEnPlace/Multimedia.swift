import Foundation

/// Parameter and helper methods for managing a single image representation of an object.
///
/// ## Required Conformance
///
/// ```swift
/// /// The binary representation of the media (image) file.
/// var imageData: Data? { get set }
/// /// A localized platform path to the image data.
/// var imagePath: String? { get set }
/// ```
///
/// > note `imageData` & `imagePath` may be deprecated in **MiseEnPlace 6.0** in favor of
///   a `[Media]` collection allowing for multiple pieces of media.
public protocol Multimedia {
    /// The binary representation of the media (image) file.
    var imageData: Data? { get set }
    /// A localized platform path to the image data.
    var imagePath: String? { get set }
    @available(*, deprecated, message: "`MediaManager` should be used to persist `Multimedia`.")
    var fileManager: FileManager { get }
}

public extension Multimedia {
    @available(*, deprecated, message: "`MediaManager` should be used to persist `Multimedia`.")
    var fileManager: FileManager {
        return .default
    }
    
    /// A File URL representation of the `imagePath`.
    @available(*, deprecated, renamed: "MediaManager.imageURL(for:)")
    var imageURL: URL? {
        guard let path = self.imagePath else {
            return nil
        }
        
        return imageDirectory.appendingPathComponent(path)
    }
    
    /// A reference to the directory where images for this `Multimedia` type
    /// can be found.
    @available(*, deprecated, renamed: "MediaManager.imageDirectory(for:)")
    var imageDirectory: URL {
        return fileManager.imageDirectory(for: self)
    }
    
    /// Creates a local copy of asset at the supplied URL.
    @available(*, deprecated, renamed: "MediaManager.imagePath(for:copyingImageAtURL:)")
    mutating func copyImage(atURL url: URL) {
        self.imagePath = fileManager.imagePath(for: self, copyingImageAtURL: url)
    }
    
    @available(*, deprecated, renamed: "MediaManager.imagePath(for:writingData:name:ext:)")
    mutating func writeImage(_ data: Data, name: String = UUID().uuidString, ext: String = "png") {
        imagePath = fileManager.imagePath(for: self, writingData: data, name: name, ext: ext)
    }
    
    @available(*, deprecated, renamed: "MediaManager.removeImage(for:)")
    mutating func removeImage() {
        self.imagePath = nil
        fileManager.removeImage(for: self)
    }
}

@available(*, deprecated, message: "`MediaManager` should be used to persist `Multimedia`.")
internal extension FileManager {
    var supportDirectory: URL {
        let directory: URL
        
        do {
            #if os(Linux)
            directory = try url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            #elseif os(Windows)
            directory = try url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            #elseif os(tvOS)
            // The 'Application Support' directory is not available on tvOS.
            directory = try url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            #else
            directory = try url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            #endif
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return directory.appendingPathComponent("MiseEnPlace")
    }
}

@available(*, deprecated, message: "`MediaManager` should be used to persist `Multimedia`.")
public extension FileManager {
    /// A reference to the directory where images for this `Multimedia` type
    /// can be found.
    func imageDirectory(for multimedia: Multimedia) -> URL {
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
        
        if !fileExists(atPath: pathURL.path) {
            do {
                try createDirectory(at: pathURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        return pathURL
    }
    
    func imagePath(for multimedia: Multimedia, copyingImageAtURL url: URL) -> String? {
        guard fileExists(atPath: url.path) else {
            print("No File Found at path: '\(url.path)'")
            return nil
        }
        
        let filename = url.lastPathComponent
        let localURL = imageDirectory(for: multimedia).appendingPathComponent(filename)
        
        do {
            try copyItem(at: url, to: localURL)
            return filename
        } catch {
            print(error)
            return nil
        }
    }
    
    func imagePath(for multimedia: Multimedia, writingData data: Data, name: String = UUID().uuidString, ext: String = "png") -> String? {
        let url = imageDirectory(for: multimedia).appendingPathComponent(name).appendingPathExtension(ext)
        
        do {
            try data.write(to: url, options: .atomic)
            return url.lastPathComponent
        } catch {
            print(error)
            return nil
        }
    }
    
    func removeImage(for multimedia: Multimedia) {
        guard let url = multimedia.imageURL else {
            return
        }
        
        do {
            try removeItem(atPath: url.path)
        } catch {
            print(error)
        }
    }
}
