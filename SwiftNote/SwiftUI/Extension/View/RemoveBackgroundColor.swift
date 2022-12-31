//
//  RemoveBackgroundColor.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/12/2022.
//

import SwiftUI

struct RemoveBackgroundColor: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        Task { @MainActor in
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}

extension View {
    func removeBackground(_ style: AnyShapeStyle) -> some View {
        background(RemoveBackgroundColor())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Rectangle()
                    .fill(style)
                    .ignoresSafeArea(.container, edges: .all)
            }
    }
}
