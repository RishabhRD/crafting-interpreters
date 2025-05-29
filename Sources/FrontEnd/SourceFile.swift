import Foundation

/// Data structure representing content of file in memory.
struct Storage {
  /// Text of file.
  public var text: String

  /// Location of line breaks.
  public var lineStarts: [String.Index]
}

public struct SourceFile {
  /// in memory content of file.
  private let storage: Storage

  /// The URL of the source file.
  public let url: URL

  /// The contents of source file.
  public var text: String { storage.text }
}
