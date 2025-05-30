import Algorithms
import Foundation
import Utils

/// Data structure representing content of source file in memory.
struct Storage {
  /// Text of source file.
  public var text: String

  /// Location of line breaks in source file.
  public var lineStarts: [String.Index]

  /// Creates an instance with `text` of content and already given line start indexes.
  ///
  /// Precondition: `lineStarts` contain indexe of every line in `text` in ascending order.
  public init(_ text: String, withLineStarts lineStarts: [String.Index]) {
    self.text = text
    self.lineStarts = lineStarts
  }

  /// Creates an instance with `text` of content.
  public init(_ text: String) {
    self.init(text, withLineStarts: text.lineBoundaries())
  }
}

public struct SourceFile {
  /// in-memory content of file.
  private let storage: Storage

  /// Type to index content of source file.
  public typealias Index = String.Index

  /// The URL of the source file.
  public let url: URL

  /// The contents of source file.
  public var text: String { storage.text }

  /// Creates instance representing file at `filePath`.
  public init(contentsOf filePath: URL) throws {
    let text = try String(contentsOf: filePath, encoding: .utf8)
    self.url = filePath
    self.storage = Storage(text)
  }

  /// Creates instance representing file at `filePath`.
  public init(at filePath: String) throws {
    try self.init(contentsOf: URL(fileURLWithPath: filePath))
  }

  /// Creates a synthetic source file with the specified contents and base name.
  public init(synthesizedText text: String) {
    let baseName = UUID().uuidString
    self.url = URL(string: "synthesized://\(baseName)")!
    self.storage = Storage(text)
  }

  /// The name of the source file, sans path qualification or extension.
  public var baseName: String {
    if isSynthesized {
      return url.host!
    } else {
      return url.deletingPathExtension().lastPathComponent
    }
  }

  /// `true` if `self` is synthesized.
  public var isSynthesized: Bool {
    url.scheme == "synthesized"
  }

  /// The number of lines in the file.
  public var linesCount: Int { storage.lineStarts.count }

  /// Returns 1-based line which contains given `index`.
  public func line(containing index: Index) -> Int {
    storage.lineStarts.partitioningIndex { $0 >= index } + 1
  }

  /// Returns 1-based line and column position of given `index`.
  public func lineAndCol(of index: Index) -> (Int, Int) {
    let lineNum = line(containing: index)
    let colNum = text.distance(from: storage.lineStarts[lineNum - 1], to: index) + 1
    return (lineNum, colNum)
  }
}

/// For `SourcePosition`.
extension SourceFile {
  public func position(of index: Index) -> SourcePosition {
    SourcePosition.init(index, in: self)
  }
}

/// For `SourceRange`.
extension SourceFile {
  /// Returns the region of `self` corresponding to `r`.
  ///
  /// - Requires: `r` is a valid range in `self`.
  public func range(_ r: Range<Index>) -> SourceRange {
    SourceRange(r, in: self)
  }

  /// A range covering the whole contents of this instance.
  public var wholeRange: SourceRange {
    range(text.startIndex..<text.endIndex)
  }

  /// Returns a range starting and ending at `index`.
  public func emptyRange(at index: String.Index) -> SourceRange {
    range(index..<index)
  }

  /// Returns the contents of the file in the specified range.
  ///
  /// - Requires: The bounds of `range` are valid positions in `self`.
  public subscript(_ range: SourceRange) -> Substring {
    precondition(range.file.url == url, "invalid range")
    return text[range.startIndex..<range.endIndex]
  }

}
