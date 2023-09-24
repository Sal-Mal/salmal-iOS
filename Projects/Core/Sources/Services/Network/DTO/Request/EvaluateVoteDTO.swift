import Foundation

/// 투표 평가
public struct EvaluateVoteDTO: Encodable {
  public enum `Type`: String, Encodable {
    case like = "like"
    case dislike = "dislike"
    case none = "none"
  }
  
  let evaluationType: `Type`
}
