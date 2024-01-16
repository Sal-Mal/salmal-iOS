import Alamofire
import Foundation

public protocol TargetType: URLRequestConvertible {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: Encodable? { get }
  var headers: [String: String]? { get }
  var task: HTTPTask { get }
}

extension TargetType {

  public var baseURL: String {
    return "https://api.sal-mal.com/api"
  }

  public func asURLRequest() throws -> URLRequest {
    let url = URL(string: baseURL + "/" + path)!
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers
    request.httpBody = parameters?.toJsonData()

    print()
    debugPrint("****************** Network ******************")
    debugPrint("Reuqest URL: ", url.absoluteString)
    debugPrint("HttpMethod: ", method.rawValue)
    debugPrint("Parameters: ", parameters)
    debugPrint("Headers: ", headers)
    
    return request
  }
}

extension Encodable {
  func toJsonData() -> Data? {
    return try? JSONEncoder().encode(self)
  }
}
