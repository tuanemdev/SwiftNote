//
//  UserDefaults.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 20/03/2023.
//

/*
 Dùng để lưu những thông tin đơn giản với các kiểu dữ liệu cơ bản, không cần bảo mật
 */

/*
 Cách lấy data lưu trong UserDefaults
 
 // Khởi tạo data để lấy làm ví dụ
 UserDefaults.standard.set("valueTest", forKey: "keyTest")
 UserDefaults(suiteName: "CustomUserDefaults")?.set("valueTest", forKey: "keyTest")
 
 Đối với standard thì file được lưu sẽ có tên: <Bundle identifier>.plist ==> com.tuanem.SwiftNote.plist
 Đối với custom UserDefaults file sẽ có tên: <suiteName>.plist ==> CustomUserDefaults.plist
 
 Path: /Library/Preferences
 Simulator
 print(NSHomeDirectory())
 print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
 
 Real Device
 DEBUG:
 + Không dùng App:
 Window -> Devices and Simulators (⇧⌘2) ->
 chọn App -> icon bánh răng ->
 Download Container -> chọn nơi lưu ->
 Mở file vừa lưu bằng tuỳ chọn: Show Package Contents
 
 + Dùng App bên thứ 3:
 iExplore: https://macroplant.com/
 iMazing: https://imazing.com/
 
 RELEASE:
 */
#warning("Incomplete: Get UserDefaults of Release App")
