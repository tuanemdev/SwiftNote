//
//  DataExt.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 25/01/2023.
//

import Foundation

extension Data {
    var utf8: String {
        String(decoding: self, as: UTF8.self)
    }
}
