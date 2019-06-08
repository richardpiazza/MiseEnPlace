import Foundation

/// Parameter and helper methods for managing a single image representation of an object.
///
/// ## Requied Conformance
///
/// ```swift
/// // A localized platform path to the image data.
/// var imagePath: String? { get set }
/// ```
///
public protocol Multimedia {
    var imagePath: String? { get set }
}

public extension Multimedia {
    /// A File URL representation of the `imagePath`.
    var imageURL: URL? {
        guard let path = self.imagePath else {
            return nil
        }
        
        return self.directoryURL.appendingPathComponent(path)
    }
    
    /// A reference to the directory where images for this `Multimedia` type
    /// can be found.
    var directoryURL: URL {
        var urls: [URL]
        #if os(tvOS)
        urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        #else
        urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        #endif
        
        guard let url = urls.last else {
            fatalError("Could not find url for storage directory.")
        }
        
        var pathURL: URL
        switch type(of: self) {
        case is Ingredient.Type:
            pathURL = url.appendingPathComponent("Images/Ingredient")
        case is Recipe.Type:
            pathURL = url.appendingPathComponent("Images/Recipe")
        case is ProcedureElement.Type:
            pathURL = url.appendingPathComponent("Images/ProcedureElement")
        default:
            pathURL = url.appendingPathComponent("Images/Other")
        }
        
        if !FileManager.default.fileExists(atPath: pathURL.path) {
            do {
                try FileManager.default.createDirectory(at: pathURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        return pathURL
    }
    
    /// Creates a local copy of asset at the supplied URL.
    mutating func copyImage(atURL url: URL) {
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("No File Found at path: '\(url.path)'")
            return
        }
        
        let filename = url.lastPathComponent
        let localURL = self.directoryURL.appendingPathComponent(filename)
        
        do {
            try FileManager.default.copyItem(at: url, to: localURL)
            self.imagePath = filename
        } catch {
            print(error)
            self.imagePath = nil
        }
    }
    
    mutating func writeImage(_ data: Data, name: String = UUID().uuidString, ext: String = "png") {
        let url = self.directoryURL.appendingPathComponent(name).appendingPathExtension(ext)
        
        do {
            try data.write(to: url, options: .atomic)
            self.imagePath = url.lastPathComponent
        } catch {
            print(error)
        }
    }
    
    mutating func removeImage() {
        let url = self.imageURL
        self.imagePath = nil
        
        if let url = url {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            } catch {
                print(error)
            }
        }
    }
}
