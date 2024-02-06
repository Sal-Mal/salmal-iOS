import SwiftUI
import UI
import Core

import Kingfisher

struct AlarmRow: View {
  
  let alarm: Alarm
  
  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      
      HStack(spacing: 5) {
        Circle()
          .fill(alarm.isRead ? .clear : .ds(.green))
          .frame(width: 5, height: 5)
        
        KFImage(URL(string: alarm.memberImageURL))
          .placeholder {
            ProgressView()
          }
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 38, height: 38)
          .clipShape(Circle())
      }
      
      VStack(alignment: .leading, spacing: 4) {
        Text(alarm.message)
          .font(.ds(.title4(.medium)))
          .foregroundColor(.ds(.white))
        Text(alarm.createdAt)
          .font(.ds(.title5))
          .foregroundColor(.ds(.gray1))
      }
      .padding(.leading, 15)
      
      Spacer()
      
      KFImage(URL(string: alarm.voteImageURL))
        .placeholder {
          ProgressView()
        }
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 54, height: 82)
        .cornerRadius(8)
        .padding(.leading, 27)
    }
    .frame(height: 105)
  }
}

struct AlarmRow_Previews: PreviewProvider {
  static var previews: some View {
    AlarmRow(alarm: AlarmResponseDTO.mock.toDomain[0])
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
  }
}
