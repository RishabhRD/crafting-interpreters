import FrontEnd
import Testing

@Suite struct LexerTests {
  @Test func consumesWhitespace() {
    let source = "  \n \r \rvar text"

    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.var, "var"),
        TokenSpecification(.name, "text"),
      ]
    )
  }

  @Test func consumesComments() {
    let source =
      """
      var
      // somthing that is //
      //    

         
      /* something
       *   /*
       *
       *   */
      */

      // somthing that is //
      //    

         
      /* something
       *   /*
       *
       *   */
      not a token*/

      x
      """

    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.var, "var"),
        TokenSpecification(.name, "x"),
      ]
    )
  }

  @Test func detectsUnterminatedBlockComment() {
    let source = "/* /* not a token */ * /"

    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.unterminatedBlockComment, source)
      ]
    )
  }

  @Test func parsesBool() {
    let source = "true false"
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.true, "true"),
        TokenSpecification(.false, "false"),
      ]
    )
  }

  @Test func parsesString() {
    let source =
      """
      "hell
      o"
      """
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.string, source)
      ]
    )
  }

  @Test func detectsUnterminatedString() {
    let source =
      """
      "hell
      o
      """
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.unterminatedString, source)
      ]
    )
  }

  @Test func parsesNumberWithoutDecimal() {
    let source = "132"
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.number, "132")
      ]
    )
  }

  @Test func parsesNumberWithTrailingDecimal() {
    let source = "132."
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.number, "132.")
      ]
    )
  }

  @Test func parsesFloat() {
    let source = "132.34"
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.number, "132.34")
      ]
    )
  }

  @Test func rejectsMalformedNumber() {
    let source = "132.34.33"
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.invalid, "132.34.33")
      ]
    )
  }

  @Test func parsesName() {
    let source = "varName"
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.name, "varName")
      ]
    )
  }

  @Test func parsesKeywords() {
    let source =
      " and class else false fun for if nil not or print return super this true var while "
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.and, "and"),
        TokenSpecification(.class, "class"),
        TokenSpecification(.else, "else"),
        TokenSpecification(.false, "false"),
        TokenSpecification(.fun, "fun"),
        TokenSpecification(.for, "for"),
        TokenSpecification(.if, "if"),
        TokenSpecification(.nil, "nil"),
        TokenSpecification(.not, "not"),
        TokenSpecification(.or, "or"),
        TokenSpecification(.print, "print"),
        TokenSpecification(.return, "return"),
        TokenSpecification(.super, "super"),
        TokenSpecification(.this, "this"),
        TokenSpecification(.true, "true"),
        TokenSpecification(.var, "var"),
        TokenSpecification(.while, "while"),
      ]
    )
  }

  @Test func parsesOperators() {
    let source =
      "!= == >= <= > < = + - * / %"
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.not_equals, "!="),
        TokenSpecification(.equals, "=="),
        TokenSpecification(.greater_equals, ">="),
        TokenSpecification(.less_equals, "<="),
        TokenSpecification(.greater, ">"),
        TokenSpecification(.less, "<"),
        TokenSpecification(.assign, "="),
        TokenSpecification(.plus, "+"),
        TokenSpecification(.minus, "-"),
        TokenSpecification(.multiply, "*"),
        TokenSpecification(.divide, "/"),
        TokenSpecification(.modulo, "%"),
      ]
    )
  }

  @Test func parsesPunctuationAndDelimeters() {
    let source =
      ",.;(){}[]"
    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.comma, ","),
        TokenSpecification(.dot, "."),
        TokenSpecification(.semicolon, ";"),
        TokenSpecification(.lparen, "("),
        TokenSpecification(.rparen, ")"),
        TokenSpecification(.lbrace, "{"),
        TokenSpecification(.rbrace, "}"),
        TokenSpecification(.lbracket, "["),
        TokenSpecification(.rbracket, "]"),
      ]
    )
  }

  @Test func detectsInvalidTokenForUnknownCharacter() {
    let source = "||abc"

    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.invalid, "|"),
        TokenSpecification(.invalid, "|"),
        TokenSpecification(.name, "abc"),
      ]
    )
  }

  @Test func detectsInvalidTokenForBadOperators() {
    let source = ">>>==abc"

    assert(
      tokenize(source),
      matching: [
        TokenSpecification(.invalid, ">>>=="),
        TokenSpecification(.name, "abc"),
      ]
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
        sourceLocation: spec.sourceLocation
      )

      // Should have same token text. As text is derived from range and source
      // file, it would implicitly check if location of token is correct or not.
      let tokenText = token.site.text
      #expect(
        tokenText == spec.value,
        "token has value '\(tokenText)' not '\(spec.value)'",
        sourceLocation: spec.sourceLocation
      )
    }
  }
}
