import SwiftUI
import ComposableArchitecture

public struct PhotoAlbumView: View {

  private let store: StoreOf<PhotoAlbumCore>

  public init(store: StoreOf<PhotoAlbumCore>) {
    self.store = store
  }

  public var body: some View {
    Text("포토 앨범")
  }
}
