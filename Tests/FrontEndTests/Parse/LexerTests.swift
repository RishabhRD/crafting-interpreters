import FrontEnd
import Testing

@Suite struct LexerTests {
  @Test func consumesWhitespace() {
    let source: SourceFile = "  \n \r \rvar text"

    assert(
      tokenize(source.text),
      matching: [
        TokenSpecification(.var, "var"),
        TokenSpecification(.name, "text"),
      ],
      in: source
    )
  }

  private func tokenize(_ str: String) -> [Token] {
    Array(Lexer(tokenizing: SourceFile(synthesizedText: str)))
  }

  private struct TokenSpecification {
    let kind: Token.Kind
    let value: String
    let sourceLocation: SourceLocation

    init(_ kind: Token.Kind, _ value: String, sourceLocation: SourceLocation = #_sourceLocation) {
      self.kind = kind
      self.value = value
      self.sourceLocation = sourceLocation
    }
  }

  private func assert(
    _ tokens: [Token],
    matching specs: [TokenSpecification],
    in sourceCode: SourceFile,
    sourceLocation: SourceLocation = #_sourceLocation
  ) {
    // Should have number of tokens.
    #expect(
      tokens.count == specs.count,
      "expected \(specs.count) token(s), found \(tokens.count)",
      sourceLocation: sourceLocation)

    for (token, spec) in zip(tokens, specs) {
      // Should have same token kind.
      #expect(
        token.kind == spec.kind,
        "token has kind '\(token.kind)' not '\(spec.kind)'",
        sourceLocation: sourceLocation
      )

      // Should have same token text. As text is derived from range and source
      // file, it would implicitly check if location of token is correct or not.
      let tokenText = token.site.text
      #expect(
        tokenText == spec.value,
        "token has value '\(tokenText)' not '\(spec.value)'",
        sourceLocation: sourceLocation
      )
    }
  }
}
