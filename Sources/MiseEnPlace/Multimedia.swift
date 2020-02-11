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
        
        return imageDirectory.appendingPathComponent(path)
    }
    
    /// A reference to the directory where images for this `Multimedia` type
    /// can be found.
    var imageDirectory: URL {
        let url = FileManager.default.supportDirectory
        
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
        let localURL = imageDirectory.appendingPathComponent(filename)
        
        do {
            try FileManager.default.copyItem(at: url, to: localURL)
            self.imagePath = filename
        } catch {
            print(error)
            self.imagePath = nil
        }
    }
    
    mutating func writeImage(_ data: Data, name: String = UUID().uuidString, ext: String = "png") {
        let url = imageDirectory.appendingPathComponent(name).appendingPathExtension(ext)
        
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
