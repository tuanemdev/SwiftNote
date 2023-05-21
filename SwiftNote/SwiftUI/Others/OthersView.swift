//
//  OthersView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 18/03/2023.
//

import SwiftUI

struct OthersView: View {
    var body: some View {
        Text("^[\(3) Person](inflect: true)")
            .preferredColorScheme(.dark) /// Khi muốn toàn App chỉ sử dụng Dark Mode thì settings trong Info.plist
    }
}

struct OthersView_Previews: PreviewProvider {
    static var previews: some View {
        OthersView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
