import SwiftUI
import CoreImage

public struct FilteredImage: Equatable, Identifiable {
  public let id: String = UUID().uuidString
  let image: UIImage
  let filter: CIFilter
}
