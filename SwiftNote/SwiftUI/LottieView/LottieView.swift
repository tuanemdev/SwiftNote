//
//  LottieView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/11/2022.
//

// https://github.com/airbnb/lottie-ios
// https://lottiefiles.com/
/*
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    let fileName: String
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let uiView: UIView = UIView(frame: .zero)
        let lottieView: LottieAnimationView = LottieAnimationView()
        lottieView.animation = LottieAnimation.named(fileName)
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = loopMode
        lottieView.animationSpeed = 1.0
        lottieView.play()
        uiView.addSubview(lottieView)
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lottieView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        return uiView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
}
*/
