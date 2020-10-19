internal struct TypeIdentifier: Hashable {
  
  private let identifier: ObjectIdentifier
  
  internal init<T>(_ type: T.Type) {
    self.identifier = ObjectIdentifier(type)
  }
}
