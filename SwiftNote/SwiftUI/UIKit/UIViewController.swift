//
//  UIViewController.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 23/04/2023.
//

import UIKit

extension UIViewController {
    // MARK: - Dismiss Keyboard
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Register and Remove Keyboard Notification
    // Call 2 method register in viewWillAppear
    func registerForKeyboardWillShowNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification -> Void in
            let userInfo: [AnyHashable: Any] = notification.userInfo!
            let keyboardSize: CGSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets: UIEdgeInsets = .init(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: keyboardSize.height, right: scrollView.contentInset.right)
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
        }
    }
    
    func registerForKeyboardWillHideNotification(_ scrollView: UIScrollView, usingBlock block: (() -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: 0, right: scrollView.contentInset.right)
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?()
        }
    }
    
    // Call in viewWillDisappear
    func removeObserverForKeyboardNotification(_ scrollView: UIScrollView) {
        NotificationCenter.default.removeObserver(scrollView, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(scrollView, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
