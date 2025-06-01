extension Character {
  public var isDecDigit: Bool {
    guard let ascii = asciiValue else { return false }
    return (0x30...0x39) ~= ascii
  }
}
