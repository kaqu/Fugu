public protocol FeatureContainer: PropertyContainer {

  subscript<F: Feature>(feature: F.Type) -> F.Instance { get set }
}
