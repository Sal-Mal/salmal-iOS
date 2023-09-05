//
//  SMVoteButton.swift
//  UI
//
//  Created by 청새우 on 2023/09/03.
//

import SwiftUI

public struct SMVoteButton: View {

  public enum ButtonState {
    case none
    case first
    case second
  }

  @State private var animationProgress: Double = 0
  @State private var isPressed: Bool = false

  private let title: String
  private let buttonState: ButtonState
  private let progress: Double
  private let action: () -> Void

  public init(
    title: String,
    buttonState: ButtonState = .none,
    progress: Double,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.buttonState = buttonState
    self.progress = progress
    self.action = action
  }

  public var body: some View {
    Button {
      isPressed = true

      withAnimation(.easeOut) {
        animationProgress = progress
        self.action()
      }
    } label: {
      if isPressed {
        GeometryReader { proxy in
          let size = proxy.size

          ZStack(alignment: .leading) {
            HStack {
              Text(title)
                .foregroundColor(.ds(.green1))
                .font(.system(size: 20, weight: .semibold))

              Spacer()

              Text("\(Int(round(progress * 100)))%")
                .foregroundColor(.ds(.green1))
                .font(.system(size: 20, weight: .semibold))
            }
            .padding(.horizontal)
            .frame(width: size.width, height: size.height)

            HStack {
              Text(title)
                .foregroundColor(.ds(.black))
                .font(.system(size: 20, weight: .semibold))
              Spacer()
              Text("\(Int(round(progress * 100)))%")
                .foregroundColor(.ds(.black))
                .font(.system(size: 20, weight: .semibold))
            }
            .padding(.horizontal)
            .frame(width: size.width, height: size.height)
            .mask(alignment: .leading) {
              Rectangle()
                .frame(width: size.width * animationProgress, height: size.height)
            }
          }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background {
          GeometryReader { proxy in
            let size = proxy.size

            ZStack(alignment: .leading) {
              RoundedRectangle(cornerRadius: 30)
                .fill(Color.ds(.gray4))
                .overlay {
                  RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.ds(.green1))
                }

              RoundedRectangle(cornerRadius: 30)
                .fill(Color.ds(.green1))
                .frame(width: size.width * animationProgress, height: size.height)
                .clipped()
            }
          }
        }

      } else {
        Text(title)
          .foregroundColor(.ds(.white))
          .font(.system(size: 20, weight: .semibold))
          .frame(maxWidth: .infinity)
          .frame(height: 60)
          .background {
            RoundedRectangle(cornerRadius: 30)
              .fill(Color.ds(.gray3))
          }
      }
    }
  }
}

struct SMVoteButton_Previews: PreviewProvider {
  static var previews: some View {
    SMVoteButton(title: "👍🏻 살", progress: 0.6) {
      print("클릭")
    }
    .padding()
    .preferredColorScheme(.dark)
  }
}
