//
//  ShimmerEffect.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 01/04/2023.
//

import SwiftUI

struct ShimmerEffectView: View {
    var body: some View {
        ZStack {
            Color.green
            Text("Shimmer Effect")
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.5))
                .shimmer(.init(highlight: .white, blur: 5))
        }
    }
}

struct ShimmerEffect_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerEffectView()
    }
}

extension View {
    @ViewBuilder
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffect(config: config))
    }
}

fileprivate
struct ShimmerEffect: ViewModifier {
    
    var config: ShimmerConfig
    @State private var moveTo: CGFloat = -0.7
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    let size = proxy.size
                    let extraOffset = size.height / 2.5
                    
                    Rectangle()
                        .fill(config.highlight)
                        .mask {
                            Rectangle()
                                .fill(.linearGradient(colors: [.white.opacity(0),
                                                               config.highlight,
                                                               .white.opacity(0)],
                                                      startPoint: .top,
                                                      endPoint: .bottom))
                                .blur(radius: config.blur)
                                .rotationEffect(.init(degrees: -70))
                                .offset(x: size.width * moveTo)
                                .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                        }
                }
                .mask(content)
            }
            .onAppear {
                moveTo = 0.7
            }
            .animation(.linear(duration: config.duration).repeatForever(autoreverses: false), value: moveTo)
    }
}

struct ShimmerConfig {
    var highlight: Color
    var blur: CGFloat = 0
    var duration: CGFloat = 2
}
