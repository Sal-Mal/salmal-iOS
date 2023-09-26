import Alamofire
import Foundation

public protocol TargetType: URLRequestConvertible {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: Encodable? { get }
  var headers: [String: String]? { get }
}

extension TargetType {
  public func asURLRequest() throws -> URLRequest {
    let url = URL(string: baseURL + "/" + path)!
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = parameters?.toJsonData()
    
    
    print("** Reuqest URL: ", url.absoluteString)
    
    return request
  }
}

extension Encodable {
  func toJsonData() -> Data? {
    return try? JSONEncoder().encode(self)
  }
}
