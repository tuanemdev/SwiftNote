//
//  GIFView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 14/04/2023.
//

import SwiftUI

struct GIFContentView: View {
    
    @State private var state: GIFState = .play
    
    var body: some View {
        VStack {
            GIFView(info: .name("how-i-study"), state: state)
                .frame(width: 200, height: 200)
            WKGIFView(gifName: "how-i-study")
                .frame(width: 250, height: 250)
            Button("Change State") {
                state = state == .play ? .pause : .play
            }
        }
    }
}

struct GIFContentView_Previews: PreviewProvider {
    static var previews: some View {
        GIFContentView()
    }
}

// MARK: - GIFView
enum GIFState {
    case play
    case pause
}

struct GIFView: UIViewRepresentable {
    
    let info: GIFInfo
    var state: GIFState = .play
    
    func makeUIView(context: Context) -> UIView {
        let uiView: UIView = .init(frame: .zero)
        let gifImageView: GIFImageView = .init()
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.startGif(with: info)
        
        uiView.addSubview(gifImageView)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gifImageView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            gifImageView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        return uiView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let gifImageView = uiView.subviews.first as? GIFImageView else { return }
        switch state {
        case .play:
            gifImageView.resumeGif()
        case .pause:
            gifImageView.pauseGif()
        }
    }
}

// MARK: - WKGIFView
struct WKGIFView: UIViewRepresentable {
    
    let gifName: String
    
    func makeUIView(context: Context) -> GIFWebView {
        let gifWebView = GIFWebView(name: gifName)
        return gifWebView
    }
    
    func updateUIView(_ uiView: GIFWebView, context: Context) {
        uiView.reload()
    }
}
