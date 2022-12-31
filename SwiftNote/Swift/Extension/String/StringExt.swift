//
//  StringExt.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 31/12/2022.
//

import Foundation

extension String {
    func decode<T: Decodable>() -> T? {
        guard let data = self.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
