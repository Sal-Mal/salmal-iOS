import WebKit
import SwiftUI

struct WebViewRepresentable: UIViewRepresentable {
  
  let urlString: String
  
  func makeUIView(context: Context) -> WKWebView {
    let view = WKWebView()
    
    guard let url = URL(string: urlString)else {
      return view
    }
    
    view.load(URLRequest(url: url))
    return view
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    // empty
  }
}
