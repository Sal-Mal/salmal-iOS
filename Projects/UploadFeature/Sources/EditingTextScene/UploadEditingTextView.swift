import SwiftUI
import ComposableArchitecture

import UI

public struct UploadEditingTextView: View {

  @FocusState var focusField: UploadEditingTextCore.State.Field?

  private let store: StoreOf<UploadEditingTextCore>
  @ObservedObject private var viewStore: ViewStoreOf<UploadEditingTextCore>

  public init(store: StoreOf<UploadEditingTextCore>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }

  public var body: some View {
    VStack {
      DynamicTextField(
        text: viewStore.$text,
        font: viewStore.$font,
        foregroundColor: viewStore.$foregroundColor,
        backgroundColor: viewStore.$backgroundColor,
        onFocused: $focusField
      )
        .synchronize(viewStore.$focusField, $focusField)
        .toolbar {
          ToolbarItemGroup(placement: .keyboard) {
            PaletteView(
              selectedFont: viewStore.$font,
              selectedForegroundColor: viewStore.$foregroundColor,
              selectedBackgroundColor: viewStore.$backgroundColor
            )
          }
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.ds(.black50))
    .onAppear {
      viewStore.send(.onAppear)
    }
  }
}


public struct DynamicTextField: View {

  @State private var textRect = CGRect()
  @Binding var text: String
  @Binding var font: Font?
  @Binding var foregroundColor: Color?
  @Binding var backgroundColor: Color?
  var onFocused: FocusState<UploadEditingTextCore.State.Field?>.Binding

  private var placeholder: String = "텍스트 입력"

  public init(
    text: Binding<String>,
    font: Binding<Font?>,
    foregroundColor: Binding<Color?>,
    backgroundColor: Binding<Color?>,
    onFocused: FocusState<UploadEditingTextCore.State.Field?>.Binding
  ) {
    self._text = text
    self._font = font
    self._foregroundColor = foregroundColor
    self._backgroundColor = backgroundColor
    self.onFocused = onFocused
  }

  public var body: some View {
    ZStack {
      Text(text.isEmpty ? placeholder : text)
        .font(font)
        .background(GeometryReader(content: { view(for: $0) }))
        .layoutPriority(1)
        .opacity(0)

      HStack {
        TextField(text: $text, axis: .vertical) {
          Text(placeholder)
            .multilineTextAlignment(.center)
            .foregroundColor(.ds(.white80))
            .font(font)
        }
        .font(font)
        .foregroundColor(foregroundColor)
        .lineLimit(nil)
        .focused(onFocused, equals: .text)
        .tint(.ds(.green1))
        .background(text.isEmpty ? .clear : backgroundColor)
      }
    }
    .padding(.horizontal, 32)
  }

  func view(for proxy: GeometryProxy) -> some View {
    DispatchQueue.main.async {
      textRect = proxy.frame(in: .global)
    }
    return Rectangle().fill(.clear)
      .frame(height: textRect.height)
  }
}


struct TextUploadView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      UploadEditingTextView(store: .init(initialState: .init(), reducer: {
        UploadEditingTextCore()
      }))
    }
    .preferredColorScheme(.dark)
  }
}
