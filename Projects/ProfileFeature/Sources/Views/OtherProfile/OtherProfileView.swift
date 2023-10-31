import SwiftUI
import ComposableArchitecture

import Core
import UI

public struct OtherProfileView: View {

  @State private var scrollOffsetY: CGFloat = 0
  @State private var viewHeight: CGFloat = 0

  private let store: StoreOf<OtherProfileCore>

  public init(store: StoreOf<OtherProfileCore>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        if scrollOffsetY >= 0 {
          VStack(spacing: 12) {
            AsyncImage(url: URL(string: viewStore.member?.imageURL ?? "")) { phase in
              switch phase {
              case .success(let image):
                image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 80, height: 80)
                  .clipShape(Circle())
                  .overlay {
                    Circle()
                      .stroke(lineWidth: 2)
                      .foregroundColor(.white)
                  }

              default:
                Image(systemName: "person.fill")
                  .resizable()
                  .frame(width: 40, height: 40)
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 80, height: 80)
                  .background(.gray)
                  .clipShape(Circle())
                  .overlay {
                    Circle()
                      .stroke(lineWidth: 2)
                      .foregroundColor(.white)
                  }
              }
            }

            VStack(spacing: 6) {
              Text(viewStore.member?.nickName ?? "")
                .font(.ds(.title3(.semibold)))
                .foregroundColor(.ds(.black))
              Text(viewStore.member?.introduction ?? "")
                .font(.ds(.title4(.medium)))
                .foregroundColor(.ds(.black))
            }

            HStack(spacing: 62) {
              HStack {
                Text("👍🏻살")
                  .font(.pretendard(.semiBold, size: 14))
                  .foregroundColor(.ds(.green1))
                  .padding(.vertical, 4)
                  .padding(.horizontal, 6)
                  .background(Color.ds(.black))
                  .clipShape(Capsule())

                Text("\(viewStore.member?.likeCount ?? 0)")
                  .font(.ds(.title2(.semibold)))
                  .foregroundColor(.ds(.black))
              }
              HStack {
                Text("👎🏻말")
                  .font(.pretendard(.semiBold, size: 14))
                  .foregroundColor(.ds(.green1))
                  .padding(.vertical, 4)
                  .padding(.horizontal, 6)
                  .background(Color.ds(.black))
                  .clipShape(Capsule())

                Text("\(viewStore.member?.disLikeCount ?? 0)")
                  .font(.ds(.title2(.semibold)))
                  .foregroundColor(.ds(.black))
              }
            }
          }
          .frame(height: viewHeight)
          .frame(maxWidth: .infinity)
          .background(Color.ds(.green1))
          .cornerRadius(30)

        } else {
          HStack {
            AsyncImage(url: URL(string: viewStore.member?.imageURL ?? "")) { phase in
              switch phase {
              case .success(let image):
                image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 60, height: 60)
                  .clipShape(Circle())
                  .overlay {
                    Circle()
                      .stroke(lineWidth: 2)
                      .foregroundColor(.white)
                  }

              default:
                Image(systemName: "person.fill")
                  .resizable()
                  .frame(width: 30, height: 30)
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 60, height: 60)
                  .background(.gray)
                  .clipShape(Circle())
                  .overlay {
                    Circle()
                      .stroke(lineWidth: 2)
                      .foregroundColor(.white)
                  }
              }
            }
            VStack(alignment: .leading) {
              Text(viewStore.member?.nickName ?? "")
                .font(.ds(.title3(.semibold)))
                .foregroundColor(.ds(.black))

              HStack(spacing: 16) {
                HStack {
                  Text("👍🏻살")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundColor(.ds(.green1))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(Color.ds(.black))
                    .clipShape(Capsule())

                  Text("\(viewStore.member?.likeCount ?? 0)")
                    .font(.ds(.title2(.semibold)))
                    .foregroundColor(.ds(.black))
                }
                HStack {
                  Text("👎🏻말")
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundColor(.ds(.green1))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(Color.ds(.black))
                    .clipShape(Capsule())

                  Text("\(viewStore.member?.disLikeCount ?? 0)")
                    .font(.ds(.title2(.semibold)))
                    .foregroundColor(.ds(.black))
                }
              }
            }
            Spacer()
          }
          .padding()
          .frame(height: viewHeight)
          .frame(maxWidth: .infinity)
          .background(Color.ds(.green1))
          .cornerRadius(30)
        }

        Spacer(minLength: 32)

        if viewHeight != 100 {
          HStack {
            Button {

            } label: {
              Text("업로드")
                .foregroundColor(.ds(.white))
                .font(.ds(.title2(.semibold)))
            }
            Spacer()
          }
       }

        SMScrollView { offset in
          scrollOffsetY = offset.y
          print(offset.y)
        } content: {
          LazyVGrid(columns: [.init(), .init()]) {
            ForEach(viewStore.votes, id: \.id) { vote in
              GeometryReader { proxy in
                AsyncImage(url: URL(string: vote.imageURL)) { phase in
                  switch phase {
                  case .success(let image):
                    image
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .cornerRadius(24.0)
                      .onTapGesture {
                        store.send(.requestVote(vote.id))
                      }

                  default:
                    RoundedRectangle(cornerRadius: 24.0)
                      .fill(.gray)
                  }
                }
                .frame(height: proxy.size.width)
              }
              .clipped()
              .cornerRadius(24.0)
              .aspectRatio(1, contentMode: .fit)
            }
          }
        }
        .scrollIndicators(.hidden)
      }
      .padding()
      .smNavigationBar(title: "") {
        Button {
          viewStore.send(.dismissButtonTapped)
        } label: {
          Image(icon: .chevron_left)
        }

      } rightItems: {
        Button {
          viewStore.send(.set(\.$isBlockSheetPresented, true))
        } label: {
          Image(icon: .ic_cancel)
            .renderingMode(.template)
            .foregroundColor(.ds(.white))
        }
      }
      .onAppear {
        scrollOffsetY = 0
        viewHeight = 200
      }
      .onChange(of: scrollOffsetY) { newValue in
        withAnimation(.linear(duration: 0.2)) {
          if newValue >= 0 {
            viewHeight = 200
          } else {
            viewHeight = 100
          }
        }
      }
      .alert(isPresented: viewStore.$isBlockSheetPresented, alert: .blocking) {
        viewStore.send(.blockButtonTapped)
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}


struct OtherProfileView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      OtherProfileView(store: .init(initialState: .init(memberID: 2), reducer: {
        OtherProfileCore()
      }))
    }
    .preferredColorScheme(.dark)
  }
}
