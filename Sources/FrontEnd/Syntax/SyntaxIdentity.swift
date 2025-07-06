public protocol SyntaxIdentity {
  var id: Int { get }
}

public struct ExpressionIdentity: SyntaxIdentity {
  let id: Int

  init(_ id: Int) {
    self.id = id
  }
}

public struct StatementIdentity: SyntaxIdentity {
  let id: Int

  init(_ id: Int) {
    self.id = id
  }
}
