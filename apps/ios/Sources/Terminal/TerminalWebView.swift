import SwiftUI
import WebKit

struct TerminalWebView: UIViewRepresentable {
    let gatewayURL: URL?
    let token: String?

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = true
        webView.backgroundColor = UIColor(red: 0.043, green: 0.063, blue: 0.125, alpha: 1.0)
        
        let scrollView = webView.scrollView
        scrollView.backgroundColor = UIColor(red: 0.043, green: 0.063, blue: 0.125, alpha: 1.0)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = gatewayURL else {
            return
        }
        
        var request = URLRequest(url: url)
        if let token = token, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if webView.url != url {
            webView.load(request)
        }
    }
}
