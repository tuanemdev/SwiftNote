//
//  PeelEffect.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/03/2023.
//

import SwiftUI

struct PeelEffect<Content: View>: View {
    
    var content: Content
    var onDelete: () -> Void
    
    init(@ViewBuilder content: @escaping () -> Content, onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }
    
    @State private var dragProgress: CGFloat = 0
    @State private var isExpanded: Bool = false
    
    var body: some View {
        content
            .hidden()
            .overlay {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .global)
                    let minX = rect.minX
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.red.gradient)
                        .overlay(alignment: .trailing) {
                            Button {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                    dragProgress = 1
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                    onDelete()
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .padding(.trailing, 20)
                                    .foregroundColor(.white)
                                    .contentShape(Rectangle())
                            }
                            .disabled(!isExpanded)
                        }
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard !isExpanded else { return }
                                    let translationX = max(-value.translation.width, 0)
                                    dragProgress = min(translationX / rect.width, 1)
                                }
                                .onEnded { value in
                                    guard !isExpanded else { return }
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                        isExpanded = dragProgress > 0.25
                                        dragProgress = dragProgress > 0.25 ? 0.6 : .zero
                                    }
                                }
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                isExpanded = false
                                dragProgress = .zero
                            }
                        }
                    
                    Rectangle()
                        .fill(.black)
                        .padding(.vertical, 23)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 30, y: 0)
                        .padding(.trailing, rect.width * dragProgress)
                        .mask(content)
                        .allowsHitTesting(false)
                        .offset(x: dragProgress == 1 ? -minX : 0)
                    
                    content
                        .mask {
                            Rectangle()
                                .padding(.trailing, dragProgress * rect.width)
                        }
                        .allowsHitTesting(false)
                        .offset(x: dragProgress == 1 ? -minX : 0)
                }
            }
            .overlay {
                GeometryReader { proxy in
                    let size = proxy.size
                    let minX = proxy.frame(in: .global).minX
                    let minOpacity = dragProgress / 0.05
                    let opacity = min(minOpacity, 1)
                    
                    content
                        .shadow(color: .black.opacity(dragProgress != 0 ? 0.1 : 0), radius: 5, x: 15, y: 0)
                        .overlay {
                            Rectangle()
                                .fill(.white.opacity(0.25))
                                .mask(content)
                        }
                        .overlay(alignment: .trailing) {
                            Rectangle()
                                .fill(.linearGradient(colors: [
                                    .clear,
                                    .white,
                                    .clear,
                                    .clear
                                ], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 60)
                                .offset(x: 40)
                                .offset(x: -30 + 30 * opacity)
                                .offset(x: size.width * -dragProgress)
                        }
                        .scaleEffect(x: -1)
                        .offset(x: size.width - size.width * dragProgress)
                        .offset(x: size.width * -dragProgress)
                        .mask {
                            Rectangle().offset(x: size.width * -dragProgress)
                        }
                        .offset(x: dragProgress == 1 ? -minX : 0)
                }
                .allowsHitTesting(false)
            }
    }
}

struct PeelEffect_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PeelEffectView()
        }
    }
}
