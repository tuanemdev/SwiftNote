//
//  FloatingPointExt.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 17/12/2022.
//

import Foundation

extension FloatingPoint {
    var degreesToRadians: Self { Self.pi * self / Self(180) }
    var radiansToDegrees: Self { self * Self(180) / Self.pi }
}

postfix operator %
extension FloatingPoint {
    static postfix func % (_ number: Self) -> Self {
        number / 100
    }
}
