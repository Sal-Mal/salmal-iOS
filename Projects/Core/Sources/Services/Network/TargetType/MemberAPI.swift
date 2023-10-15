import Foundation

public enum MemberAPI {
  /// 마이페이지 조회
  case fetch(id: Int)
  /// 마이페이지 수정
  case update(id: Int, nickName: String, introduction: String)
  /// 회원 이미지 수정
  case updateImage(id: Int, data: Data)
  /// 회원탈퇴
  case delete(id: Int)
  /// 회원 차단
  case block(id: Int)
  /// 회원 차단해제
  case unBlock(id: Int)
  /// 회원이 차단한 회원 목록 조회
  case fetchBlocks(id: Int, cursorId: Int, size: Int)
  /// 회원이 작성한 투표 목록 조회
  case fetchVotes(id: Int, cursorId: Int, size: Int)
  /// 회원이 투표한 목록 조회
  case fetchEvaluations(id: Int, cursorId: Int, size: Int)
  /// 회원이 북마크한 목록 조회
  case fetchBookmarks(id: Int, cursorId: Int, size: Int)
}


// MARK: - Extension

extension MemberAPI: TargetType {
  
  public var path: String {
    // TODO: - path
    switch self {
    case let .fetch(id):
      return "members/\(id)"
    case let .update(id, _, _):
      return "members/\(id)"
    case let .updateImage(id, _):
      return "members/\(id)/images"
    case let .delete(id):
      return "members/\(id)"
    case let .block(id):
      return "members/\(id)/blocks"
    case let .unBlock(id):
      return "members/\(id)/blocks"
    case let .fetchBlocks(id, cursorId, size):
      return "members/\(id)/blocks?cursor-id=\(cursorId)&size=\(size)"
    case let .fetchVotes(id, cursorId, size):
      return "members/\(id)/votes?cursor-id=\(cursorId)&size=\(size)"
    case let .fetchEvaluations(id, cursorId, size):
      return "members/\(id)/evaluations?cursor-id=\(cursorId)&size=\(size)"
    case let .fetchBookmarks(id, cursorId, size):
      return "members/\(id)/bookmarks?cursor-id=\(cursorId)&size=\(size)"
    }
  }
  
  public var method: HTTPMethod {
    // TODO: - type
    switch self {
    case .fetch:
      return .get
    case .update:
      return .put
    case .updateImage:
      return .post
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
      return UpdateMemberRequest(nickName: nickName, introduction: introduction)
    case .updateImage(_, let data):
      return UpdateMemberImageRequest(imageFile: data)
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
    return ["Authorization": "Bearer \(UDManager.shared.accessToken ?? "")"]
  }
}
