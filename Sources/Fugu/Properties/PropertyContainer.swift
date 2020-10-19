public protocol PropertyContainer {
  
  subscript<P: Property>(property: P.Type) -> P.Value { get set }
}
