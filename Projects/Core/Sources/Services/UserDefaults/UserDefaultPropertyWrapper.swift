import Foundation

@propertyWrapper
public struct UD<T> {
  private let key: UDKey
  private let defaultValue: T?
  
  init(key: UDKey, defaultValue: T? = nil) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  public var wrappedValue: T? {
    get {
      return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key.rawValue)
    }
  }
}
