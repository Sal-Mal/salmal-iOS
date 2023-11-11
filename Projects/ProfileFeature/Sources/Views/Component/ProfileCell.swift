import SwiftUI

import UI

struct ProfileCell: View {

  let imageURL: String
  let action: () -> Void

  var body: some View {
    if let url = URL(string: imageURL) {
      CacheAsyncImage(url: url) { phase in
        switch phase {
        case .success(let image):
          image
            .resizable()
            .aspectRatio(1, contentMode: .fill)
            .cornerRadius(24.0)
            .onTapGesture {
              action()
            }

        default:
          RoundedRectangle(cornerRadius: 24.0)
            .fill(.gray)
            .aspectRatio(1, contentMode: .fill)
        }
      }
    } else {
      RoundedRectangle(cornerRadius: 24.0)
        .fill(.gray)
        .aspectRatio(1, contentMode: .fill)
    }
  }
}
