//
//  AsyncImageView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 18/05/2023.
//

import SwiftUI

struct AsyncImageView: View {
    var body: some View {
        AsyncImage(
            url: URL(string: "https://imglarger.com/Images/before-after/ai-image-enlarger-1-after-2.jpg"),
            transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.25))
        ) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .transition(.scale)
            case .failure(_):
                Circle()
                    .fill(.red)
                    .frame(width: 250, height: 250)
            case .empty:
                ProgressView()
            @unknown default:
                ProgressView()
            }
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView()
    }
}
