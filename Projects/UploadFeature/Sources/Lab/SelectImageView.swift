import SwiftUI

import UI

public struct SelectImageView: View {

  @State var images: [UIImage] = []

  public init() {}

  public var body: some View {
    VStack {
      HStack {
        Button {

        } label: {
          Text("최근")
            .font(.ds(.title4(.medium)))
            .foregroundColor(.ds(.white))
          Image(systemName: "chevron.down")
            .resizable()
            .scaledToFit()
            .frame(width: 10, height: 10)
            .foregroundColor(.ds(.white))
        }

        Spacer()
      }
      .padding(.vertical, 6)
      .padding(.horizontal, 18)

      ScrollView {
        LazyVGrid(columns: [.init(), .init(), .init()]) {
          ForEach(Array(images.enumerated()), id: \.offset) { index, image in

            if index == 0 {
              Button {

              } label: {
                Rectangle()
                  .fill(Color.ds(.black))
                  .aspectRatio(0.64, contentMode: .fit)
                  .cornerRadius(6)
                  .overlay {
                    VStack(spacing: 5) {
                      Image(icon: .camera)
                      Text("촬영")
                        .font(.ds(.title4(.medium)))
                        .foregroundColor(.ds(.white))
                    }
                  }
              }

            } else {
              Image(uiImage: image)
                .resizable()
                .aspectRatio(0.64, contentMode: .fit)
                .cornerRadius(6)
            }
          }
        }
        .padding(.horizontal, 5)
      }
    }
    .task {
      let images = await PhotoService.shared.albums(size: .init(width: 100, height: 100))
      self.images = images
    }
    .smNavigationBar(title: "사진 추가", rightItems: {
      Image(systemName: "xmark")
        .resizable()
        .frame(width: 14, height: 14)
        .foregroundColor(.white)
    })
  }
}

struct SelectImageView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      SelectImageView()
    }
    .preferredColorScheme(.dark)
  }
}
