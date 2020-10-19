import class Foundation.NSRecursiveLock

public struct Randomness {
  
  public typealias Unit = UInt64
  
  @usableFromInline internal var randomness: () -> Unit
  
  public init(randomness: @escaping () -> Unit) {
    self.randomness = randomness
  }
}

extension Randomness: RandomNumberGenerator {
  
  @inlinable public func next() -> Unit { randomness() }
  
  public var rng: RandomNumberGenerator { self }
}

extension Randomness: Feature {
  
  public static func load(in container: FeatureContainer)  -> Self {
    .system
  }
}

extension FeatureContainer {
  
  var randomness: Randomness {
    get { self[Randomness.self] }
    set { self[Randomness.self] = newValue }
  }
}

public extension Randomness {
  
  @inlinable static var system: Self {
    var rng = SystemRandomNumberGenerator()
    return Self { rng.next() }
  }
  
  @inlinable static func linearCongruential(
    withSeed seed: Unit = Unit.random(in: .min ... .max)
  ) -> Self {
    let lock = NSRecursiveLock()
    var seed = seed
    return Self {
      lock.lock()
      defer { lock.unlock() }
      seed = 2862933555777941757 &* seed &+ 3037000493
      return seed
    }
  }
  
  @inlinable static func constant(
    _ constant: Unit
  ) -> Self {
    Self { constant }
  }
}

public extension Randomness {
  
  @inlinable func random<Value>(of enum: Value.Type) -> Value where Value: CaseIterable {
    precondition(!Value.allCases.isEmpty, "Cannot use empty enum")
    var randomness = self // it has to be mutable reference to be passed as inout but we don't mutate it anyway
    return Value.allCases.randomElement(using: &randomness)!
  }
  
  @inlinable func random<Values>(from values: Values) -> Values.Element where Values: Collection {
    precondition(!values.isEmpty, "Cannot use empty values collection")
    var randomness = self // it has to be mutable reference to be passed as inout but we don't mutate it anyway
    return values.randomElement(using: &randomness)!
  }
  
  @inlinable func random<Value>(in values: Range<Value>) -> Value where Value: Strideable, Value.Stride: SignedInteger {
    precondition(!values.isEmpty, "Cannot use empty values range")
    var randomness = self // it has to be mutable reference to be passed as inout but we don't mutate it anyway
    return values.randomElement(using: &randomness)!
  }
}
