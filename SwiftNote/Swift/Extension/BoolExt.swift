//
//  BoolExt.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 17/12/2022.
//

import Foundation

extension Bool {
    var int: Int { self ? 1 : 0 }
    var string: String { self ? "true" : "false" }
}
