//
//  ColorView.swift
//  UIDemo
//
//  Created by 청새우 on 2023/09/03.
//

import SwiftUI
import UI

struct ColorView: View {
  var body: some View {
    List {
      Section("Black") {
        ColorExample(title: "Black", color: SM.Color.black)
        ColorExample(title: "Gray1", color: SM.Color.gray1)
        ColorExample(title: "Gray2", color: SM.Color.gray2)
        ColorExample(title: "Gray3", color: SM.Color.gray3)
        ColorExample(title: "Gray4", color: SM.Color.gray4)
      }

      Section("Accent Colors") {
        ColorExample(title: "Green1", color: SM.Color.green1)
        ColorExample(title: "Green2", color: SM.Color.green2)
      }

      Section("White") {
        ColorExample(title: "White", color: SM.Color.white)
        ColorExample(title: "White20", color: SM.Color.white20)
        ColorExample(title: "White36", color: SM.Color.white36)
        ColorExample(title: "White80", color: SM.Color.white80)
      }
    }
    .navigationTitle("Colors")
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
