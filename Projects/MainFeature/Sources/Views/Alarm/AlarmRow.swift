import SwiftUI
import UI

struct AlarmRow: View {
    var body: some View {
      HStack(alignment: .top, spacing: 0) {
        CacheAsyncImage(
          url: URL(string: "https://picsum.photos/100")!) { phase in
            switch phase {
            case let .success(image):
              image
                .fit(size: 38)
                .clipShape(Circle())
            default:
              Circle()
                .fill(Color.ds(.gray1))
                .frame(width: 38)
            }
          }
        
        VStack(alignment: .leading, spacing: 4) {
          Text("feroldis님의 답댓글: ㅋㅋㅋㅋㅋㅋㅋㅋ 살말결과 보니까 사고싶은 마음이 약간 사라졌어요...")
            .font(.ds(.title4(.medium)))
            .foregroundColor(.ds(.white))
          Text("2시간 전")
            .font(.ds(.title5))
            .foregroundColor(.ds(.gray1))
        }
        .padding(.leading, 15)
        
        CacheAsyncImage(
          url: URL(string: "https://picsum.photos/300/600")!) { phase in
            switch phase {
            case let .success(image):
              image
                .resizable()
                .frame(width: 54, height: 82)
                .cornerRadius(8)
            default:
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.ds(.gray1))
                .frame(width: 54, height: 82)
            }
          }
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
