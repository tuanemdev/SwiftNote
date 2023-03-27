//
//  Fonts.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 27/03/2023.
//

import SwiftUI

struct Fonts: View {
    var body: some View {
        Text("Nguyễn Tuấn Anh")
            .font(.custom("Pacifico-Regular", size: 22, relativeTo: .body))
    }
}

struct Fonts_Previews: PreviewProvider {
    static var previews: some View {
        Fonts()
    }
}

// MARK: - Thêm custom Font vào Project
// Bước 1: Tải font về và thêm vào Project, nhớ tích chọn 'Copy items if needed' và tích chọn targets

// Bước 2: Update file Info.plist
/*
 Thêm key: Fonts provided by application
 Đây là 1 Array, điền tên của các font được thêm vào tương ứng với mỗi item
 Tên điển vào chính là tên file. ví dụ: Pacifico.ttf
 */

// Bước 3: Tìm tên của font bằng hàm viết trong extension bên dưới
/*
 Cách sử dụng
 Text("Nguyen Tuan Anh")
     .font(.custom("Pacifico-Regular", size: 22, relativeTo: .body))
 */

// MARK: - Print Fonts
extension View {
    func printFonts() {
        UIFont.familyNames.forEach { familyName in
            print("\n=== Family: \(familyName) ===\nFonts:")
            UIFont.fontNames(forFamilyName: familyName).enumerated().forEach { index, fontName in
                print("\t\(index). \(fontName)")
            }
        }
    }
}
