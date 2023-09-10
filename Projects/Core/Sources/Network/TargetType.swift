public protocol TargetType {
  var baseURL: String { get set }
  var path: String { get set }
  var method: HTTPMethod { get set }
  var parameters: Parameters { get set }
  var headers: HTTPHeaders { get set }
}
