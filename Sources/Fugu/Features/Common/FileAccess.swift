import struct Foundation.URL
import struct Foundation.Data
import class Foundation.FileManager
import struct Foundation.ObjCBool

public struct FileAccess {
  
  public var load: (URL) -> Result<Data, FileAccessError>
  public var save: (Data, URL) -> Result<Void, FileAccessError>
  public var delete: (URL) -> Result<Void, FileAccessError>
}

public enum FileAccessError: Error {
  
  case missingFile
  case fileAccessFailed
}

public extension FileAccess {
  
  static var system: Self {
    Self(
      load: { fileURL in
        if FileManager.default.isReadableFile(atPath: fileURL.path) {
          do {
            return try .success(Data(contentsOf: fileURL))
          } catch {
            return .failure(.fileAccessFailed)
          }
        } else {
          return .failure(.missingFile)
        }
      },
      save: { data, fileURL in
        do {
          let directoryURL = fileURL.deletingLastPathComponent()
          var isDirectory: ObjCBool = false
          FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory)
          if !isDirectory.boolValue {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
          } else { /**/ }
          if FileManager.default.createFile(atPath: fileURL.path, contents: data) {
            return .success(())
          } else {
            return .failure(.fileAccessFailed)
          }
        } catch {
          return .failure(.fileAccessFailed)
        }
      },
      delete: { fileURL in
        do {
          return try .success(FileManager.default.removeItem(at: fileURL))
        } catch {
          return .failure(.fileAccessFailed)
        }
      })
  }
}

extension FileAccess: Feature {
  
  public static func load(in container: FeatureContainer) -> FileAccess {
    .system
  }
}

extension FeatureContainer {
  
  var fileAccess: FileAccess {
    get { self[FileAccess.self] }
    set { self[FileAccess.self] = newValue }
  }
}
