public protocol Property {
  
  associatedtype Value
  
  static var defaultValue: Value { get }
}

internal extension Property {
  
  static var identifier: TypeIdentifier { TypeIdentifier(Self.Type.self) }
}
