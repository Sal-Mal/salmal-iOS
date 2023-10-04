import SwiftUI

public struct SMVoteButton: View {

  public enum ButtonState {
    case idle
    case selected
    case unSelected
  }

  @State private var animationProgress: Double = 0
  @Binding private var buttonState: ButtonState

  private let title: String
  private let progress: Double
  private let action: () -> Void

  public init(
    title: String,
    progress: Double,
    buttonState: Binding<ButtonState>,
    action: @escaping () -> Void
  ) {
    self.title = title

    if progress < 0 {
      self.progress = 0
    } else if progress > 1 {
      self.progress = 1
    } else {
      self.progress = progress
    }

    self._buttonState = buttonState
    self.action = action
  }

  public var body: some View {
    Button {
      self.action()
    } label: {
      if buttonState == .idle {
        Text(title)
          .foregroundColor(.ds(.white))
          .font(.system(size: 20, weight: .semibold))
          .frame(maxWidth: .infinity)
          .frame(height: 60)
          .background {
            RoundedRectangle(cornerRadius: 30)
              .fill(Color.ds(.white20))
          }

      } else {
        GeometryReader { proxy in
          let size = proxy.size

          Rectangle()
            .fill(.clear)
            .frame(width: size.width, height: size.height)
            .background {
              ZStack(alignment: .leading) {
                // 배경
                Rectangle()
                  .fill(Color.ds(.white20))
                  .clipShape(Capsule())

                // 퍼센트 배경
                Rectangle()
                  .fill(Color.ds(buttonState == .selected ? .green1 : .gray3))
                  .frame(width: size.width * animationProgress)
                  .animation(.default, value: animationProgress)
                  .clipShape(Capsule())

                // 배경 아웃 라인
                if buttonState == .selected {
                  RoundedRectangle(cornerRadius: size.height / 2)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.ds(.green1))
                }
              }
            }
            .overlay(alignment: .leading) {
              // 살/말 및 퍼센트 문자 부분
              ZStack {
                HStack {
                  Text(title)
                    .font(.ds(.title2(.semibold)))
                    .foregroundColor(.ds(buttonState == .selected ? .green1 : .white))
                  Spacer()
                  Text("\(Int(round(progress * 100)))%")
                    .foregroundColor(.ds(buttonState == .selected ? .green1 : .white))
                    .font(.ds(.title2(.semibold)))
                }
                .padding()

                HStack {
                  Text(title)
                    .font(.ds(.title2(.semibold)))
                    .foregroundColor(.ds(buttonState == .selected ? .black : .white))
                  Spacer()
                  Text("\(Int(round(progress * 100)))%")
                    .foregroundColor(.ds(buttonState == .selected ? .black : .white))
                    .font(.ds(.title2(.semibold)))
                }
                .padding()
                .mask(alignment: .leading) {
                  Rectangle()
                    .frame(width: size.width * animationProgress, height: size.height)
                    .animation(.default, value: animationProgress)
                }
              }
            }
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
      }
    }
    .onChange(of: buttonState) { state in
      if state != .idle {
        animationProgress = progress
      } else {
        animationProgress = 0
      }
    }
  }
}

struct SMVoteButton_Previews: PreviewProvider {
  static var previews: some View {
    SMVoteButton(title: "👍🏻 살", progress: 0.5, buttonState: .constant(.selected)) {
      print("클릭")
    }
    .padding()
    .preferredColorScheme(.light)
  }
}
