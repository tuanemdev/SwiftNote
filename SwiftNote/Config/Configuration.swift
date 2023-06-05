//
//  Configuration.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 05/06/2023.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    /// Lấy thông tin trong file Info.plist
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key)
        else { throw Error.missingKey }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}
