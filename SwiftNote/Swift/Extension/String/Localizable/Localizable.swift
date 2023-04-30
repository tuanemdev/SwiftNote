//
//  Localizable.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/11/2022.
//

import Foundation
import UIKit

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

// MARK: - UIKit Components (via Interface Builder)
@IBDesignable
final class UILocalizedLabel: UILabel {
    
    @IBInspectable
    var tableName: String? {
        didSet {
            guard let tableName = tableName else { return }
            text = text?.localized(tableName: tableName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
    }
}

final class UILocalizedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        let title = self.title(for: .normal)?.localized()
        setTitle(title, for: .normal)
    }
}

// Áp dụng tương tự cho các Components muốn localized thông qua IB

// MARK: - Cách để cho người dùng chọn language không tự động ăn theo setting của máy
enum Language: String, CaseIterable {
    case english    = "en"
    case vietnamese = "vi"
    
    static var current: Language {
        get {
            guard let languageCode = UserDefaults.standard.string(forKey: "languageCode"),
                  let language = Language(rawValue: languageCode)
            else { return .english }
            return language
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "languageCode")
        }
    }
}

extension String {
    // Hoặc sửa Extension localized(tableName:) phía trên nếu muốn kết hợp với việc chia nhỏ file Localizable
    var localized: String {
        let language = Language.current
        let bundle: Bundle
        
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            bundle = langBundle
        } else {
            bundle = Bundle.main
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "**\(self)**", comment: "")
    }
}
