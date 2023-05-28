//
//  UIControl.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 28/05/2023.
//

import UIKit

extension UIControl {
    /// Thoát ứng dụng và trở về màn hình chính (đưa về trạng thái background)
    static func backToHomeScreen() {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        /// HOẶC
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
}
