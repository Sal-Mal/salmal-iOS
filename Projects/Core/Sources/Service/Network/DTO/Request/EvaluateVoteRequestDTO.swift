import Foundation

/// 투표 평가
public struct EvaluateVoteRequestDTO: Encodable {
  public enum `Type`: String, Encodable {
    case like = "LIKE"
    case dislike = "DISLIKE"
    case none = "NONE"
  }
  
  let voteEvaluationType: `Type`
  
  public init(voteEvaluationType: Type) {
    self.voteEvaluationType = voteEvaluationType
  }
}
