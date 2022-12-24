//
//  PushNotifications.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 20/12/2022.
//

import SwiftUI
import UserNotifications

extension AppDelegate {
    // MARK: - Register Notifications
    // Request quyền và đăng ký với APNs
    func registerForPushNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound, .provisional]) { [weak self] granted, error in
            guard granted else { return }
            center.delegate = self?.notificationDelegate
            Task { @MainActor in
                application.registerForRemoteNotifications()
            }
        }
    }
    
    // Đăng ký thành công và trả về Device Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token: String = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("Device Token: \(token)")
    }
    
    // Đăng ký lỗi và trả về lỗi
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Notification Center Delegate
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    
    // Mặc định iOS sẽ ẩn tất cả các notification đến khi App đang ở trạng thái foreground
    // để hiển thị chỉ cần implement method này, nó sẽ được gọi khi notification đến khi App đang ở trạng thái foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print("User Info: \(userInfo)")
        return [.banner, .badge, .sound]
    }
    
    // Một notification tốt thì không nên kèm theo bất kỳ hành động nào,
    // vì phần lớn người dùng sẽ không tap vào nó và họ nên nhận đủ thông tin cần thiết hiển thị ngay trên notification.
    // Tuy nhiên đôi khi cần thực thi một hành động nào đó khi tap vào notification thì method này sẽ được gọi.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        // có một actionIdentifier là UNNotificationDismissActionIdentifier, tuy nhiên không như cái tên, hàm này sẽ không được gọi khi user dismiss Noti
        let userInfo = response.notification.request.content.userInfo
        handleNotification(with: userInfo)
    }
    
    private func handleNotification(with userInfo: [AnyHashable: Any]) {
        guard let customValue1 = userInfo["customKey1"] as? String else { return }
        print("\(customValue1)")
    }
}

// MARK: - Setup Xcode Project
/*
 Bước 1: Project -> Select Targer -> Tab Signing & Capabilities -> + Capability -> Push Notifications (Cần tài khoản trả phí)
 Bước 2: Request quyền (ví dụ này đặt trong didFinishLaunchingWithOptions)
 Bước 3: Tải file Authentication Token .p8 (JWT - JSON Web Tokens)
 Bước 4: Tạo file payload.apns để test trên simulator cho thuận tiện (tệp đính kèm)
 */

// MARK: - Payload
/*
 Payload có cấu trúc dạng JSON, dung lượng tối đa 4KB (4096 bytes) nếu lớn hơn sẽ bị APNs từ chối.
 Cấu trúc của file JSON:
 Gồm key: aps là key chính và các sub-key trong object này được định nghĩa bởi Apple
 {
   "aps": {
     "alert": {
       "title": "Tiêu đề của push notification.", ==> Localizable.strings: title-loc-key, title-loc-args (mục đích localized phía App, tuy nhiên xử lý phía bên Server thì tốt hơn)
       "body": "Nội dung của push notification" ==> Localizable.strings: loc-key, loc-args (mục đích localized phía App, tuy nhiên xử lý phía bên Server thì tốt hơn)
     },
     "badge": 2, ==> Số hiện trên icon của App, để remove thì set lại giá trị về 0
     "sound": "filename.caf", ==> Âm thanh phát ra khi nhận push notification, được lấy ở main App'sBundle. Yêu cầu dưới 30s và là một trong 4 định dạng sau: Linear PCM, MA4, 𝝁Law, aLaw.
                                  Nếu không thoả mãn thì iOS sẽ sử dụng âm thanh default thay thế.
                                  Sử dụng dictionary nếu App cần gửi một push notification dạng khẩn cấp, sẽ phát âm thanh ngay cả khi bật chế độ không làm phiền (cần khai trong entitlement với Apple)
                                  "sound": {
                                    "critical": 1, ==> set bằng 1 để thông báo rằng đây là một push notification khẩn cấp
                                    "name": "filename.caf", ==> giống như mô tả TH mặc định phía bên trên
                                    "volume": 0.75 ==> âm lượng chạy từ 0.0 (silent) đến 1 (max volume)
                                  }
     "thread-id": "Các push notification có cùng thread-id sẽ được group lại với nhau", ==> Nếu không có trường này thì mặc định sẽ group toàn bộ push notification của 1 App lại làm một"
     "content-available": 1, ==> Sử dụng cho silent push, giá trị 1 để nói với iOS đó là silent push, sẽ không hiển thị như push notification thông thường và đánh thức App khi nhận được notification.
                                 Do App được đánh thức trong background nên cần thêm Background Modes ở phần Setting Capability và tích chọn vào mục Remote notifications.
                                 Không quên cập nhật apns-priority bằng 5 ở HTTP headers như mô tả phía dưới, nếu không sẽ xảy ra lỗi.
   },
   "customKey1": "customValue1", ==> Mọi thứ bên ngoài aps được sử dụng cho mục đích gửi thêm các thông tin bổ sung (tự do custom) cho phía App để thực hiện các yêu cầu từ push notification
   "customKey2": {
     "subKey21": "subValue21",
     "subKey22": "subValue22"
   }
 }
 */

/*
 HTTP headers
 apns-collapse-id: thay thế push notification cũ có cùng giá trị bằng push notification mới gửi đến
 apns-push-type:
 apns-priority: giá trị mặc định là 10, sẽ được gửi đi ngay lập tức. Mọi push notification có chứa content-available key đều phải set apns-priority bằng 5, nếu không sẽ xảy ra lỗi.
 */
