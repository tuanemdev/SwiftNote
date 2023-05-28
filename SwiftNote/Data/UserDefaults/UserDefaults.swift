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
 Sử dụng Apple Configurator https://apps.apple.com/app/apple-configurator/id1037126344
 + Đăng nhập Apple Configurator với Apple ID trùng với tài khoản sử dụng đăng nhập trên điện thoại
 + Kết nối điện thoại với macOS qua cáp
 + Dùng Finder đi tới địa chỉ: ~/Library/Group Containers/K36BKF7T3D.group.com.apple.configurator/Library/Caches/Assets/TemporaryItems/MobileApps
   (Nếu chưa từng dùng Apple Configurator thì dừng lại ở thư mục Assets vì 2 folder kia chưa được tạo)
 + Chọn thêm App, chọn App muốn cài vào iPhone và đợi
   Khi App đó chưa có trên iPhone thì file cache .ipa sẽ bị xoá đi rất nhanh nên tốt nhất là chọn cài những App đã có trên iPhone.
   Lúc này iPhone sẽ hỏi là App đó đã có rồi bạn muốn ... làm gì với nó? Đây là khoảng thời gian mà file .ipa cache không bị xoá và ta có thể tận dụng để lấy file .ipa
   (trick: các file .ipa khi dùng tính năng update App trên iPhone có thời gian xoá lâu, chẳng hạn khi tắt macOS đi nên nếu App cần lấy đúng lúc nó có bản cập nhật có thể tận dụng)
 + Đổi tên .ipa thành .zip, giải nén file .zip vừa tạo. Tìm tới App trong folder Payload và chọn Show Package Contents
 Tuy nhiên cách trên cũng chỉ mới hiển thị được nội dung của App mới tinh, chưa lấy được thông tin người dùng (Info.plist, các file Resource)
 */
