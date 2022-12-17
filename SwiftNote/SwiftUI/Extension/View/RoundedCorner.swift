//
//  RoundedCorner.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 17/12/2022.
//

import SwiftUI

struct RoundedCorner: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(corners: UIRectCorner, _ radius: CGFloat) -> some View {
        clipShape( RoundedCorner(corners: corners, radius: radius) )
    }
}
