//
//  File.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 11/06/2023.
//

import Foundation

struct File {
    static let shared: File = .init()
    private init() { }
    
    var ducumentURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
}
