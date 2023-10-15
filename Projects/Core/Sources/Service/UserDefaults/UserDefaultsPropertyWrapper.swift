import Foundation

@propertyWrapper
public struct UserDefault<T> {
  private let key: UserDefaultsKey
  private let defaultValue: T?
  
  init(key: UserDefaultsKey, defaultValue: T? = nil) {
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
