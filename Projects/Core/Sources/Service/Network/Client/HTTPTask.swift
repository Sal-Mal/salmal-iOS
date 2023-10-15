import Foundation

public enum HTTPTask {

  case requestPlain

  case uploadMultipartFormData(MultipartFormData)

}
