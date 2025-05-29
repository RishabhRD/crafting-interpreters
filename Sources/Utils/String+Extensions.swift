extension String {
  /// Returns the indices of the start of each line, in order.
  public func lineBoundaries() -> [Index] {
    var r = [startIndex]
    var remainder = self[...]
    while !remainder.isEmpty, let i = remainder.firstIndex(where: \.isNewline) {
      let j = index(after: i)
      r.append(j)
      remainder = remainder[j...]
    }
    return r
  }
}
