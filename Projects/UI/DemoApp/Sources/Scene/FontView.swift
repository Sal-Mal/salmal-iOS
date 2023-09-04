import SwiftUI
import UI

struct FontView: View {
    var body: some View {
      List {
        Section("Pretendard") {
          Text("Pretendard Thin 20")
            .font(.pretendard(.thin, size: 20))
          Text("Pretendard ExtraLight 20")
            .font(.pretendard(.extraLight, size: 20))
          Text("Pretendard Light 20")
            .font(.pretendard(.light, size: 20))
          Text("Pretendard Regular 20")
            .font(.pretendard(.regular, size: 20))
          Text("Pretendard Medium 20")
            .font(.pretendard(.medium, size: 20))
          Text("Pretendard SemiBold 20")
            .font(.pretendard(.semiBold, size: 20))
          Text("Pretendard Bold 20")
            .font(.pretendard(.bold, size: 20))
          Text("Pretendard ExtraBold 20")
            .font(.pretendard(.extraBold, size: 20))
          Text("Pretendard Black 20")
            .font(.pretendard(.black, size: 20))
        }

        Section("Custom") {
          Text("Binggrae 20")
            .font(.binggrae(size: 20))
          Text("GabiaSolmee 20")
            .font(.gabiaSolmee(size: 20))
          Text("MaruBuri 20")
            .font(.maruBuri(size: 20))
          Text("TTTogether 20")
            .font(.ttTogether(size: 20))
          Text("TwaySky 20")
            .font(.twaySky(size: 20))
        }
      }
      .navigationTitle("Fonts")
    }
}

struct FontView_Previews: PreviewProvider {
    static var previews: some View {
        FontView()
    }
}
