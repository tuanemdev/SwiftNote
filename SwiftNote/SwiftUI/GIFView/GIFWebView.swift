//
//  GIFWebView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 14/04/2023.
//

import WebKit

@IBDesignable
final class GIFWebView: WKWebView {
    
    @IBInspectable
    private var gifName: String?
    
    init(name: String) {
        super.init(frame: .init(), configuration: .init())
        self.gifName = name
        self.setupGifView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupGifView()
    }
    
    private func setupGifView() {
        self.contentMode = .scaleAspectFit
        self.sizeToFit()
        self.autoresizesSubviews = true
        self.isOpaque = false
        self.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.scrollView.isScrollEnabled = false
        self.isUserInteractionEnabled = false
        guard let url = Bundle.main.url(forResource: gifName, withExtension: "gif"),
              let data = try? Data(contentsOf: url)
        else { return }
        self.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
    }
}
