//
//  SMVoteButton.swift
//  UI
//
//  Created by 청새우 on 2023/09/03.
//

import SwiftUI

struct SMVoteButton: View {

  enum ButtonState {
    case none
    case first
    case second
  }

  @State private var animationProgress: Double = 0
  @State private var isPressed: Bool = false

  let title: String
  var buttonState: ButtonState = .none
  var progress: Double
  var action: () -> Void

  var body: some View {
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
                .foregroundColor(UIAsset.green1.swiftUIColor)
                .font(.system(size: 20, weight: .semibold))

              Spacer()

              Text("\(Int(round(progress * 100)))%")
                .foregroundColor(UIAsset.green1.swiftUIColor)
                .font(.system(size: 20, weight: .semibold))
            }
            .padding(.horizontal)
            .frame(width: size.width, height: size.height)

            HStack {
              Text(title)
                .foregroundColor(UIAsset.black.swiftUIColor)
                .font(.system(size: 20, weight: .semibold))
              Spacer()
              Text("\(Int(round(progress * 100)))%")
                .foregroundColor(UIAsset.black.swiftUIColor)
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
                .fill(UIAsset.gray4.swiftUIColor)
                .overlay {
                  RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 2)
                    .foregroundColor(UIAsset.green1.swiftUIColor)
                }

              RoundedRectangle(cornerRadius: 30)
                .fill(UIAsset.green1.swiftUIColor)
                .frame(width: size.width * animationProgress, height: size.height)
                .clipped()
            }
          }
        }

      } else {
        Text(title)
          .foregroundColor(UIAsset.white.swiftUIColor)
          .font(.system(size: 20, weight: .semibold))
          .frame(maxWidth: .infinity)
          .frame(height: 60)
          .background {
            RoundedRectangle(cornerRadius: 30)
              .fill(UIAsset.gray3.swiftUIColor)
          }
      }
    }
  }
}

struct SMVoteButton_Previews: PreviewProvider {
  static var previews: some View {
    SMVoteButton(title: "👍🏻 살", progress: 0.1) {
      print("클릭")
    }
    .padding()
    .preferredColorScheme(.dark)
  }
}
