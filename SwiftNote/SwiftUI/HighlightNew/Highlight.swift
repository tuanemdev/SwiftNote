//
//  Highlight.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 13/05/2023.
//

import SwiftUI

struct Highlight: Identifiable, Equatable {
    var id: UUID = .init()
    var anchor: Anchor<CGRect>
    var title: String
    var cornerRadius: CGFloat
    var style: RoundedCornerStyle = .continuous
    var scale: CGFloat = 1
}

fileprivate struct HighlightAnchorKey: PreferenceKey {
    static var defaultValue: [Int: Highlight] = [:]
    
    static func reduce(value: inout [Int : Highlight], nextValue: () -> [Int : Highlight]) {
        value.merge(nextValue()) { $1 }
    }
}

extension View {
    @ViewBuilder
    func showCase(order: Int, title: String, cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous, scale: CGFloat = 1) -> some View {
        self
        /// Storing it in Anchor Preference
            .anchorPreference(key: HighlightAnchorKey.self, value: .bounds) { anchor in
                let highlight = Highlight(anchor: anchor, title: title, cornerRadius: cornerRadius, style: style, scale: scale)
                return [order: highlight]
            }
    }
}

struct ShowCaseRoot: ViewModifier {
    
    var showHighlights: Bool
    var onFinished: () -> Void
    
    @State private var highlightOrder: [Int] = []
    @State private var currentHighlight: Int = 0
    @State private var showView: Bool = true
    @State private var showTitle: Bool = false
    
    @Namespace private var animation
    
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(HighlightAnchorKey.self) { value in
                highlightOrder = Array(value.keys).sorted()
            }
            .overlayPreferenceValue(HighlightAnchorKey.self) { preferences in
                if highlightOrder.indices.contains(currentHighlight), showHighlights, showView {
                    if let highlight = preferences[highlightOrder[currentHighlight]] {
                        highlightView(highlight)
                    }
                }
            }
    }
    
    /// Highlight View
    @ViewBuilder
    func highlightView(_ highlight: Highlight) -> some View {
        GeometryReader { proxy in
            let highlightRect = proxy[highlight.anchor]
            let safeArea = proxy.safeAreaInsets
            
            Rectangle()
                .fill(.black.opacity(0.5))
                .reverseMask {
                    Rectangle()
                        .matchedGeometryEffect(id: "HIGHLIGHTSHAPE", in: animation)
                        .frame(width: highlightRect.width + 5, height: highlightRect.height + 5)
                        .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                        .scaleEffect(highlight.scale)
                        .offset(x: highlightRect.minX - 2.5, y: highlightRect.minY - 2.5 + safeArea.top)
                }
                .ignoresSafeArea()
                .onTapGesture {
                    if currentHighlight >= highlightOrder.count - 1 {
                        /// Hiding the Highlight View
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showView = false
                        }
                        onFinished()
                    } else {
                        /// Move to next Highlight View
                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                            showTitle = false
                            currentHighlight += 1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            showTitle = true
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showTitle = true
                    }
                }
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: highlightRect.width + 20, height: highlightRect.height + 20)
                .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                .popover(isPresented: $showTitle) {
                    Text(highlight.title)
                        .padding(.horizontal, 10)
                        .presentationCompactAdaptation(.popover) // iOS 16.4
                        .interactiveDismissDisabled()
                }
                .scaleEffect(highlight.scale)
                .offset(x: highlightRect.minX - 10, y: highlightRect.minY - 10)
        }
    }
}

extension View {
    @ViewBuilder
    func reverseMask<Content: View>(alignment: Alignment = .topLeading, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: alignment) {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
}
