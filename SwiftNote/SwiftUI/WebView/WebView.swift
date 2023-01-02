//
//  WebView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 01/01/2023.
//

import SwiftUI
import WebKit
import Combine

struct WebViewExam: View {
    
    @ObservedObject private var webViewModel: WebViewModel = .init()
    let localWeb: String = "LocalWebsite"
    let myWebsite: String = "https://www.tuanem.com"
    let htmlCode: String = """
    <html>
    <body>
    <h1>Hello, Swift!</h1>
    </body>
    </html>
    """
    
    var body: some View {
        WebView(urlType: .local(localWeb), viewModel: webViewModel)
    }
}

struct WebViewExam_Previews: PreviewProvider {
    static var previews: some View {
        WebViewExam()
    }
}

struct WebView: UIViewRepresentable {
    
    var urlType: URLType
    @ObservedObject var viewModel: WebViewModel
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences: WKWebpagePreferences = .init()
        preferences.allowsContentJavaScript = true
        
        let configuration: WKWebViewConfiguration = .init()
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController.add(self.makeCoordinator(), name: "iOSNative")
        
        let webView: WKWebView = .init(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        switch urlType {
        case .local(let fileName):
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "html") else { return }
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        case .remote(let urlString):
            guard let url = URL(string: urlString) else { return }
            webView.load(URLRequest(url: url))
        case .code(let string):
            webView.loadHTMLString(string, baseURL: Bundle.main.resourceURL)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let parent: WebView
        var webViewNavigationSubscriber: AnyCancellable?
        var valueSubscriber: AnyCancellable?
        
        init(_ parent: WebView) { self.parent = parent }
        deinit {
            webViewNavigationSubscriber?.cancel()
            valueSubscriber?.cancel()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.viewModel.showLoader.send(false)
            webView.evaluateJavaScript("document.title") { response, error in
                guard error != nil else { return }
                guard let title = response as? String else { return }
                self.parent.viewModel.webTitle.send(title)
            }
        }
        
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            parent.viewModel.showLoader.send(false)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.viewModel.showLoader.send(false)
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.viewModel.showLoader.send(true)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.viewModel.showLoader.send(true)
            webViewNavigationSubscriber = parent.viewModel.webViewNavigationPublisher
                .receive(on: RunLoop.main)
                .sink { navigation in
                    switch navigation {
                    case .backward:
                        if webView.canGoBack { webView.goBack() }
                    case .forward:
                        if webView.canGoForward { webView.goForward() }
                    case .reload:
                        webView.reload()
                    }
                }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            /*
             guard let host = navigationAction.request.url?.host,
                   host == "www.tuanem.com" else { return .cancel }
             */
            return .allow
        }
        
    }
}

extension WebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "iOSNative" {
            if let body = message.body as? [String: Any?] {
                print("JSON value received from web is: \(body)")
            } else if let body = message.body as? String {
                print("String value received from web is: \(body)")
            }
        }
    }
}
