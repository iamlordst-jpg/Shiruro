import SwiftUI
import WebKit

@MainActor
final class MiruroBrowser: ObservableObject {
    let webView: WKWebView

    init() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
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

    func focusPlayer() {
        let script = """
        (() => {
          const styleId = 'shiruro-player-focus';
          if (!document.getElementById(styleId)) {
            const style = document.createElement('style');
            style.id = styleId;
            style.textContent = 'body > header, body > nav, body > footer { display:none !important; }';
            document.head.appendChild(style);
          }
          const candidates = [
            ...Array.from(document.querySelectorAll('video')),
            ...Array.from(document.querySelectorAll('iframe'))
          ];
          const target = candidates.find(el => {
            const r = el.getBoundingClientRect();
            return r.width > 160 && r.height > 90;
          });
          if (target) {
            target.scrollIntoView({ behavior: 'smooth', block: 'center' });
            return true;
          }
          return false;
        })();
        """
        webView.evaluateJavaScript(script, completionHandler: nil)
    }

    func goBack() { if webView.canGoBack { webView.goBack() } }
    func reload() { webView.reload() }

    func search(_ query: String, completion: @escaping (Bool) -> Void) {
        let safeQuery = query
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: " ")
        let script = """
        (() => {
          const q = '\(safeQuery)';
          const candidates = Array.from(document.querySelectorAll('input'));
          const field = candidates.find(el =>
            el.type === 'search' ||
            /search|anime/i.test((el.placeholder || '') + ' ' + (el.getAttribute('aria-label') || '') + ' ' + (el.name || ''))
          );
          if (!field) return false;
          field.focus();
          const setter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set;
          setter.call(field, q);
          field.dispatchEvent(new Event('input', { bubbles: true }));
          field.dispatchEvent(new Event('change', { bubbles: true }));
          field.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter', code: 'Enter', bubbles: true }));
          field.dispatchEvent(new KeyboardEvent('keyup', { key: 'Enter', code: 'Enter', bubbles: true }));
          const form = field.closest('form');
          if (form) form.requestSubmit();
          return true;
        })();
        """
        webView.evaluateJavaScript(script) { result, _ in
            completion((result as? Bool) ?? false)
        }
    }

    func scrollToSection(_ title: String) {
        let safeTitle = title.replacingOccurrences(of: "'", with: "\\'")
        let script = """
        (() => {
          const target = Array.from(document.querySelectorAll('h1,h2,h3,[role=heading]'))
            .find(el => (el.innerText || '').toLowerCase().includes('\(safeTitle.lowercased())'));
          if (target) { target.scrollIntoView({ behavior: 'smooth', block: 'start' }); return true; }
          return false;
        })();
        """
        webView.evaluateJavaScript(script, completionHandler: nil)
    }

    func togglePlayback() {
        webView.evaluateJavaScript("""
        (() => { const v = document.querySelector('video'); if (!v) return false;
          if (v.paused) { const p = v.play(); if (p && p.catch) p.catch(() => {}); }
          else v.pause(); return true; })()
        """, completionHandler: nil)
    }

    func seek(by seconds: Double) {
        webView.evaluateJavaScript("""
        (() => { const v = document.querySelector('video'); if (!v) return false;
          v.currentTime = Math.max(0, Math.min(v.duration || Infinity, v.currentTime + (\(seconds))));
          return true; })()
        """, completionHandler: nil)
    }

    func enterFullscreen() {
        webView.evaluateJavaScript("""
        (() => { const v = document.querySelector('video'); if (!v) return false;
          if (v.webkitEnterFullscreen) v.webkitEnterFullscreen();
          else if (v.requestFullscreen) v.requestFullscreen();
          return true; })()
        """, completionHandler: nil)
    }
}

struct MiruroWebView: UIViewRepresentable {
    @ObservedObject var browser: MiruroBrowser
    func makeUIView(context: Context) -> WKWebView { browser.webView }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
