import struct Foundation.TimeInterval
import struct Darwin.timeval
import func Darwin.gettimeofday
import let Darwin.USEC_PER_SEC

public struct Timestamp {
  
  private let timestamp: () -> TimeInterval
  public var now: TimeInterval { timestamp() }
  
  public init(_ timestamp: @escaping () -> TimeInterval) {
    self.timestamp = timestamp
  }
}

extension Timestamp: Feature {
  
  public static func load(in container: FeatureContainer) -> Timestamp {
    .system
  }
}

extension FeatureContainer {
  
  var timestamp: Timestamp {
    get { self[Timestamp.self] }
    set { self[Timestamp.self] = newValue }
  }
}

public extension Timestamp {
  
  @inlinable static var system: Self {
    Self {
      var tv = timeval()
      gettimeofday(&tv, nil)
      return Double(tv.tv_sec) + Double(tv.tv_usec) / Double(USEC_PER_SEC)
    }
  }
  
  @inlinable static func constant(_ value: TimeInterval) -> Self {
    Self { value }
  }
}
