import SwiftUI

import UI
import Kingfisher

struct ProfileCell: View {
  
  let imageURL: String
  let action: () -> Void
  
  var body: some View {
    KFImage(URL(string: imageURL))
      .placeholder {
        RoundedRectangle(cornerRadius: 24.0)
          .fill(.gray)
          .aspectRatio(1, contentMode: .fill)
      }
      .resizable()
      .aspectRatio(1, contentMode: .fill)
      .cornerRadius(24.0)
      .onTapGesture {
        action()
      }
  }
}
