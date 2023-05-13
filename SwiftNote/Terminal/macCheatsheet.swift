//
//  macCheatsheet.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 11/02/2023.
//

// MARK: - Mac Terminal Commands
/*
 Link thao khảo: https://github.com/0nn0/terminal-mac-cheatsheet/tree/master/Ti%E1%BA%BFng%20Vi%E1%BB%87t
 open .     mở folder hiện tại
 pwd        lấy path của folder hiện tại
 */

// MARK: - Homebrew
/*
 Cài các gói phụ thuộc cho macOS
 Trang chủ: https://brew.sh/
 Lệnh cài: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
 */

// MARK: - CocoaPods
/*
 Trang chủ: https://cocoapods.org
 
 Trước đây cài CocoaPods thường sử dụng luôn dòng lệnh gem có sẵn trong mac
 Lệnh cài: sudo gem install cocoapods
 Nó vẫn hoạt động tốt trên các máy chạy chip Intel, tuy nhiên đối với các dòng máy chạy chip ARM sẽ có lỗi xảy ra
 
 Cách tốt nhất để cài CocoaPods là cài đặt thông qua Homebrew
 Xoá CocoaPods đã cài trước đó (nếu có): sudo gem uninstall cocoapods
 Lệnh cài thông qua Homebrew: brew install cocoapods
 */
