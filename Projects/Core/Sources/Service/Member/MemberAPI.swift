import Foundation

public enum MemberAPI {
  /// 마이페이지 조회
  case fetch(id: Int)
  /// 마이페이지 수정
  case update(id: Int, nickName: String, introduction: String)
  /// 회원 이미지 수정
  case updateImage(id: Int, data: Data, boundary: String = UUID().uuidString)
  /// 회원 이미지 삭제
  case deleteImage(id: Int)
  /// 회원탈퇴
  case delete(id: Int)
  /// 회원 차단
  case block(id: Int)
  /// 회원 차단 취소
  case unBlock(id: Int)
  /// 회원이 차단한 회원 목록 조회
  case fetchBlocks(id: Int, cursorId: Int?, size: Int)
  /// 회원이 작성한 투표 목록 조회
  case fetchVotes(id: Int, cursorId: Int?, size: Int)
  /// 회원이 평가한 투표 목록 조회
  case fetchEvaluations(id: Int, cursorId: Int?, size: Int)
  /// 회원이 북마크한 목록 조회
  case fetchBookmarks(id: Int, cursorId: Int?, size: Int)
}


// MARK: - Extension

extension MemberAPI: TargetType {
  
  public var path: String {
    switch self {
    case let .fetch(id):
      return "members/\(id)"
    case let .update(id, _, _):
      return "members/\(id)"
    case let .updateImage(id, _, _):
      return "members/\(id)/images"
    case let .deleteImage(id):
      return "members/\(id)/images"
    case let .delete(id):
      return "members/\(id)"
    case let .block(id):
      return "members/\(id)/blocks"
    case let .unBlock(id):
      return "members/\(id)/blocks"
    case let .fetchBlocks(id, cursorId, size):
      if let cursorId {
        return "members/\(id)/blocks?cursor-id=\(cursorId)&size=\(size)"
      } else {
        return "members/\(id)/blocks?size=\(size)"
      }
      
    case let .fetchVotes(id, cursorId, size):
      if let cursorId {
        return "members/\(id)/votes?cursor-id=\(cursorId)&size=\(size)"
      } else {
        return "members/\(id)/votes?size=\(size)"
      }
    case let .fetchEvaluations(id, cursorId, size):
      if let cursorId {
        return "members/\(id)/evaluations?cursor-id=\(cursorId)&size=\(size)"
      } else {
        return "members/\(id)/evaluations?size=\(size)"
      }
    case let .fetchBookmarks(id, cursorId, size):
      if let cursorId {
        return "members/\(id)/bookmarks?cursor-id=\(cursorId)&size=\(size)"
      } else {
        return "members/\(id)/bookmarks?size=\(size)"
      }
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .fetch:
      return .get
    case .update:
      return .put
    case .updateImage:
      return .post
    case .deleteImage:
      return .delete
    case .delete:
      return .delete
    case .block:
      return .post
    case .unBlock:
      return .delete
    case .fetchBlocks:
      return .get
    case .fetchVotes:
      return .get
    case .fetchEvaluations:
      return .get
    case .fetchBookmarks:
      return .get
    }
  }
  
  public var parameters: Encodable? {
    switch self {
    case .fetch:
      return nil
    case .update(_, let nickName, let introduction):
      return UpdateMemberRequestDTO(nickName: nickName, introduction: introduction)
    case .updateImage(_, let data, _):
      //return UpdateMemberImageRequestDTO(imageFile: data)
      return nil
    case .deleteImage:
      return nil
    case .delete:
      return nil
    case .block:
      return nil
    case .unBlock:
      return nil
    case .fetchBlocks:
      return nil
    case .fetchVotes:
      return nil
    case .fetchEvaluations:
      return nil
    case .fetchBookmarks:
      return nil
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .updateImage(_, _, let boundary):
      return [
        "Content-Type": "application/json; charset=UTF-8; boundary=\(boundary)",
        "Content-Disposition": "form-data",
        "Authorization": "Bearer \(UserDefaultsService.shared.accessToken ?? "")"
      ]

    default:
      return [
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer \(UserDefaultsService.shared.accessToken ?? "")"
      ]
    }
  }

  public var task: HTTPTask {
    switch self {
    case let .updateImage(_, data, boundary):
      let multipartFormData = MultipartFormData(boundary: boundary)
      multipartFormData.append(data, withName: "imageFile", fileName: "TestImage.jpg", mimeType: "image/jpeg")

      return .uploadMultipartFormData(multipartFormData)
    default:
      return .requestPlain
    }
  }
}
