//
//  FixedInnerHeight.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 01/01/2023.
//

import SwiftUI

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

extension View {
    func fixedInnerHeight(_ sheetHeight: Binding<CGFloat>) -> some View {
        padding()
            .background {
                GeometryReader { proxy in
                    Color.clear.preference(key: InnerHeightPreferenceKey.self, value: proxy.size.height)
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in sheetHeight.wrappedValue = newHeight }
            .presentationDetents([.height(sheetHeight.wrappedValue)])
            .presentationDragIndicator(.visible)
    }
}
