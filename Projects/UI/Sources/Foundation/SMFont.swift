import UIKit
import SwiftUI

extension SM {

  public enum Font {

    public static func initFonts() {
      SM.Font.Family.registerAllCustomFonts()
    }

    public enum Style {
      public enum Weight {
        case medium
        case semibold

        var pretendardWeght: PretendardWeight {
          switch self {
          case .medium:
            return .medium

          case .semibold:
            return .semiBold
          }
        }
      }

      case title
      case title1
      case title2(Weight)
      case title3(Weight)
      case title4(Weight)
      case title5
    }

    public enum PretendardWeight {
      case black
      case bold
      case extraBold
      case extraLight
      case light
      case medium
      case regular
      case semiBold
      case thin

      var name: String {
        switch self {
        case .black:
          return SM.Font.Family.Pretendard.black.name
        case .bold:
          return SM.Font.Family.Pretendard.bold.name
        case .extraBold:
          return SM.Font.Family.Pretendard.extraBold.name
        case .extraLight:
          return SM.Font.Family.Pretendard.extraLight.name
        case .light:
          return SM.Font.Family.Pretendard.light.name
        case .medium:
          return SM.Font.Family.Pretendard.medium.name
        case .regular:
          return SM.Font.Family.Pretendard.regular.name
        case .semiBold:
          return SM.Font.Family.Pretendard.semiBold.name
        case .thin:
          return SM.Font.Family.Pretendard.thin.name
        }
      }
    }

    public static func pretendard(_ weight: SM.Font.PretendardWeight, size: CGFloat) -> SwiftUI.Font {
      return SwiftUI.Font.custom(weight.name, size: size)
    }
    
    public static func blackHanSans(size: CGFloat) -> SwiftUI.Font {
      return .custom(SM.Font.Family.BlackHanSans.regular.name, size: size)
    }

    public static func binggrae(size: CGFloat) -> SwiftUI.Font {
      return .custom(SM.Font.Family.Binggrae.regular.name, size: size)
    }

    public static func gabiaSolmee(size: CGFloat) -> SwiftUI.Font {
      return .custom(SM.Font.Family.GabiaSolmee.regular.name, size: size)
    }

    public static func maruBuri(size: CGFloat) -> SwiftUI.Font {
      return .custom(SM.Font.Family.MaruBuriOTF.light.name, size: size)
    }

    public static func ttTogether(size: CGFloat) -> SwiftUI.Font {
      return .custom(SM.Font.Family.TTTogether.regular.name, size: size)
    }

    public static func twaySky(size: CGFloat) -> SwiftUI.Font {
      return .custom(SM.Font.Family.TwaySky.regular.name, size: size)
    }
  }
}


// MARK: - Extension

extension SM.Font {

  enum Family {
    
    enum BlackHanSans {
      static let regular = FontConvertible(name: "BlackHanSans-Regular", family: "BlackHanSans", path: "BlackHanSans-Regular.ttf")
      static let all: [FontConvertible] = [regular]
    }

    enum Binggrae {
      static let regular = FontConvertible(name: "Binggrae", family: "Binggrae", path: "Binggrae.otf")
      static let all: [FontConvertible] = [regular]
    }

    enum GabiaSolmee {
      static let regular = FontConvertible(name: "GabiaSolmee-Regular", family: "Gabia Solmee", path: "gabia_solmee.otf")
      static let all: [FontConvertible] = [regular]
    }

    enum MaruBuriOTF {
      static let light = FontConvertible(name: "MaruBuriot-Light", family: "MaruBuriOTF", path: "MaruBuri-Light.otf")
      static let all: [FontConvertible] = [light]
    }

    enum Pretendard {
      static let black = FontConvertible(name: "Pretendard-Black", family: "Pretendard", path: "Pretendard-Black.otf")
      static let bold = FontConvertible(name: "Pretendard-Bold", family: "Pretendard", path: "Pretendard-Bold.otf")
      static let extraBold = FontConvertible(name: "Pretendard-ExtraBold", family: "Pretendard", path: "Pretendard-ExtraBold.otf")
      static let extraLight = FontConvertible(name: "Pretendard-ExtraLight", family: "Pretendard", path: "Pretendard-ExtraLight.otf")
      static let light = FontConvertible(name: "Pretendard-Light", family: "Pretendard", path: "Pretendard-Light.otf")
      static let medium = FontConvertible(name: "Pretendard-Medium", family: "Pretendard", path: "Pretendard-Medium.otf")
      static let regular = FontConvertible(name: "Pretendard-Regular", family: "Pretendard", path: "Pretendard-Regular.otf")
      static let semiBold = FontConvertible(name: "Pretendard-SemiBold", family: "Pretendard", path: "Pretendard-SemiBold.otf")
      static let thin = FontConvertible(name: "Pretendard-Thin", family: "Pretendard", path: "Pretendard-Thin.otf")
      static let all: [FontConvertible] = [black, bold, extraBold, extraLight, light, medium, regular, semiBold, thin]
    }

    enum TTTogether {
      static let regular = FontConvertible(name: "TTTogether", family: "TTTogether", path: "TTTogether.ttf")
      static let all: [FontConvertible] = [regular]
    }

    enum TwaySky {
      static let regular = FontConvertible(name: "twaysky", family: "tway_sky", path: "tway_sky.ttf")
      static let all: [FontConvertible] = [regular]
    }

    static let allCustomFonts: [FontConvertible] = [
      BlackHanSans.all, Binggrae.all, GabiaSolmee.all, MaruBuriOTF.all, Pretendard.all, TTTogether.all, TwaySky.all
    ].flatMap { $0 }

    static func registerAllCustomFonts() {
      allCustomFonts.forEach { $0.register() }
    }
  }
}


extension SM.Font {

  struct FontConvertible {

    typealias Font = UIFont

    let name: String
    let family: String
    let path: String

    var url: URL? {
      return SM.bundle.url(forResource: path, withExtension: nil)
    }

    func register() {
      guard let url = url else { return }

      /// 프로세스를 사용하고 있는 동안 해당 번들/Path의 폰트를 등록 (Info.plist에 등록 X)
      CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
  }
}


extension SM.Font.FontConvertible.Font {

  convenience init?(font: SM.Font.FontConvertible, size: CGFloat) {
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }

    self.init(name: font.name, size: size)
  }
}
