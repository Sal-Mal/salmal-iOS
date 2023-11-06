import Foundation
import UIKit

public struct UploadMenu: Equatable, Identifiable {

  enum MenuType {
    case camera
    case library
  }

  public let id: UUID = UUID()
  let type: MenuType
  var uiImage: UIImage?
}
