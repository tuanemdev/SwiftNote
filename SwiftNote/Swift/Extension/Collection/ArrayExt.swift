//
//  ArrayExt.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 25/01/2023.
//

import Foundation

// MARK: - Mục đích để sử dụng với @AppStorage vì hiện tại @AppStorage chỉ hỗ trợ các kiểu dữ liệu: Bool, Int, Double, String, URL, Data
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

// MARK: - Chia một mảng thành các mảng con nhỏ hơn với size chỉ định
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
