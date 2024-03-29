import SwiftUI

struct SMToastSwiftUIModifier: ViewModifier {

  @Binding var toast: SMSwiftUIToast?
  @State private var workItem: DispatchWorkItem?
  @State private var showToast: Bool = false

  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        ZStack {
          if let toast {
            VStack {
              Spacer()
              SMToastSwiftUIView(for: toast.type)
                .offset(y: showToast ? -18 : 0)
            }
          }
        }
        .animation(.spring(), value: toast)
        .animation(.easeOut(duration: 0.2), value: showToast)
      )
      .onChange(of: toast) { newToast in
        guard let newToast else { return }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        if newToast.duration > .zero {
          workItem?.cancel()

          let task = DispatchWorkItem {
            withAnimation {
              showToast = false
              toast = nil
            }

            workItem?.cancel()
            workItem = nil
          }

          workItem = task
          showToast = true
          DispatchQueue.main.asyncAfter(deadline: .now() + newToast.duration, execute: task)
        }
      }
  }
}
