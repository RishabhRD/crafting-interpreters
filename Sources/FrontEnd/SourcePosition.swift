public struct SourcePosition {
  /// The source file containing the position.
  public let file: SourceFile

  /// The position relative to the source file.
  public let index: String.Index

  /// Creates and instance with the given properties.
  public init(_ index: String.Index, in file: SourceFile) {
    self.file = file
    self.index = index
  }

  /// The 1-based indexed line in which `self` resides.
  public var line: Int { file.line(containing: index) }

  /// The 1-based indexed (line, col) of `self`.
  public var lineAndCol: (Int, Int) { file.lineAndCol(of: index) }

  /// Returns a site from `l` to `r`.
  ///
  /// - Requires: `l.file == r.file`
  public static func ..< (l: Self, r: Self) -> SourceRange {
    return l.file.range(l.index..<r.index)
  }
}
