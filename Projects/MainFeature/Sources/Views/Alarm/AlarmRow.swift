import SwiftUI
import UI

import Kingfisher

struct AlarmRow: View {
    var body: some View {
      HStack(alignment: .top, spacing: 0) {
        KFImage(URL(string: "https://picsum.photos/100"))
          .placeholder {
            ProgressView()
          }
          .resizable()
          .frame(width: 38, height: 38)
          .clipShape(Circle())
        
        VStack(alignment: .leading, spacing: 4) {
          Text("feroldis님의 답댓글: ㅋㅋㅋㅋㅋㅋㅋㅋ 살말결과 보니까 사고싶은 마음이 약간 사라졌어요...")
            .font(.ds(.title4(.medium)))
            .foregroundColor(.ds(.white))
          Text("2시간 전")
            .font(.ds(.title5))
            .foregroundColor(.ds(.gray1))
        }
        .padding(.leading, 15)
        
        KFImage(URL(string: "https://picsum.photos/300/600"))
          .placeholder {
            ProgressView()
          }
          .resizable()
          .frame(width: 54, height: 82)
          .cornerRadius(8)
          .padding(.leading, 27)
      }
      .frame(height: 105)
    }
}

struct AlarmRow_Previews: PreviewProvider {
    static var previews: some View {
        AlarmRow()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
