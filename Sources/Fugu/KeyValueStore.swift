public struct KeyValueStore<Key: Hashable, Value> {
  public var get: (Key) -> Value
  public var set: (Key, Value) -> Void
}

#if canImport(UIKit)

import class UIKit.UserDefaults
import struct Foundation.Data

public extension KeyValueStore where Key == String, Value == Data? {
  
  static var userDefaults: KeyValueStore {
    .init(
      get: { key in
        UserDefaults.standard.data(forKey: key)
      },
      set: { key, value in
        UserDefaults.standard.setValue(value, forKey: key)
      }
    )
  }
}

public extension KeyValueStore where Key == String, Value == String? {
  
  static var userDefaults: KeyValueStore {
    .init(
      get: { key in
        UserDefaults.standard.string(forKey: key)
      },
      set: { key, value in
        UserDefaults.standard.setValue(value, forKey: key)
      }
    )
  }
}

public extension KeyValueStore where Key == String, Value == Int? {
  
  static var userDefaults: KeyValueStore {
    .init(
      get: { key in
        UserDefaults.standard.integer(forKey: key)
      },
      set: { key, value in
        UserDefaults.standard.setValue(value, forKey: key)
      }
    )
  }
}

public extension KeyValueStore where Key == String, Value == Bool? {
  
  static var userDefaults: KeyValueStore {
    .init(
      get: { key in
        UserDefaults.standard.bool(forKey: key)
      },
      set: { key, value in
        UserDefaults.standard.setValue(value, forKey: key)
      }
    )
  }
}

public extension KeyValueStore where Key == String, Value == Array<Any>? {
  
  static var userDefaults: KeyValueStore {
    .init(
      get: { key in
        UserDefaults.standard.array(forKey: key)
      },
      set: { key, value in
        UserDefaults.standard.setValue(value, forKey: key)
      }
    )
  }
}

public extension KeyValueStore where Key == String, Value == Dictionary<String, Any>? {
  
  static var userDefaults: KeyValueStore {
    .init(
      get: { key in
        UserDefaults.standard.dictionary(forKey: key)
      },
      set: { key, value in
        UserDefaults.standard.setValue(value, forKey: key)
      }
    )
  }
}

public extension KeyValueStore where Key == String, Value == Data? {
  
  static var keychain: KeyValueStore {
    .init(
      get: { key in
        fatalError()
      },
      set: { key, value in
        fatalError()
      }
    )
  }
}

#endif

