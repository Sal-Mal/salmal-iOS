import SwiftUI
import UI

struct ColorView: View {
  var body: some View {
    List {
      Section("Black") {
        ColorExample(title: "Black", color: .ds(.black))
        ColorExample(title: "Gray1", color: .ds(.gray1))
        ColorExample(title: "Gray2", color: .ds(.gray2))
        ColorExample(title: "Gray3", color: .ds(.gray3))
        ColorExample(title: "Gray4", color: .ds(.gray4))
      }

      Section("Accent Colors") {
        ColorExample(title: "Green1", color: .ds(.green1))
        ColorExample(title: "Green2", color: .ds(.green2))
      }

      Section("White") {
        ColorExample(title: "White", color: .ds(.white))
        ColorExample(title: "White20", color: .ds(.white20))
        ColorExample(title: "White36", color: .ds(.white36))
        ColorExample(title: "White80", color: .ds(.white80))
      }

      Section("Rainbows") {
        ColorExample(title: "Red", color: .ds(.red))
        ColorExample(title: "Orange", color: .ds(.orange))
        ColorExample(title: "Yellow", color: .ds(.yellow))
        ColorExample(title: "Green", color: .ds(.green))
        ColorExample(title: "Blue", color: .ds(.blue))
        ColorExample(title: "Purple", color: .ds(.purple))
        ColorExample(title: "Apricot", color: .ds(.apricot))
      }
    }
    .navigationTitle("컬러")
  }
}

struct ColorExample: View {

  let title: String
  let color: Color

  var body: some View {
    HStack {
      RoundedRectangle(cornerRadius: 6)
        .stroke(.quaternary, lineWidth: 1)
        .background(color)
        .frame(width: 60, height: 60)

      Spacer()
      Text(title)
    }
  }
}

struct ColorView_Previews: PreviewProvider {
  static var previews: some View {
    ColorView()
  }
}
