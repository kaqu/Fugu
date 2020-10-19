import class Foundation.NSRecursiveLock
import struct Foundation.UUID

#if canImport(Combine)
import protocol Combine.Cancellable
#endif

@dynamicMemberLookup
public final class Container {
  
  public static let shared: Container = .init()
  
  fileprivate let lock: NSRecursiveLock = .init()
  fileprivate var store: Dictionary<TypeIdentifier, Any> = .init()
  fileprivate var observers: Dictionary<TypeIdentifier, Dictionary<UUID, (Any) -> Void>> = .init()
  
  public init() {}
  
  public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Container, Value>) -> Value {
    get { self[keyPath: keyPath] }
    set { self[keyPath: keyPath] = newValue }
  }
  
  public subscript<Value>(keyPath: ReferenceWritableKeyPath<Container, Value>) -> Value {
    get { self[keyPath: keyPath] }
    set { self[keyPath: keyPath] = newValue }
  }
}

extension Container: FeatureContainer {
  
  public subscript<P: Property>(property: P.Type) -> P.Value {
    get {
      lock.lock()
      defer { lock.unlock() }
      if let value = store[property.identifier] as? P.Value {
        return value
      } else {
        let value = property.defaultValue
        store[property.identifier] = value
        observers[property.identifier]?.forEach { $1(value) }
        return value
      }
    }
    set {
      lock.lock()
      store[property.identifier] = newValue
      observers[property.identifier]?.forEach { $1(newValue) }
      lock.unlock()
    }
  }
  
  public subscript<F: Feature>(feature: F.Type) -> F.Instance {
    get {
      lock.lock()
      defer { lock.unlock() }
      if let instance = store[feature.identifier] as? F.Instance {
        return instance
      } else {
        let instance = feature.load(in: self)
        store[feature.identifier] = instance
        observers[feature.identifier]?.forEach { $1(instance) }
        return instance
      }
    }
    set {
      lock.lock()
      store[feature.identifier] = newValue
      observers[feature.identifier]?.forEach { $1(newValue) }
      lock.unlock()
    }
  }
}


public extension Container {
  
  func observe<P: Property>(
    _ property: P.Type,
    observer: @escaping (P.Value) -> Void
  ) -> Cancellable {
    lock.lock()
    defer { lock.unlock() }
    let uuid = UUID()
    let observer: (Any) -> Void = { ($0 as? P.Value).map(observer) }
    if var dict = observers[property.identifier] {
      dict[uuid] = observer
      observers[property.identifier] = dict
    } else {
      observers[property.identifier] = [uuid: observer]
    }
    return Cancelation { [weak self] in
      guard let self = self else { return }
      self.lock.lock()
      defer { self.lock.unlock() }
      if var dict = self.observers[property.identifier] {
        dict[uuid] = nil
        self.observers[property.identifier] = dict
      }
    }
  }
  
  func observe<F: Feature>(
    _ feature: F.Type,
    observer: @escaping (F.Instance) -> Void
  ) -> Cancellable {
    lock.lock()
    defer { lock.unlock() }
    let uuid = UUID()
    let observer: (Any) -> Void = { ($0 as? F.Instance).map(observer) }
    if var dict = observers[feature.identifier] {
      dict[uuid] = observer
      observers[feature.identifier] = dict
    } else {
      observers[feature.identifier] = [uuid: observer]
    }
    return Cancelation { [weak self] in
      guard let self = self else { return }
      self.lock.lock()
      defer { self.lock.unlock() }
      if var dict = self.observers[feature.identifier] {
        dict[uuid] = nil
        self.observers[feature.identifier] = dict
      }
    }
  }
  
  func reset<P: Property>(_ property: P.Type) {
    lock.lock()
    let value = property.defaultValue
    store[property.identifier] = value
    observers[property.identifier]?.forEach { $1(value) }
    lock.unlock()
  }
  
  func reset<F: Feature>(_ feature: F.Type) {
    lock.lock()
    store[feature.identifier] = nil
    lock.unlock()
  }
}
