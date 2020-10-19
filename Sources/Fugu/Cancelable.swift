#if canImport(Combine)

import protocol Combine.Cancellable

#else

public protocol Cancellable {
  
  func cancel()
}

#endif

internal final class Cancelation {
  
  private let cancelation: () -> Void
  
  internal init(_ cancelation: @escaping () -> Void) {
    self.cancelation = cancelation
  }
}

extension Cancelation: Cancellable {
  
  func cancel() {
    cancelation()
  }
}
