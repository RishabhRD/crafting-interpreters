import FrontEnd
import Testing

@Suite("SourceFile Tests") struct SourceFileTests {
  let str =
    """
    hello
    abc
    23
    3
    """
  var source: SourceFile { SourceFile(synthesizedText: str) }

  @Test func linesCount() {
    #expect(source.linesCount == 4)
  }

  @Test func lineAndCol() {
    var idx = str.index(str.startIndex, offsetBy: 11)
    var (line, col) = source.lineAndCol(of: idx)
    #expect(line == 3)
    #expect(col == 2)

    idx = str.startIndex
    (line, col) = source.lineAndCol(of: idx)
    #expect(line == 1)
    #expect(col == 1)

    idx = str.index(str.startIndex, offsetBy: 6)
    (line, col) = source.lineAndCol(of: idx)
    #expect(line == 2)
    #expect(col == 1)

    idx = str.index(str.endIndex, offsetBy: -1)
    (line, col) = source.lineAndCol(of: idx)
    #expect(line == 4)
    #expect(col == 1)
  }
}
