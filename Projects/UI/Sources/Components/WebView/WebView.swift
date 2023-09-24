import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
  
  var urlString: String
  
  public init(urlString: String) {
    self.urlString = urlString
  }
  
  public func makeUIView(context: Context) -> WKWebView {
    let view = WKWebView()
    
    guard let url = URL(string: urlString) else {
      return view
    }
    
    view.load(URLRequest(url: url))
    return view
  }
  
  public func updateUIView(_ uiView: WKWebView, context: Context) {
    // empty
  }
}
