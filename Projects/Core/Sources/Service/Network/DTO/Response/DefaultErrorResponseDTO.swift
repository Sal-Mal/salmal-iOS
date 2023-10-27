import Foundation

/*
 {
     "message": "중복된 닉네임이 존재합니다.",
     "code": 1005
 }
 */

// StatusCode가 200...299가 아닐때 내려오는 Response
public struct DefaultErrorResponseDTO {
  let message: String
  let code: Int
}

extension DefaultErrorResponseDTO: Responsable {
  public static var mock: DefaultErrorResponseDTO {
    fatalError()
  }
}


