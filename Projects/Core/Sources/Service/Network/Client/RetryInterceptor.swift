import Alamofire

final class RetryInterceptor: RequestInterceptor {
  
  private let retryLimit: Int
  
  init(retryLimit: Int) {
    self.retryLimit = retryLimit
  }

  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    guard let response = request.response else {
      return completion(.doNotRetryWithError(SMError.network(.invalidResponse)))
    }
    
    switch response.statusCode {
    case 200..<300:
      return completion(.doNotRetry)
    default:
      if request.retryCount < retryLimit {
        return completion(.retry)
      } else {
        return completion(.doNotRetryWithError(SMError.network(.invalidResponse)))
      }
    }
  }
}
