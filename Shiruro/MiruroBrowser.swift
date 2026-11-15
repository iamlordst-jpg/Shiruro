import SwiftUI
import WebKit

@MainActor
final class MiruroBrowser: ObservableObject {
    let webView: WKWebView

    init() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.backgroundColor = UIColor(red: 0.035, green: 0.025, blue: 0.075, alpha: 1)
        webView.isOpaque = false
        webView.scrollView.backgroundColor = webView.backgroundColor
        loadHome()
    }

    func loadHome() {
        guard let url = URL(string: "https://miruro.to/") else { return }
        webView.load(URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30))
    }

    func goBack() { if webView.canGoBack { webView.goBack() } }
    func reload() { webView.reload() }
}

struct MiruroWebView: UIViewRepresentable {
    @ObservedObject var browser: MiruroBrowser
    func makeUIView(context: Context) -> WKWebView { browser.webView }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
