//
//  MaskContent.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 17/12/2022.
//

import SwiftUI

extension View {
    func maskContent<Content: View>(_ using: Content) -> some View {
        using.mask(self)
    }
}
