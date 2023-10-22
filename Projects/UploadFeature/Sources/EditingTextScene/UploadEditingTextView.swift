import SwiftUI
import ComposableArchitecture

import UI

public struct UploadEditingTextView: View {

  @State var text: String = ""
  @State var location: CGPoint = .zero


  @FocusState var focusField: UploadEditingTextCore.State.Field?

  private let store: StoreOf<UploadEditingTextCore>

  public init(store: StoreOf<UploadEditingTextCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        TextField(
          text: $text,
          axis: .vertical,
          label: {
            Text("텍스트 입력")
              .foregroundColor(.ds(.white80))
              .font(.ds(.title2(.medium)))
          }
        )
        .lineLimit(2)
        .background(.black)
        .focused($focusField, equals: .text)
        //.offset(x: location.x, y: location.y)
        //      .disabled(true)
//        .gesture(
//          DragGesture(coordinateSpace: .global)
//            .onChanged({ value in
//              location = value.location
//            })
//        )
        .foregroundColor(.white)
        .font(.ds(.title2(.medium)))
        .tint(.ds(.green1))
        .multilineTextAlignment(.center)
        .toolbar {
          ToolbarItemGroup(placement: .keyboard) {
            PaletteView()
          }
        }
        .synchronize(viewStore.$focusField, $focusField)
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
      .frame(maxHeight: .infinity)
      .background(Color.ds(.black50))
    }
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
