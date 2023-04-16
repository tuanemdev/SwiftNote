//
//  UIImageViewAnimation.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 16/04/2023.
//

import UIKit

class UIImageViewAnimation {
    let imageView: UIImageView = .init()
    var images: [UIImage] = .init()
    
    func setupAnimatedImageView() {
        images = [
            UIImage(named: "image-01")!,
            UIImage(named: "image-02")!,
            UIImage(named: "image-03")!,
            UIImage(named: "image-04")!
        ]
        
        imageView.animationImages = images
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 4
        imageView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.imageView.stopAnimating()
        }
    }
}
