//
//  PeelEffect.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/03/2023.
//

import SwiftUI

struct PeelEffectView: View {
    
    @State private var images: [ImageModel] = .init()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(images) { image in
                    PeelEffect {
                        CardView(image)
                    } onDelete: {
                        guard let index = images.firstIndex(where: { $0.id == image.id }) else { return }
                        let _ = withAnimation(.easeInOut(duration: 0.35)) {
                            images.remove(at: index)
                        }
                    }
                }
            }
            .padding(15)
        }
        .onAppear {
            Array(1...20).forEach { index in
                images.append(.init(assetName: "image0\(index % 4 + 1)"))
            }
        }
        .navigationTitle("Peel Effect")
    }
    
    // Card View
    @ViewBuilder
    func CardView(_ imageModel: ImageModel) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                Image(imageModel.assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
        }
        .frame(height: 130)
        .contentShape(Rectangle())
    }
}

struct PeelEffectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PeelEffectView()
        }
    }
}

// MARK: - Image Model
struct ImageModel: Identifiable {
    var id: UUID = .init()
    var assetName: String
}
