import struct Foundation.UUID

extension UUID: Property {
  
  public static var defaultValue: UUID { .init() }
}

extension PropertyContainer {
  
  var uuid: UUID {
    get { self[UUID.self] }
    set { self[UUID.self] = newValue }
  }
}
