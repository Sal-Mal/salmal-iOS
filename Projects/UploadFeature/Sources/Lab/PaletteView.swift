import SwiftUI

import UI

public struct CircleView: View {

  let color: Color

  public var body: some View {
    Circle()
      .fill(color)
      .frame(width: 32, height: 32)
      .overlay {
        Circle()
          .stroke(lineWidth: 2)
          .foregroundColor(Color.ds(.white))
          .frame(width: 32, height: 32)
      }
  }
}

public struct RainbowCircleView: View {

  let paletteType: PaletteView.PaletteType

  public var body: some View {
    switch paletteType {
    case .font:
      Circle()
        .fill(Color.ds(.white))
        .frame(width: 32, height: 32)
        .overlay {
          Text("Aa")
            .font(.pretendard(.semiBold, size: 16))
            .foregroundColor(.ds(.black))
        }

    case .color:
      Circle()
        .fill(.angularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center, startAngle: .degrees(90), endAngle: .degrees(450)))
        .frame(width: 32, height: 32)
        .overlay {
          Circle()
            .stroke(lineWidth: 2)
            .foregroundColor(Color.ds(.white))
            .frame(width: 32, height: 32)
        }

    case .background:
      Circle()
        .fill(.angularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center, startAngle: .degrees(90), endAngle: .degrees(450)))
        .frame(width: 32, height: 32)
        .overlay {
          Circle()
            .stroke(lineWidth: 2)
            .foregroundColor(Color.ds(.white))
            .frame(width: 32, height: 32)
        }
        .overlay {
          Text("Aa")
            .font(.pretendard(.semiBold, size: 16))
            .foregroundColor(.ds(.white))
        }
    }
  }
}

public struct PaletteView: View {

  enum PaletteType {
    case font
    case color
    case background
  }


  struct ColorModel: Identifiable {
    let id: UUID = .init()
    let color: Color
  }


  private let foregroundColors: [ColorModel] = [
    .init(color: .ds(.white)),
    .init(color: .ds(.black)),
    .init(color: .ds(.red)),
    .init(color: .ds(.orange)),
    .init(color: .ds(.yellow)),
    .init(color: .ds(.green)),
    .init(color: .ds(.blue)),
    .init(color: .ds(.purple)),
    .init(color: .ds(.apricot))
  ]

  private let backgroundColors: [ColorModel] = [
    .init(color: .clear),
    .init(color: .ds(.white)),
    .init(color: .ds(.black)),
    .init(color: .ds(.red)),
    .init(color: .ds(.orange)),
    .init(color: .ds(.yellow)),
    .init(color: .ds(.green)),
    .init(color: .ds(.blue)),
    .init(color: .ds(.purple)),
    .init(color: .ds(.apricot))
  ]

  private let fonts: [Font] = [
    .pretendard(.semiBold, size: 16),
    .maruBuri(size: 16),
    .ttTogether(size: 15),
    .twaySky(size: 15),
    .binggrae(size: 15),
    .gabiaSolmee(size: 15)
  ]

  @State private var paletteType: PaletteType = .font

  @Binding var selectedFont: Font
  @Binding var selectedForegroundColor: Color
  @Binding var selectedBackgroundColor: Color

  public var body: some View {
    HStack(spacing: 20) {
      Button {
        changePaletteType(paletteType)
      } label: {
        RainbowCircleView(paletteType: paletteType)
      }

      Rectangle()
        .fill(Color.ds(.white80))
        .frame(width: 2, height: 20)
        .clipShape(Capsule())

      switch paletteType {
      case .font:
        ScrollView(.horizontal) {
          HStack(spacing: 6) {
            ForEach(fonts, id: \.self) { font in
              Button {
                selectedFont = font
              } label: {
                Circle()
                  .fill(Color.ds(.white))
                  .frame(width: 32, height: 32)
                  .overlay {
                    Text("Aa")
                      .foregroundColor(.ds(.black))
                      .font(font)
                  }
                  .frame(width: 50, height: 50)
              }
              .buttonStyle(.plain)
            }
          }
        }
        .scrollIndicators(.hidden)

      case .color:
        ScrollView(.horizontal) {
          HStack(spacing: 6) {
            ForEach(foregroundColors) { colorModel in
              Button {
                selectedForegroundColor = colorModel.color
              } label: {
                CircleView(color: colorModel.color)
                  .frame(width: 50, height: 50)
              }
              .buttonStyle(.plain)
            }
          }
        }
        .scrollIndicators(.hidden)

      case .background:
        ScrollView(.horizontal) {
          HStack(spacing: 6) {
            ForEach(backgroundColors) { colorModel in
              Button {
                selectedBackgroundColor = colorModel.color
              } label: {
                if colorModel.color == .clear {
                  Image(icon: .ic_cancel)
                    .frame(width: 32, height: 32)
                    .background(Color.ds(.white))
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)

                } else {
                  CircleView(color: colorModel.color)
                    .frame(width: 50, height: 50)
                }
              }
              .buttonStyle(.plain)
            }
          }
        }
        .scrollIndicators(.hidden)
      }
    }
    .frame(height: 50)
    .frame(maxWidth: .infinity)
    .debug()
  }

  func changePaletteType(_ type: PaletteType) {
    switch type {
    case .font:
      paletteType = .color
    case .color:
      paletteType = .background
    case .background:
      paletteType = .font
    }
  }
}

struct PaletteView_Previews: PreviewProvider {
  static var previews: some View {
    PaletteView(selectedFont: .constant(.ds(.title2(.medium))), selectedForegroundColor: .constant(.ds(.white)), selectedBackgroundColor: .constant(.clear))
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}
