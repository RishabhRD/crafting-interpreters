/// Storage of all nodes in AST.
public struct SyntaxTreeStorage {
  /// All expression in AST
  private var expressions: [Expression]

  /// All statements in AST
  private var statements: [Statement]

  /// Insert given node in storage and return unique id of the same.
  public mutating func insert(expression node: Expression) -> ExpressionIdentity {
    let id = ExpressionIdentity(expressions.count)
    expressions.append(node)
    return id
  }

  /// Insert given node in storage and return unique id of the same.
  public mutating func insert(statement node: Statement) -> StatementIdentity {
    let id = StatementIdentity(statements.count)
    expressions.append(node)
    return id
  }

  /// Return expression with given id.
  ///
  /// - Precondition: ExpressionIdentity should be issued from `self` in past.
  public func get(expression id: ExpressionIdentity) -> Expression {
    expressions[id.id]
  }

  /// Return statement with given id.
  ///
  /// - Precondition: StatementIdentity should be issued from `self` in past.
  public func get(statement id: ExpressionIdentity) -> Statement {
    statements[id.id]
  }
}
