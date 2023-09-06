import SwiftUI

extension Font {

  public static func pretendard(_ weight: SM.Font.PretendardWeight, size: CGFloat) -> Font {
    return SM.Font.pretendard(weight, size: size)
  }

  public static func binggrae(size: CGFloat) -> Font {
    return SM.Font.binggrae(size: size)
  }

  public static func gabiaSolmee(size: CGFloat) -> Font {
    return SM.Font.gabiaSolmee(size: size)
  }

  public static func maruBuri(size: CGFloat) -> Font {
    return SM.Font.maruBuri(size: size)
  }

  public static func ttTogether(size: CGFloat) -> Font {
    return SM.Font.ttTogether(size: size)
  }

  public static func twaySky(size: CGFloat) -> Font {
    return SM.Font.twaySky(size: size)
  }

  public static func ds(_ style: SM.Font.PretendardStyle) -> Font {
    switch style {
    case .title1:
      return .pretendard(.bold, size: 24)
    case .title2:
      return .pretendard(.semiBold, size: 20)
    case .title3:
      return .pretendard(.medium, size: 16)
    case .title4:
      return .pretendard(.medium, size: 13)
    case .title5:
      return .pretendard(.medium, size: 11)
    }
  }
}
