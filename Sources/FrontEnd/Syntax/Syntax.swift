/// Any node in Syntax Tree should be a syntax.
public protocol Syntax {
  var site: SourceRange { get }
}

extension Syntax {
  var text: Substring {
    site.text
  }
}
