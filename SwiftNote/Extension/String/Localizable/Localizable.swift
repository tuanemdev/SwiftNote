//
//  Localizable.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/11/2022.
//

import Foundation

extension String {
    func localized(tableName: String? = nil) -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}

protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var tableName: String {
        return String(describing: Self.self) // "Localizable" - If use Localizable.strings by default
    }
    var localized: String {
        return rawValue.localized(tableName: tableName)
    }
}

enum DataConstants: String, Localizable {
    case loadingData = "loading_data"
    case dataLoaded = "data_loaded"
}
