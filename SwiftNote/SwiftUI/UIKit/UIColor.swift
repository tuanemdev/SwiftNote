//
//  UIColor.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 23/04/2023.
//

import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        let hexFormatted: String = UIColor.normalize(hexString)
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        self.init(
            red:    UIColorMask.redMask.value(rgbValue),
            green:  UIColorMask.greenMask.value(rgbValue),
            blue:   UIColorMask.blueMask.value(rgbValue),
            alpha:  UIColorMask.alphaMask.value(rgbValue)
        )
    }
    
    func hexDescription(_ includeAlpha: Bool = false) -> String {
        guard let components = self.cgColor.components,
              self.cgColor.numberOfComponents == 4
        else {
            return "Color not RGB."
        }
        
        let colors: [UInt64] = components.map { UInt64($0 * 255.0) }
        let color: String = .init(format: "%02x%02x%02x", colors[0], colors[1], colors[2])
        if includeAlpha {
            let alpha: String = .init(format: "%02x", colors[3])
            return "\(color)\(alpha)"
        }
        return color
    }
    
    private static func normalize(_ hexString: String) -> String {
        
        var hexString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst())
        }
        
        if Set(arrayLiteral: 3, 4).contains(hexString.count) {
            hexString = hexString.map { "\($0)\($0)" }.joined()
        }
        
        if hexString.count <= 6 {
            hexString += "FF"
        }
        
        assert(hexString.count == 8, "Invalid hex code used.")
        
        return hexString
    }
    
    private enum UIColorMask: UInt64 {
        
        case redMask    = 0xFF000000
        case greenMask  = 0x00FF0000
        case blueMask   = 0x0000FF00
        case alphaMask  = 0x000000FF
        
        var numberOfPlaces: some BinaryInteger {
            switch self {
            case .redMask:
                return 24
            case .greenMask:
                return 16
            case .blueMask:
                return 8
            case .alphaMask:
                return 0
            }
        }
        
        func value(_ rgbValue: UInt64) -> CGFloat {
            return CGFloat((rgbValue & self.rawValue) >> self.numberOfPlaces) / 255.0
        }
    }
    
}
