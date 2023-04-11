//
//  UIApplication.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 12/04/2023.
//

import UIKit

// MARK: - Tìm màn hình đang hiển thị
extension UIApplication {
    
    var keyWindowDev: UIWindow? {
        if #available(iOS 15, *) {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?
                .keyWindow
        } else if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindowDev?.rootViewController) -> UIViewController? {
        
        if let tabBarController = controller as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return topViewController(controller: selectedViewController)
        }
        
        if let navigationController = controller as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return topViewController(controller: visibleViewController)
        }
        
        if let presentedViewController = controller?.presentedViewController {
            return topViewController(controller: presentedViewController)
        }
        
        return controller
    }
}

// Tạo một UIViewController để code mẫu cho trường hợp muốn xoay màn hình ngang
class ExampleViewController: UIViewController { }
