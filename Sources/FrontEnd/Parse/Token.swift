public struct Token {
  public enum Kind: Int {
    // Errors
    case invalid = 0
    case unterminatedString
    case unterminatedBlockComment

    // Keywords
    case `and` = 1000
    case `class`
    case `else`
    case `false`
    case `fun`
    case `for`
    case `if`
    case `nil`
    case `not`
    case `or`
    case `print`
    case `return`
    case `super`
    case `this`
    case `true`
    case `var`
    case `while`

    // Literals
    case name = 2000
    case string
    case number

    // Operators
    case `not_equals` = 3000
    case `equals`
    case `greater_equals`
    case `less_equals`
    case `greater`
    case `less`
    case `assign`
    case `plus`
    case `minus`
    case `multiply`
    case `divide`
    case `modulo`

    // Punctuation
    case comma = 4000
    case dot

    // Delimeters
    case semicolon = 5000
    case lparen
    case rparen
    case lbrace
    case rbrace
    case lbracket
    case rbracket
  }

  /// The kind of token.
  public var kind: Kind

  /// The site from which token was extracted.
  public var site: SourceRange

  /// Creates an instance of token with given `kind` and `site`.
  public init(kind: Kind, site: SourceRange) {
    self.kind = kind
    self.site = site
  }
}

extension Token {
  public func isOf<T: Collection>(kind kinds: T) -> Bool where T.Element == Kind {
    kinds.contains(kind)
  }

  var isOperator: Bool {
    isOf(kind: [
      .not_equals, .equals, .greater_equals, .less_equals, .greater, .less, .assign, .plus, .minus,
      .multiply, .divide, .modulo,
    ])
  }
}
