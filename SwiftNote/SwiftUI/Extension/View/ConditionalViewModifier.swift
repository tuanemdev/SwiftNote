//
//  ConditionalViewModifier.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 17/12/2022.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
