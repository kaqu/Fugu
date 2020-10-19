public protocol Feature {
  
  associatedtype Instance
  
  static func load(in container: FeatureContainer) -> Instance
}

internal extension Feature {
  static var identifier: TypeIdentifier { TypeIdentifier(Self.Type.self) }
}
