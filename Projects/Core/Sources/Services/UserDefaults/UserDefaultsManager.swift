import Foundation

@propertyWrapper
struct UserDefault<T> {
  private let key: String
//  private let defaultValue: T
  
  var wrappedValue: T? {
    get {
      return UserDefaults.standard.object(forKey: key) as? T
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}
