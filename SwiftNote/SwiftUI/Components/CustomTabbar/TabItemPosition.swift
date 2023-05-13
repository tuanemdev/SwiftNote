//
//  TabItemPosition.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 13/05/2023.
//

import SwiftUI

struct PositionKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func viewPosition(completion: @escaping (CGRect) -> Void) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .global)
                    
                    Color.clear
                        .preference(key: PositionKey.self,value: rect)
                        .onPreferenceChange(PositionKey.self, perform: completion)
                }
            }
    }
}
