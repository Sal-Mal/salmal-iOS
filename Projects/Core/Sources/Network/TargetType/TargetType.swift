public protocol TargetType {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: Parameters { get }
  var headers: HTTPHeaders { get }
}
