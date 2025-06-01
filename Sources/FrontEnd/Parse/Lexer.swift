public struct Lexer: IteratorProtocol, Sequence {
  /// The source being tokanized.
  public let sourceCode: SourceFile

  /// The current position of lexer in `sourceCode`.
  private(set) var index: String.Index

  /// The current location of the lexer in `sourceCode`.
  public var location: SourcePosition { sourceCode.position(of: index) }

  /// Remaining text of `sourceCode` to tokenize.
  private var rest: Substring { sourceCode.text[index...] }

  /// Remaining text of `sourceCode` to tokenize.
  private var text: String { sourceCode.text }

  /// Creates an instance of lexer generating tokens from contents of `source`.
  public init(tokenizing source: SourceFile) {
    self.sourceCode = source
    self.index = sourceCode.text.startIndex
  }

  /// Advances state to the next token and returns it,
  /// or returns `nil` if no next token exists.
  public mutating func next() -> Token? {
    while true {
      // If no next token, returns nil.
      if index == sourceCode.text.endIndex { return nil }

      // Skip whitespace
      if text[index].isWhitespace {
        discard()
        continue
      }

      // Skip line comments
      if take(prefix: "//") != nil {
        index = rest.firstIndex(where: \.isNewline) ?? text.endIndex
        continue
      }

      // Skip block comments
      if let start = take(prefix: "/*") {
        var open = 1
        while open > 0 {
          if take(prefix: "/*") != nil {
            open += 1
          } else if take(prefix: "*/") != nil {
            open -= 1
          } else if index < text.endIndex {
            discard()
          } else {
            return Token(
              kind: .unterminatedBlockComment,
              site: sourceCode.range(start..<index)
            )
          }
        }
        continue
      }

      // Other than this, we would always have a token.
      break
    }

    let head = text[index]
    var token = Token(kind: .invalid, site: location..<location)

    // Parse keywords and names.
    if head.isLetter {
      switch take(where: { $0.isLetter || $0.isDecDigit })
      {
      case "and": token.kind = .and
      case "class": token.kind = .class
      case "else": token.kind = .else
      case "false": token.kind = .false
      case "fun": token.kind = .fun
      case "for": token.kind = .for
      case "if": token.kind = .if
      case "nil": token.kind = .nil
      case "not": token.kind = .not
      case "or": token.kind = .or
      case "print": token.kind = .print
      case "return": token.kind = .return
      case "super": token.kind = .super
      case "this": token.kind = .this
      case "true": token.kind = .true
      case "var": token.kind = .var
      case "while": token.kind = .while
      default: token.kind = .name
      }

      token.site.extend(upTo: index)
      return token
    }

    // Parse number.
    if head.isDecDigit {
      let number = take(where: { $0.isDecDigit || $0 == "." })
      // Valid number
      if number.filter({ $0 == "." }).count <= 1 {
        token.kind = .number
      }

      token.site.extend(upTo: index)
      return token
    }

    // Parse string.
    if head == "\"" {
      discard()
      _ = take(where: { $0 != "\"" })

      // Unterminated string.
      if index == text.endIndex {
        token.kind = .unterminatedString
        token.site.extend(upTo: index)
        return token
      }

      // Valid string.
      discard()
      token.kind = .string
      token.site.extend(upTo: index)
      return token
    }

    if head.isOperator {
      let op = take(where: \.isOperator)
      switch op {
      case "!=": token.kind = .not_equals
      case "==": token.kind = .equals
      case ">=": token.kind = .greater_equals
      case "<=": token.kind = .less_equals
      case ">": token.kind = .greater
      case "<": token.kind = .less
      case "=": token.kind = .assign
      case "+": token.kind = .plus
      case "-": token.kind = .minus
      case "*": token.kind = .multiply
      case "/": token.kind = .divide
      case "%": token.kind = .modulo
      case _: ()
      }
      token.site.extend(upTo: index)
      return token
    }

    // Parse punctuation and delimeters.
    switch head {
    // Punctuation
    case ",": token.kind = .comma
    case ".": token.kind = .dot

    // Delimeters
    case ";": token.kind = .semicolon
    case "(": token.kind = .lparen
    case ")": token.kind = .rparen
    case "{": token.kind = .lbrace
    case "}": token.kind = .rbrace
    case "[": token.kind = .lbracket
    case "]": token.kind = .rbracket
    default: ()
    }

    discard()
    token.site.extend(upTo: index)
    return token
  }

  /// Returns the current index and consumes `prefix` from the stream, or returns `nil` if the
  /// stream starts with a different prefix.
  private mutating func take<T: Sequence>(prefix: T) -> String.Index?
  where T.Element == Character {
    var newIndex = index
    for ch in prefix {
      if newIndex == sourceCode.text.endIndex || sourceCode.text[newIndex] != ch {
        return nil
      }
      newIndex = sourceCode.text.index(after: newIndex)
    }

    defer { index = newIndex }
    return index
  }

  /// Consumes longest substring satisfying given predicate and returns that substring.
  private mutating func take(where predicate: (Character) -> Bool) -> Substring {
    let newIndex = rest.firstIndex { !predicate($0) } ?? text.endIndex
    defer { index = newIndex }
    return text[index..<newIndex]
  }

  /// Discards `count` characters from stream; If stream contains less than `count`
  /// characters, discard all of remaining characters.
  private mutating func discard(_ count: Int = 1) {
    index = sourceCode.text.index(index, offsetBy: count)
  }
}

extension Character {
  fileprivate var isOperator: Bool {
    "<>!=+-*/%".contains(self)
  }
}
