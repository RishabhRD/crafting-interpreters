/// A half open textual position in a source file.
public struct SourceRange {
  /// The file containing the source text.
  public let file: SourceFile

  /// The region of text containing in `file`'s content.
  public let regionOfFile: Range<SourceFile.Index>

  /// Creates an range of source file with given `range` and `file`.
  public init(_ range: Range<SourceFile.Index>, in file: SourceFile) {
    self.file = file
    self.regionOfFile = range
  }

  /// The start index of `regionOfText`
  public var startIndex: SourceFile.Index { regionOfFile.lowerBound }

  /// The end index of `regionOfText`
  public var endIndex: SourceFile.Index { regionOfFile.upperBound }

  /// The start.
  public var start: SourcePosition { file.position(of: startIndex) }

  /// The end.
  public var end: SourcePosition { file.position(of: endIndex) }

  /// Returns whether `self` contains given position.
  public func contains(_ p: SourcePosition) -> Bool {
    precondition(p.file.url == file.url, "invalid file")
    return regionOfFile.contains(p.index)
  }

  /// The source text in given range.
  public var text: Substring {
    file.text[regionOfFile]
  }
}

/// Extending SourceRange.
extension SourceRange {
  /// Returns a copy of `self` with the end increased (if necessary) to `newEnd`.
  public func extended(upTo newEnd: SourceFile.Index) -> SourceRange {
    precondition(newEnd >= endIndex)
    return file.range(startIndex..<newEnd)
  }

  /// Returns a copy of `self` extended to cover `other`.
  public func extended(toCover other: SourceRange) -> SourceRange {
    precondition(file.url == other.file.url, "incompatible ranges")
    return file.range(
      Swift.min(startIndex, other.startIndex)..<Swift.max(endIndex, other.endIndex))
  }

  /// Increases (if necessary) the end of `self` so that it equals `newEnd`.
  public mutating func extend(upTo newEnd: SourceFile.Index) {
    self = self.extended(upTo: newEnd)
  }

  /// Returns a copy of `self` extended to cover `other`.
  public mutating func extend(toCover other: SourceRange) {
    self = self.extended(toCover: other)
  }
}
