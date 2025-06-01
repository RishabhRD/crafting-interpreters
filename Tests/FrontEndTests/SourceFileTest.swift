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
    let idx = str.index(str.startIndex, offsetBy: 11)
    let (line, col) = source.lineAndCol(of: idx)
    #expect(line == 3)
    #expect(col == 2)
  }
}
