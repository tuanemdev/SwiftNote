//
//  UIScrollView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 23/04/2023.
//

import UIKit

extension UIScrollView {
    // MARK: - Set ContentInset
    func setContentInsetAndScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) {
        self.contentInset = edgeInsets
        self.scrollIndicatorInsets = edgeInsets
    }
}
