import SwiftUI
import CoreImage

struct FilteredImage: Equatable, Identifiable {
  let id: String = UUID().uuidString
  let image: UIImage
  let filter: CIFilter
}
