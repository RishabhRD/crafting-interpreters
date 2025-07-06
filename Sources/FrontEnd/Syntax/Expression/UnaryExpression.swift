public struct UnaryExpression: Expression {
  public enum OperatorType {
    case `not`
    case `minus`
  }

  /// Unary operator.
  var op: OperatorType

  /// Expression on which unary operation is applied.
  var expr: ExpressionIdentity
}
