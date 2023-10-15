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

  private let colors: [Color] = [.ds(.white), .ds(.black), .ds(.red), .ds(.orange), .ds(.yellow), .ds(.green), .ds(.blue), .ds(.purple), .ds(.apricot)]
  private let fonts: [Font] = [
    .pretendard(.semiBold, size: 16),
    .maruBuri(size: 16),
    .ttTogether(size: 15),
    .twaySky(size: 15),
    .binggrae(size: 15),
    .gabiaSolmee(size: 15)
  ]

  @State private var paletteType: PaletteType = .font

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

              } label: {
                Circle()
                  .fill(Color.ds(.white))
                  .frame(width: 32, height: 32)
                  .overlay {
                    Text("Aa")
                      .foregroundColor(.ds(.black))
                      .font(font)
                  }
              }
              .buttonStyle(.plain)
            }
          }
        }
        .scrollIndicators(.hidden)

      case .color, .background:
        ScrollView(.horizontal) {
          HStack(spacing: 6) {
            ForEach(colors, id: \.self) { color in
              Button {
              } label: {
                CircleView(color: color)
                  .frame(width: 50, height: 50)
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
    PaletteView()
    .preferredColorScheme(.dark)
    .onAppear {
      SM.Font.initFonts()
    }
  }
}
