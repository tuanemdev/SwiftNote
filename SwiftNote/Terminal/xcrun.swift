//
//  xcrun.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 08/02/2023.
//

// MARK: - xcrun simctl
/*
 0. Trợ giúp
 xcrun simctl help
 
 1. Liệt kê danh sách tất cả simulators
 xcrun simctl list
 xcrun simctl list --json (nếu muốn kết quả hiển thị dưới dạng json)
 
 2. Xoá simulators cũ và không khả dụng
 xcrun simctl delete unavailable
 
 3. Mở App Simulator
 open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/
 
 4. Khởi động một simulator (bằng ID hoặc Name - lấy từ lệnh list)
 xcrun simctl boot AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEE
 xcrun simctl boot "iPhone 14 Pro Max"
 
 5. Tắt simulator
 xcrun simctl shutdown booted
 xcrun simctl shutdown AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEE
 xcrun simctl shutdown "iPhone XS"
 xcrun simctl shutdown "iPhone-TuanEm"
 xcrun simctl shutdown all
 
 6. Tạo một simulator mới với tên tuỳ chỉnh
 xcrun simctl create iPhone-TuanEm com.apple.CoreSimulator.SimDeviceType.iPhone-8 com.apple.CoreSimulator.SimRuntime.iOS-10–3
 
 7. Xoá nội dung (đặt lại máy - factory restore)
 xcrun simctl erase AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEE
 xcrun simctl erase "iPhone-TuanEm"
 xcrun simctl erase "iPhone XS"
 xcrun simctl erase all
 
 8. Thêm Media File vào simulator
 xcrun simctl addmedia booted ./video_01.mp4
 xcrun simctl addmedia "iPhone XS" ./video_01.mp4
 
 9. Cài đặt App
 xcrun simctl install booted "./path/to/ios-app.app"
 xcrun simctl install "iPhone XS Max" "./path/to/ios-app.app"
 
 10. Xoá cài đặt App
 xcrun simctl uninstall booted com.mycompany.myapp
 xcrun simctl uninstall "iPhone XS Max" com.mycompany.myapp
 
 11. Khởi động App
 xcrun simctl launch booted com.mycompany.myapp
 xcrun simctl launch "iPhone XS Max" com.mycompany.myapp
 
 12. Tắt App
 xcrun simctl terminate booted com.mycompany.myapp
 xcrun simctl terminate "iPhone XS Max" com.mycompany.myapp
 
 13. Mở URL (Dùng để test Deep Link)
 xcrun simctl openurl booted https://google.com
 xcrun simctl openurl "iPhone XS Max" https://google.com
 
 14. Ghi hình simulator
 xcrun simctl io booted recordVideo — type=mp4 ./simulator-record_001.mp4
 xcrun simctl io "iPhone XS Max" recordVideo — type=mp4 ./simulator-record_001.mp4
 
 15. Chụp ảnh simulator
 xcrun simctl io booted screenshot ./simulator-screenshot_001.png
 xcrun simctl io "iPhone XS Max" screenshot ./simulator-screenshot_001.png
 
 16. Gửi push notification
 xcrun simctl push <device> <bundle-identifier> <path-to-apns-file>
 
 */
