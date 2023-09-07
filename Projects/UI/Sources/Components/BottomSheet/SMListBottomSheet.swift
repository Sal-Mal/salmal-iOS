import SwiftUI

public enum SMMenu: String, Identifiable {
  case 해당_게시물_신고하기 = "해당 게시물 신고하기"
  case 이_사용자_차단하기 = "이 사용자 차단하기"
  case 사진첩에서_선택하기 = "사진첩에서 선택하기"
  case 촬영하기 = "촬영하기"
  case 현재_사진_삭제 = "현재 사진 삭제"
  
  public var id: String { rawValue }
  
  public var image: Image {
    switch self {
    case .해당_게시물_신고하기:
      return .init(icon: .warning)
    case .이_사용자_차단하기:
      return .init(icon: .cancel)
    case .사진첩에서_선택하기:
      return .init(icon: .gallery)
    case .촬영하기:
      return .init(icon: .camera)
    case .현재_사진_삭제:
      return .init(icon: .trash)
    }
  }
}

extension View {
  public func smListSheet(
    isPresented: Binding<Bool>,
    items: [SMMenu],
    actions: [() -> Void]
  ) -> some View {
    modifier(SMListBottomSheetModifier(
      isPresented: isPresented,
      items: items,
      actions: actions
    ))
  }
}

public struct SMListBottomSheetModifier: ViewModifier {
  
  @Binding var isPresented: Bool
  let items: [SMMenu]
  let actions: [() -> Void]

  public func body(content: Content) -> some View {
    content
      .sheet(isPresented: $isPresented) {
        SMListBottomSheet(items: items, actions: actions)
          .frame(maxHeight: .infinity, alignment: .bottom)
          .background(Color.ds(.gray4))
          .presentationDragIndicator(.hidden)
          .presentationDetents([.height(CGFloat(60 * items.count + 50))])
      }
  }
}

public struct SMListBottomSheet: View {
  
  let items: [SMMenu]
  let actions: [() -> Void]
  
  public var body: some View {
    VStack {
      SheetDragIndicator()
        
      Spacer()
      
      ForEach(Array(items.enumerated()), id: \.element) { (index, item) in
        HStack(spacing: 6) {
          item.image
            .renderingMode(.template)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(.ds(.white))
            .frame(width: 32, height: 32)
            .debug()
          
          Text(item.rawValue)
            .font(.ds(.title3))
            .foregroundColor(.ds(.white))
          Spacer()
        }
        .padding(.leading, 18)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .debug()
        .onTapGesture {
          actions[index]()
        }
      }
    }
    .debug()
  }
}

struct SMListBottomSheet_Previews: PreviewProvider {
  static var previews: some View {
    Rectangle().fill(.red)
      .modifier(SMListBottomSheetModifier(
        isPresented: .constant(true),
        items: [.사진첩에서_선택하기, .이_사용자_차단하기, .촬영하기],
        actions: [{}, {}, {}]
      ))
  }
}
